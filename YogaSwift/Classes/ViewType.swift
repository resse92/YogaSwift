//
//  Nodable.swift
//  Flexbox
//
//  Created by resse on 2020/9/18.
//

public protocol ViewType: AnyObject {
    var flexSpec: FlexSpec { get }
    var parent: (any ViewType)? { get }
    
    func sizeThatFits(_ size: CGSize) -> CGSize
    
    func addSubItem(item: any ViewType) -> Bool
    func removeFromParent() -> Bool
    
    var frame: CGRect { set get }
    
    func didCalculateLayout()
}
