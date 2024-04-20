//
//  Percent.swift
//  Flexbox
//
//  Created by resse on 2020/6/5.
//

import UIKit

// MARK: Percent

public struct FlexPercent {
    private let pointValue: CGFloat
    
    func value() -> CGFloat {
        return self.pointValue
    }
    
    func value() -> Float {
        return Float(self.pointValue)
    }
    
    init(_ value: CGFloat) {
        self.pointValue = value
    }
}

postfix operator %
public postfix func % (v: CGFloat) -> FlexPercent {
    return FlexPercent(v)
}

public postfix func % (v: Int) -> FlexPercent {
    return FlexPercent(CGFloat(v))
}

prefix operator -
public prefix func - (p: FlexPercent) -> FlexPercent {
    return FlexPercent(-p.value())
}

// MARK: - Flex Value

public protocol FlexValue {
    var float: Float { get }
}

extension Double: FlexValue {
    public var float: Float {
        return Float(self)
    }
}

extension CGFloat: FlexValue {
    public var float: Float {
        return Float(self)
    }
}

extension Int: FlexValue {
    public var float: Float {
        return Float(self)
    }
}

extension CGRect {
    init(x: Float, y: Float, width: Float, height: Float) {
        self.init(x: CGFloat(x), y: CGFloat(y), width: CGFloat(width), height: CGFloat(height))
    }
}

extension CGSize {
    init(width: Float, height: Float) {
        self.init(width: CGFloat(width), height: CGFloat(height))
    }
}
