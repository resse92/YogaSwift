//
//  Nodable.swift
//  Flexbox
//
//  Created by resse on 2020/9/18.
//

public protocol ViewType: AnyObject {
    var flexSpec: FlexSpec { get }
    var frame: CGRect { set get }
    var parent: (any ViewType)? { get }
    func sizeThatFits(_ size: CGSize) -> CGSize
    func addSubItem(item: any ViewType) -> Bool
    func removeFromParent() -> Bool
}

func __YogaSwiftAssertMainQueue() {
    assert(Thread.isMainThread, "The function must run in main queue")
}
