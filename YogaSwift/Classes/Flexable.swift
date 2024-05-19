//
//  Nodable.swift
//  Flexbox
//
//  Created by resse on 2020/9/18.
//

public protocol Flexable: AnyObject {
    var flexSpec: FlexSpec { get }
    var parent: (any Flexable)? { get }
    
    func sizeThatFits(_ size: CGSize) -> CGSize
    
    func addSubItem(item: any Flexable) -> Bool
    func removeFromParent() -> Bool
    
    var frame: CGRect { set get }
}
