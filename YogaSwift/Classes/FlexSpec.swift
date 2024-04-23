//
//  Node.swift
//  Flexbox
//
//  Created by resse on 2020/6/4.
//  Copyright © 2020 resse. All rights reserved.
//

import UIKit
import OSLog

private let screenScale = UIScreen.main.scale

public final class FlexSpec {
    
    private class Context {
        weak var spec: FlexSpec?
        init(_ spec: FlexSpec) {
            self.spec = spec
        }
        
        func sizeThatFits(_ size: CGSize) -> CGSize {
            self.spec?.obj?.sizeThatFits(size) ?? .zero
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
    
    weak var obj: (any ViewType)?
    
    public weak var parent: FlexSpec?
    var children = [FlexSpec]()
    
    public var isEnabled = true
    
    required init() {
        let context = Context(self)
        let ptr = Unmanaged.passRetained(context).toOpaque()
        YGNodeSetContext(self.ygNode, ptr)
    }
    
    var isLeaf: Bool {
        isEnabled && self.children.filter({ $0.isEnabled }).isEmpty
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

// MARK: -- children
extension FlexSpec {
    
    @discardableResult
    final public func append(_ item: FlexSpec) -> FlexSpec {
        self.children.append(item)
        YGNodeInsertChild(self.ygNode, item.ygNode, self.children.count - 1)
        item.parent = self
        return item
    }
    
    @discardableResult
    final public func insert(_ item: FlexSpec, index: Int) -> FlexSpec {
        assert(index < self.children.count, "index out of boundry")
        self.children.insert(item, at: index)
        item.parent = self
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
    func applyLayout(preserveOrigin: Bool) {
        __YogaSwiftAssertMainQueue()
        
        guard self.isEnabled else {
            return
        }
        
        // apply frame to obj
        if let obj = self.obj {
            let parentOrigin = findAncestorDistance(spec: self)
            
            let topLeft = CGPoint(
                x: CGFloat(YGNodeLayoutGetLeft(self.ygNode)),
                y: CGFloat(YGNodeLayoutGetTop(self.ygNode))
            )
            
            let bottomRight = CGPoint(
                x: CGFloat(YGNodeLayoutGetWidth(self.ygNode)) + topLeft.x,
                y: CGFloat(YGNodeLayoutGetHeight(self.ygNode)) + topLeft.y
            )
            
            let left = topLeft.x
            let top = topLeft.y
            
            let origin = CGPoint(x: left, y: top).applying(.init(translationX: parentOrigin.x, y: parentOrigin.y))
            let width = bottomRight.x - topLeft.x
            let height = bottomRight.y - topLeft.y
            
            let frame = CGRect(
                origin: preserveOrigin ? obj.frame.origin : origin,
                size: .init(width: width, height: height)
            )
            
            obj.frame = frame
        }
        
        if !self.isLeaf {
            self.children.forEach {
                $0.applyLayout(preserveOrigin: false)
            }
        }
    }
}

/// MARK: - layout
public extension FlexSpec {
    
    @discardableResult
    func layout(mode: LayoutMode = .fitContainer, applyLayout: Bool = true) -> CGSize {
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
        if applyLayout {
            self.applyLayout(preserveOrigin: true)
        }
        return CGSize(width: YGNodeLayoutGetWidth(self.ygNode), height: YGNodeLayoutGetHeight(self.ygNode))
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
        
    @discardableResult
    final func calculateLayout(size: CGSize = CGSize.zero) -> CGSize {
        Self.attachNodesFromHierachy(spec: self)
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
    /// add current obj to parent, if self.obj == nil, find child to add
    private static func add(spec: FlexSpec?, to parent: FlexSpec?) {
        guard let parentObj = parent?.obj else { //
            return
        }
        if let obj = spec?.obj {
            _ = parentObj.addSubItem(item: obj)
        } else {
            spec?.children.forEach { subspec in
                add(spec: subspec, to: parent)
            }
        }
        return
    }
    
    private static func attachNodesFromHierachy(spec: FlexSpec) {
        if spec.isLeaf {
            YGNodeRemoveAllChildren(spec.ygNode)
            YGNodeSetMeasureFunc(spec.ygNode, measureFunc)
        } else {
            YGNodeSetMeasureFunc(spec.ygNode, nil)
                        
            for (index, child) in spec.children.enumerated() {
                let ygChild = YGNodeGetChild(spec.ygNode, index)
                if ygChild == child.ygNode {
                    continue
                }
                YGNodeInsertChild(spec.ygNode, child.ygNode, index)
            }
        }
        spec.children.forEach { child in
            attachNodesFromHierachy(spec: child)
        }
        
        
        if spec.isRoot == false {
            add(spec: spec, to: spec.parent)
        }
    }
    
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
        return node1 == node2 && lhs.children == rhs.children
    }
}

private func roundPixelValue(_ value: CGFloat) -> CGFloat {
    let rounds = screenScale
    let v = round(value * rounds) / rounds
    return round(v * 100) / 100
}

private func findAncestorDistance(spec: FlexSpec) -> CGPoint {
    guard let parent = spec.obj?.parent, let parentSpec = spec.parent else {
        return .zero
    }
    
    func findAncestorDistance(point: CGPoint, obj: any ViewType, spec: FlexSpec) -> CGPoint {
        if obj.flexSpec == spec {
            return point
        }
        
        guard let parent = spec.parent else {
            assertionFailure("fatal error find same parent of spec and obj")
            return .zero
        }
        
        return findAncestorDistance(
            point: CGPoint(x: spec.frame.minX + point.x, y: spec.frame.minY + point.y),
            obj: obj,
            spec: parent
        )
    }
    
    return findAncestorDistance(point: .zero, obj: parent, spec: parentSpec)
}
