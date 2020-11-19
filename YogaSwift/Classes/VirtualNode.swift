//
//  Node.swift
//  Flexbox
//
//  Created by AlexZHU on 2020/6/4.
//  Copyright © 2020 AlexZHU. All rights reserved.
//

import UIKit
import yoga

private let screenScale = UIScreen.main.scale

public final class VirtualNode {
    
    // Mark as alwaysDirty means that calculate this node's frame every time
    var alwaysDirty = false
    
    public var isEnabled = true
    
    private struct Context {
        var sizeThatFits: (CGSize) -> CGSize
        init(sizeThatFits: @escaping (CGSize) -> CGSize) {
            self.sizeThatFits = sizeThatFits
        }
    }
    
    private var context: Context!
    
    private var ygNodeInit = false
    lazy var ygNode: YGNodeRef = {
        let globalConfig = YGConfigNew()
        YGConfigSetExperimentalFeatureEnabled(globalConfig, .webFlexBasis, true)
        YGConfigSetPointScaleFactor(globalConfig, Float(screenScale))
        self.ygNodeInit = true
        return YGNodeNewWithConfig(globalConfig)
    }()
    
    weak var real: Nodable?
    
    var children = [VirtualNode]()
    
    public init() {
        context = Context.init(sizeThatFits: sizeThatFits(size:))
        YGNodeSetContext(self.ygNode, &context)
    }
    
    var isLeaf: Bool {
        !(isEnabled && self.children.first(where: {$0.isEnabled}) != nil)
    }
    
    // Node's Frame, Attention: not UIView's frame
    var frame: CGRect {
        return CGRect(
            x: CGFloat(YGNodeLayoutGetLeft(self.ygNode)),
            y: CGFloat(YGNodeLayoutGetTop(self.ygNode)),
            width: CGFloat(YGNodeLayoutGetWidth(self.ygNode)),
            height: CGFloat(YGNodeLayoutGetHeight(self.ygNode))
        )
    }
    
    private func sizeThatFits(size: CGSize) -> CGSize {
        return self.real?.sizeThatFits(size) ?? CGSize.zero
    }
    
    deinit {
        if self.ygNodeInit {
            YGNodeFree(self.ygNode)
        }
    }
}

// children
public extension VirtualNode {
    @discardableResult
    final func addItem(_ item: VirtualNode = VirtualNode()) -> VirtualNode {
        self.children.append(item)
        return item
    }
    
    @discardableResult
    final func build(@FlexBuilder _ builder: () -> [Flexable]) -> VirtualNode {
        self.children = builder().map(\.vNode)
        return self
    }
    
    @discardableResult
    final func build(@FlexBuilder _ builder: () -> Flexable) -> VirtualNode {
        self.children = [builder().vNode]
        return self
    }
    
    func alwaysDirty(_ isDirty: Bool) -> VirtualNode {
        self.alwaysDirty = isDirty
        return self
    }
}

// MARK: - Private Method
private extension VirtualNode {
    
    func tryReattachNodes(nodes: [VirtualNode]) {
        if YGNodeGetChildCount(self.ygNode) != self.children.count {
            YGNodeRemoveAllChildren(self.ygNode)
        }
        nodes.enumerated().forEach {
            let (offset, element) = $0
            let targetChild = YGNodeGetChild(self.ygNode, UInt32($0.offset))
            if targetChild != $0.element.ygNode {
                if targetChild != nil {
                    YGNodeRemoveChild(YGNodeGetParent(element.ygNode), element.ygNode)
                }
                
                YGNodeInsertChild(self.ygNode, $0.element.ygNode, UInt32(offset) )
            }
        }
    }
    
    func attachNodes() {
        let node = self.ygNode
        if self.isLeaf {
            YGNodeRemoveAllChildren(node)
            YGNodeSetMeasureFunc(node, VirtualNode.measureFunc)
        } else {
            YGNodeSetMeasureFunc(node, nil)
//            self.children = self.children.filter { YGNodeGetParent($0.ygNode) == self.ygNode }
            let subNodeToInclude = self.children.filter { $0.isEnabled }
            
            tryReattachNodes(nodes: subNodeToInclude)
            subNodeToInclude.forEach({ $0.attachNodes() })
        }
    }
    
