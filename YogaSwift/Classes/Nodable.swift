//
//  Nodable.swift
//  Flexbox
//
//  Created by resse on 2020/9/18.
//

public protocol Nodable: AnyObject {
    var flexSpec: FlexSpec { get }
    var frame: CGRect { set get }
    var parent: (any Nodable)? { get }
    func sizeThatFits(_ size: CGSize) -> CGSize
    func addSubItem(item: any Nodable) -> Bool
    func removeFromParent() -> Bool
}
