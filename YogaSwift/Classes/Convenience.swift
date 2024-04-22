//
//  Convenience.swift
//  Flexbox
//
//  Created by resse on 2020/9/8.
//

import Foundation

// Horizontal Flex default: FlexSpec().direction(.row)
@discardableResult
public func Row(
    _ node: (any ViewType)? = nil,
    reversed: Bool = false,
    @FlexBuilder content: () -> [FlexSpec]
) -> FlexSpec {
    (node?.flexSpec ?? FlexSpec())
        .direction(reversed ? .rowReverse : .row)
        .build(content)
}

// Vertical Flex default: FlexSpec().direction(.column)
@discardableResult
public func Column(
    _ node: (any ViewType)? = nil,
    reversed: Bool = false,
    @FlexBuilder content: () -> [FlexSpec]
) -> FlexSpec {
    (node?.flexSpec ?? FlexSpec())
        .direction(reversed ? .columnReverse : .column)
        .build(content)
}

@discardableResult
public func Absolute(
    _ node: (any ViewType)? = nil,
    @FlexBuilder content: () -> [FlexSpec]
) -> FlexSpec {
    (node?.flexSpec ?? FlexSpec())
        .position(.absolute)
        .build(content)
}
@discardableResult
public func Static(
    _ node: (any ViewType)? = nil,
    @FlexBuilder content: () -> [FlexSpec]
) -> FlexSpec {
    (node?.flexSpec ?? FlexSpec())
        .position(.static)
        .build(content)
}



extension FlexSpec {
    convenience init(_ node: (any ViewType)?) {
        self.init()
        if let node = node {
            obj = node
        }
    }
}
