//
//  Node.swift
//  Flexbox
//
//  Created by resse on 2020/6/5.
//

import UIKit

private var flexLayoutAssociatedObjectHandle = 125_312_282_1

extension UIView: Flexable {
    
    var flexEnabled: Bool {
        let obj = objc_getAssociatedObject(self, &flexLayoutAssociatedObjectHandle) as? FlexSpec
        return obj != nil
    }
    
    public var parent: (any Flexable)? {
        self.superview
    }
    
    public var flexSpec: FlexSpec {
        if let flex = objc_getAssociatedObject(self, &flexLayoutAssociatedObjectHandle) as? FlexSpec {
            return flex
        } else {
            let flex = FlexSpec(self)
            objc_setAssociatedObject(self, &flexLayoutAssociatedObjectHandle, flex, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return flex
        }
    }
    
    public func addSubItem(item: any Flexable) -> Bool {
        if let view = item as? UIView, view.superview != self {
            self.addSubview(view)
            return true
        }
        
        return false
    }
    
    public func removeFromParent() -> Bool {
        self.removeFromSuperview()
        return true
    }
}
