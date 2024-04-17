//
//  Node.swift
//  Flexbox
//
//  Created by resse on 2020/6/4.
//  Copyright © 2020 resse. All rights reserved.
//

import UIKit

private let screenScale = UIScreen.main.scale

public final class FlexSpec {
    
    private class Context {
        weak var node: FlexSpec?
        init(_ node: FlexSpec) {
            self.node = node
        }
        
        func sizeThatFits(_ size: CGSize) -> CGSize {
            self.node?.obj?.sizeThatFits(size) ?? .zero
        }
    }
    
    lazy var ygNode: YGNodeRef = {
        let globalConfig = YGConfigNew()
        YGConfigSetExperimentalFeatureEnabled(
            globalConfig,
            YGExperimentalFeatureWebFlexBasis,
            true
        )
        YGConfigSetPointScaleFactor(globalConfig, Float(screenScale))
        return YGNodeNewWithConfig(globalConfig)
    }()
    
    private var context: Context?
    
    weak var obj: Nodable?
    
    public weak var parent: FlexSpec?
    var children = [FlexSpec]()
    
    // Mark as alwaysDirty means that calculate this node's frame every time
    var alwaysDirty = false
    public var isEnabled = true
    
    required init() {
        let context = Context(self)
        let ptr = Unmanaged.passRetained(context).toOpaque()
        YGNodeSetContext(self.ygNode, ptr)
    }
    
    var isLeaf: Bool {
        isEnabled && self.children.contains(where: { $0.isEnabled }) == false
    }
    
    var isRoot: Bool {
        self.parent == nil
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
    
    deinit {
        YGNodeFree(self.ygNode)
    }
}

// MARK: -- children // TODO: need more
extension FlexSpec {
    
    @discardableResult
    private func add(node: Nodable?, to parent: Nodable?) -> Bool {
        guard let node = node else {
            return false
        }
        if self.obj == nil && self.parent?.obj == nil {
            assert(true, "no superview to add, must check it")
            return false
        }
        
        let bool = self.obj?.addSubItem(item: node)
        if bool != true {
            return self.add(node: node, to: self.parent?.obj)
        }
        return true
    }
    
    @discardableResult
    final public func append(_ item: FlexSpec) -> FlexSpec {
        self.children.append(item)
        YGNodeInsertChild(self.ygNode, item.ygNode, self.children.count - 1)
        item.parent = self
        self.add(node: item.obj, to: self.obj)
        return item
    }
    
    @discardableResult
    final public func insert(_ item: FlexSpec, index: Int) -> FlexSpec {
        assert(index < self.children.count, "index out of boundry")
        self.children.insert(item, at: index)
        item.parent = self
        YGNodeInsertChild(self.ygNode, item.ygNode, index)
        self.add(node: item.obj, to: self.obj)
        return item
    }
    
    @discardableResult
    final func removeFromParent() -> FlexSpec {
        if let parent = self.parent {
            parent.children.removeAll(where: { $0 == self })
            _ = self.obj?.removeFromParent()
            YGNodeRemoveChild(parent.ygNode, self.ygNode)
        }
        self.parent = nil
        return self
    }
    
    @discardableResult
    final func build(@FlexBuilder _ builder: () -> [FlexSpec]) -> FlexSpec {
        let nodes = builder()
        self.children.reserveCapacity(self.children.count + nodes.count)
        nodes.forEach {
            self.append($0)
        }
        return self
    }
    
    @discardableResult
    final func build(@FlexBuilder _ builder: () -> FlexSpec) -> FlexSpec {
        let nodes = [builder()]
        self.children.reserveCapacity(self.children.count + nodes.count)
        nodes.forEach {
            self.append($0)
        }
        return self
    }
}

// MARK: - Private Method
private extension FlexSpec {
    
