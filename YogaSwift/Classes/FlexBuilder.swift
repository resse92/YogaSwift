//
//  FlexBuilder.swift
//  Flexbox
//
//  Created by AlexZHU on 2020/9/8.
//

import Foundation

public protocol Flexable {
    var vNode: VirtualNode { get }
}

extension UIView: Flexable {
    public var vNode: VirtualNode {
        return self.flex
    }
}

extension CALayer: Flexable {
    public var vNode: VirtualNode {
        return self.flex
    }
}

extension VirtualNode: Flexable {
    public var vNode: VirtualNode {
        return self
    }
}

@_functionBuilder
public struct FlexBuilder {
    
    public static func buildBlock(_ node: Flexable) -> [Flexable] {
        [node]
    }
    
    public static func buildBlock(_ nodes: Flexable...) -> [Flexable] {
        nodes
    }
    
//    public static func buildExpression<Flexable>(_ nodes: Flexable...) -> [Flexable] {
//        nodes
//    }
    
    public static func buildFunction(_ nodes: Flexable...) -> [Flexable] {
        nodes
    }

    public static func buildDo(_ nodes: Flexable...) -> [Flexable] {
        nodes
    }

    public static func buildOptional(_ nodes: Flexable?...) -> [Flexable] {
        let result = nodes.compactMap { $0 }
        return result.isEmpty ? [] : result
    }

    public static func buildEither(first: Flexable...) -> [Flexable] {
        first
    }

    public static func buildEither(second: Flexable...) -> [Flexable] {
        second
    }
}
