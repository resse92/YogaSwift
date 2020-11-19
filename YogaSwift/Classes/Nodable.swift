//
//  Nodable.swift
//  Flexbox
//
//  Created by AlexZHU on 2020/9/18.
//

public protocol Nodable: AnyObject {
    var flex: VirtualNode { get }
    var frame: CGRect { set get }
    func sizeThatFits(_ size: CGSize) -> CGSize
    func addSubItem(item: Nodable) -> Bool
}

extension Nodable {
    
//    func addSubItem(item: Nodable) -> Bool {
//        return false
//    }
//    
//    func sizeThatFits(_ size: CGSize) -> CGSize {
//        return CGSize.zero
//    }
//    
//    var frame: CGRect {
//        set {}
//        get { return self.flex.frame }
//    }
}