    // apply layout frame to each obj item
    func applyLayoutToObj(parent: CGRect?, parentItem: Nodable?) {
        __YogaSwiftAssertMainQueue()
        
        guard self.isEnabled else {
            return
        }
        
        var parentFrame = parent ?? CGRect.zero
        
        func roundPixelValue(_ value: CGFloat) -> CGFloat {
            let rounds = screenScale * 100 // 保留两位小数
            return round(value * rounds) / rounds
        }
        
        let topLeft = CGPoint(
            x: CGFloat(YGNodeLayoutGetLeft(self.ygNode)),
            y: CGFloat(YGNodeLayoutGetTop(self.ygNode))
        )
        
        let bottomRight = CGPoint(
            x: CGFloat(YGNodeLayoutGetWidth(self.ygNode)) + topLeft.x,
            y: CGFloat(YGNodeLayoutGetHeight(self.ygNode)) + topLeft.y
        )
        
        let left = parentFrame.minX + roundPixelValue(topLeft.x)
        let top = parentFrame.minY + roundPixelValue(topLeft.y)
        
        let width = roundPixelValue(bottomRight.x - topLeft.x)
        let height = roundPixelValue(bottomRight.y - topLeft.y)
        
        let frame = CGRect(x: left, y: top, width: width, height: height)
        
        var shouldUseCurrentCoordinator = false
        
        parentFrame = frame
        if let real = self.obj {
            if !self.isRoot {
                real.frame = frame
            }
            
            if parentItem == nil || parentItem?.addSubItem(item: real) == true {
                parentFrame = CGRect.zero
                shouldUseCurrentCoordinator = true
            }
        }
        
        if !self.isLeaf {
            self.children.forEach {
                $0.applyLayoutToObj(
                    parent: parentFrame,
                    parentItem: (shouldUseCurrentCoordinator ? self.obj : nil) ?? parentItem)
            }
        }
    }
}

/// MARK: - layout
public extension FlexSpec {
    
    func layout(mode: LayoutMode = .fitContainer, syncFrame: Bool = true) {
        var width = Float.greatestFiniteMagnitude
        var height = Float.greatestFiniteMagnitude
        
        if let real = self.obj {
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
            self.applyLayoutToObj(parent: self.obj?.frame, parentItem: nil)
        }
    }
    
    func markDirty() {
        if !self.isLeaf {
            return
        }
        YGNodeMarkDirty(self.ygNode)
    }
    
    var dirty: Bool {
        YGNodeIsDirty(self.ygNode)
    }
    
    func alwaysDirty(_ isDirty: Bool) -> FlexSpec {
        self.alwaysDirty = isDirty
        return self
    }
    
    @discardableResult
    final func calculateLayout(size: CGSize = CGSize.zero) -> CGSize {
        if (self.alwaysDirty) {
            self.markDirty()
        }
        YGNodeCalculateLayout(
            self.ygNode,
            Float(size.width),
            Float(size.height),
            YGNodeStyleGetDirection(self.ygNode)
        )
        
        return CGSize(
            width: CGFloat(YGNodeLayoutGetWidth(self.ygNode)),
            height: CGFloat(YGNodeLayoutGetHeight(self.ygNode))
        )
    }
}

// MARK: static function
extension FlexSpec {
    private static let measureFunc: YGMeasureFunc = { (node, width, widthMode, height, heightMode) in
        let constrainedWidth = widthMode == YGMeasureModeUndefined ? Float.greatestFiniteMagnitude : width
        let constrainedHeight = heightMode == YGMeasureModeUndefined ? Float.greatestFiniteMagnitude: height
        
        let constrainedSize = CGSize(width: CGFloat(constrainedWidth), height: CGFloat(constrainedHeight))
        
        let measureSize: CGSize
        
        if let ptr = YGNodeGetContext(node) {
            let context = Unmanaged<Context>.fromOpaque(ptr).takeUnretainedValue()
            let constrainedSize = CGSize(width: CGFloat(constrainedWidth), height: CGFloat(constrainedHeight))
            measureSize = context.sizeThatFits(constrainedSize)
        } else {
            measureSize = .zero
        }
        
        return YGSize(
            width: sanitizeMeasurement(constrainedWidth, Float(measureSize.width), widthMode),
            height: sanitizeMeasurement(constrainedHeight, Float(measureSize.height), heightMode)
        )
    }

    private static func sanitizeMeasurement(_ constrained: Float, _ measured: Float, _ mode: YGMeasureMode) -> Float {
        switch mode {
        case YGMeasureModeExactly:
            return constrained
        case YGMeasureModeAtMost:
            return min(constrained, measured)
        case YGMeasureModeUndefined:
            return measured
        default:
            fatalError()
        }
    }
}

extension FlexSpec: Equatable {
    public static func == (lhs: FlexSpec, rhs: FlexSpec) -> Bool {
        let node1 = lhs.ygNode
        let node2 = rhs.ygNode
        guard YGNodeGetChildCount(node1) == YGNodeGetChildCount(node2) else {
            return false
        }
        
        return node1 == node2
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