    // apply layout frame to each real item
    func applyLayoutToReal(parent: CGRect?, parentItem: Nodable?) {
        assert(Thread.isMainThread, "Flexbox setting frame should only be on the main thread")
        
        guard self.isEnabled else {
            return
        }
        
        var parentFrame = parent ?? CGRect.zero
        
        func roundPixelValue(_ value: CGFloat) -> CGFloat {
            return CGFloat(roundf(Float(value * screenScale))) / screenScale
        }
        
        let topLeft = CGPoint(x: CGFloat(YGNodeLayoutGetLeft(self.ygNode)),
                              y: CGFloat(YGNodeLayoutGetTop(self.ygNode)))
        
        let bottomRight = CGPoint(x: CGFloat(YGNodeLayoutGetWidth(self.ygNode)) + topLeft.x,
                                  y: CGFloat(YGNodeLayoutGetHeight(self.ygNode)) + topLeft.y)
        
        let left = parentFrame.minX + roundPixelValue(topLeft.x)
        let top = parentFrame.minY + roundPixelValue(topLeft.y)
        
        let width = roundPixelValue(bottomRight.x - topLeft.x)
        let height = roundPixelValue(bottomRight.y - topLeft.y)
        
        let frame = CGRect(x: left, y: top, width: width, height: height)
        
        var shouldUseCurrentCoordinator = false
        
        parentFrame = frame
        if let real = self.real {
            real.frame = frame
            if parentItem == nil || parentItem?.addSubItem(item: real) == true {
                parentFrame = CGRect.zero
                shouldUseCurrentCoordinator = true
            }
        }
        
        if !self.isLeaf {
            self.children.forEach({ $0.applyLayoutToReal(parent: parentFrame, parentItem: (shouldUseCurrentCoordinator ? self.real : nil) ?? parentItem) })
        }
    }
}

/// MARK: - layout
public extension VirtualNode {
    
    func layout(mode: LayoutMode = .fitContainer, syncFrame: Bool = true) {
        var width = Float.greatestFiniteMagnitude
        var height = Float.greatestFiniteMagnitude
        
        if let real = self.real {
            width = Float(real.frame.size.width)
            height = Float(real.frame.size.height)
        }
        
        if case .adjustWidth = mode {
            width = Float.nan
        } else if case .adjustHeight = mode {
            height = Float.nan
        }
        
        self.calculateLayout(size: CGSize(width: width, height: height))
        if syncFrame {
            self.applyLayoutToReal(parent: self.real?.frame, parentItem: nil)
        }
    }
    
    func markDirty() {
        if !self.isLeaf {
            return
        }
        YGNodeMarkDirty(self.ygNode)
    }
    
    @discardableResult
    final func calculateLayout(size: CGSize = CGSize.zero) -> CGSize {
        self.attachNodes()
        if (self.alwaysDirty) {
            YGNodeMarkDirty(self.ygNode)
        }
        YGNodeCalculateLayout(self.ygNode,
                              Float(size.width),
                              Float(size.height),
                              YGNodeStyleGetDirection(self.ygNode))
        
        return CGSize(width: CGFloat(YGNodeLayoutGetWidth(self.ygNode)),
                      height: CGFloat(YGNodeLayoutGetHeight(self.ygNode)))
        
    }
}

// static
extension VirtualNode {
    private static let measureFunc: @convention(c) (YGNodeRef?, Float, YGMeasureMode, Float, YGMeasureMode) -> YGSize = { (node, width, widthMode, height, heightMode) in
        let constrainedWidth = widthMode == .undefined ? Float.greatestFiniteMagnitude : width
        let constrainedHeight = heightMode == .undefined ? Float.greatestFiniteMagnitude: height
        
        var measureSize = CGSize.zero
        if let context = YGNodeGetContext(node)?.assumingMemoryBound(to: Context.self).pointee {
            let constrainedSize = CGSize(width: CGFloat(constrainedWidth), height: CGFloat(constrainedHeight))
            measureSize = context.sizeThatFits(constrainedSize)
        }
        
        return YGSize(width: sanitizeMeasurement(constrainedWidth, Float(measureSize.width), widthMode),
                      height: sanitizeMeasurement(constrainedHeight, Float(measureSize.height), heightMode))
    }

    private static func sanitizeMeasurement(_ constrained: Float, _ measured: Float, _ mode: YGMeasureMode) -> Float {
        switch mode {
        case .exactly:
            return constrained
        case .atMost:
            return min(constrained, measured)
        case .undefined:
            return measured
        @unknown default:
            fatalError()
        }
    }
}

extension VirtualNode: Equatable {
    public static func == (lhs: VirtualNode, rhs: VirtualNode) -> Bool {
        let node1 = lhs.ygNode
        let node2 = rhs.ygNode
        guard YGNodeGetChildCount(node1) == YGNodeGetChildCount(node2) else {
            return false
        }
        
        return true
    }
}

private extension CGRect {
    init(x: Float, y: Float, width: Float, height: Float) {
        self.init(x: CGFloat(x), y: CGFloat(y), width: CGFloat(width), height: CGFloat(height))
    }
}

private extension CGSize {
    init(width: Float, height: Float) {
        self.init(width: CGFloat(width), height: CGFloat(height))
    }
}
