//
//  FlexBuilder.swift
//  Flexbox
//
//  Created by resse on 2020/9/8.
//

import Foundation

//public protocol Flexable {
//    var node: FlexSpec { get }
//}
//
//extension UIView: Flexable {
//    public var node: FlexSpec {
//        return self.flexSpec
//    }
//}
//
//extension CALayer: Flexable {
//    public var node: FlexSpec {
//        return self.flexSpec
//    }
//}
//
//extension FlexSpec: Flexable {
//    public var node: FlexSpec {
//        return self
//    }
//}

@resultBuilder
public struct FlexBuilder {
    
    public static func buildBlock(_ node: FlexSpec) -> [FlexSpec] {
        [node]
    }
    
    public static func buildBlock(_ nodes: FlexSpec...) -> [FlexSpec] {
        nodes
    }
    
//    public static func buildExpression<Flexable>(_ nodes: Flexable...) -> [Flexable] {
//        nodes
//    }
    
    public static func buildFunction(_ nodes: FlexSpec...) -> [FlexSpec] {
        nodes
    }

    public static func buildDo(_ nodes: FlexSpec...) -> [FlexSpec] {
        nodes
    }

    public static func buildOptional(_ nodes: FlexSpec?...) -> [FlexSpec] {
        let result = nodes.compactMap { $0 }
        return result.isEmpty ? [] : result
    }

    public static func buildEither(first: FlexSpec...) -> [FlexSpec] {
        first
    }

    public static func buildEither(second: FlexSpec...) -> [FlexSpec] {
        second
    }
}
