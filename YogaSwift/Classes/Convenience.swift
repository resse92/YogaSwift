//
//  Convenience.swift
//  Flexbox
//
//  Created by resse on 2020/9/8.
//

import Foundation

// Horizontal Flex default: VirtualNode().direction(.row)
@discardableResult
public func Row(
    _ node: Nodable? = nil,
    reversed: Bool = false,
    @FlexBuilder content: () -> [Flexable]
) -> VirtualNode {
    (node?.flex ?? VirtualNode())
        .direction(reversed ? .rowReverse : .row)
        .build(content)
}

// Vertical Flex default: VirtualNode().direction(.column)
@discardableResult
public func Column(
    _ node: Nodable? = nil,
    reversed: Bool = false,
    @FlexBuilder content: () -> [Flexable]
) -> VirtualNode {
    (node?.flex ?? VirtualNode()).direction(reversed ? .columnReverse : .column)
        .build(content)
}

@discardableResult
public func Absolute(
    _ node: Nodable? = nil,
    @FlexBuilder content: () -> [Flexable]
) -> VirtualNode {
    (node?.flex ?? VirtualNode()).position(.absolute)
        .build(content)
}

@discardableResult
public func Static(
    _ node: Nodable? = nil,
    @FlexBuilder content: () -> [Flexable]
) -> VirtualNode {
    (node?.flex ?? VirtualNode()).position(.static)
        .build(content)
}



extension VirtualNode {
    convenience init(_ node: Nodable?) {
        self.init()
        if let node = node {
            obj = node
        }
    }
}
