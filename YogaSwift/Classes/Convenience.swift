//
//  Convenience.swift
//  Flexbox
//
//  Created by resse on 2020/9/8.
//

import Foundation

// Flex default: VirtualNode()
public func AFlex(_ node: Nodable? = nil) -> VirtualNode {
    return VirtualNode(node)
}

// Horizontal Flex default: VirtualNode().direction(.row)
public func Row(_ node: Nodable? = nil, reversed: Bool = false) -> VirtualNode {
    (node?.flex ?? AFlex(node)).direction(reversed ? .rowReverse : .row)
}

// Vertical Flex default: VirtualNode().direction(.column)
public func Column(_ node: Nodable? = nil, reversed: Bool = false) -> VirtualNode {
    (node?.flex ?? AFlex(node)).direction(reversed ? .columnReverse : .column)
}

extension VirtualNode {
    public convenience init(_ node: Nodable?) {
        self.init()
        if let node = node {
            obj = node
        }
    }
}
