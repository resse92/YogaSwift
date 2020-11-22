//
//  Node.swift
//  Flexbox
//
//  Created by AlexZHU on 2020/6/5.
//

import UIKit

private var flexLayoutAssociatedObjectHandle = 125_312_282_1

extension UIView: Nodable {
    public var flex: VirtualNode {
        if let flex = objc_getAssociatedObject(self, &flexLayoutAssociatedObjectHandle) as? VirtualNode {
            return flex
        } else {
            let flex = VirtualNode(self)
            objc_setAssociatedObject(self, &flexLayoutAssociatedObjectHandle, flex, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return flex
        }
    }
    
    public func addSubItem(item: Nodable) -> Bool {
        if let view = item as? UIView {
            self.addSubview(view)
            return true
        }
        
        return self.layer.addSubItem(item: item)
    }
}

extension CALayer: Nodable {
    public func sizeThatFits(_ size: CGSize) -> CGSize {
        CGSize.zero
    }
    
    public var flex: VirtualNode {
        if let flex = objc_getAssociatedObject(self, &flexLayoutAssociatedObjectHandle) as? VirtualNode {
            return flex
        } else {
            let flex = VirtualNode(self)
            objc_setAssociatedObject(self, &flexLayoutAssociatedObjectHandle, flex, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return flex
        }
    }
    
    public func addSubItem(item: Nodable) -> Bool {
        if let layer = item as? CALayer {
            self.addSublayer(layer)
            return false // layer只加入到superLayer，不加入其它层级关系
        }
        return false
    }
}

public extension VirtualNode {
    
    @discardableResult
    func addItem(_ view: UIView) -> VirtualNode {
        self.addItem(view.flex)
    }
    
    @discardableResult
    func addItem(_ layer: CALayer) -> VirtualNode {
        self.addItem(layer.flex)
    }
}
