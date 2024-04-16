//
//  Flex.swift
//  Flexbox
//
//  Created by resse on 2020/6/19.
//

// MARK: - Flex Attributes

public extension FlexSpec {
    @discardableResult
    func position(_ value: Position) -> Self {
        YGNodeStyleSetPositionType(self.ygNode, value.yogaValue)
        return self
    }
    
    @discardableResult
    func direction(_ value: Direction) -> Self {
        YGNodeStyleSetFlexDirection(self.ygNode, value.yogaValue)
        return self
    }
    
    @discardableResult
    func wrap(_ value: Wrap) -> Self {
        YGNodeStyleSetFlexWrap(self.ygNode, value.yogaValue)
        return self
    }
    
    @discardableResult
    func layoutDirection(_ value: LayoutDirection) -> Self {
        YGNodeStyleSetDirection(self.ygNode, value.yogaValue)
        return self
    }
    
    @discardableResult
    func justifyContent(_ value: JustifyContent) -> Self {
        YGNodeStyleSetJustifyContent(self.ygNode, value.yogaValue)
        return self
    }
    
    @discardableResult
    func alignItems(_ value: AlignItems) -> Self {
        YGNodeStyleSetAlignItems(self.ygNode, value.yogaValue)
        return self
    }
    
    @discardableResult
    func alignContent(_ value: AlignContent) -> Self {
        YGNodeStyleSetAlignContent(self.ygNode, value.yogaValue)
        return self
    }
    
    @discardableResult
    func alignSelf(_ value: AlignSelf) -> Self {
        YGNodeStyleSetAlignSelf(self.ygNode, value.yogaValue)
        return self
    }
    
    @discardableResult
    func grow(_ value: FlexValue) -> Self {
        YGNodeStyleSetFlexGrow(self.ygNode, value.float)
        return self
    }
    
    @discardableResult
    func shrink(_ value: FlexValue) -> Self {
        YGNodeStyleSetFlexShrink(self.ygNode, value.float)
        return self
    }

    @discardableResult
    func display(_ value: Display) -> Self {
        YGNodeStyleSetDisplay(self.ygNode, value.yogaValue)
        return self
    }
}

// MARK: - Margin
extension FlexSpec {
    @discardableResult
    public func marginTop(_ value: FlexValue) -> Self {
        YGNodeStyleSetMargin(self.ygNode, YGEdgeTop, value.float)
        return self
    }
    @discardableResult
    public func marginLeft(_ value: FlexValue) -> Self {
        YGNodeStyleSetMargin(self.ygNode, YGEdgeLeft, value.float)
        return self
    }

    @discardableResult
    public func marginBottom(_ value: FlexValue) -> Self {
        YGNodeStyleSetMargin(self.ygNode, YGEdgeBottom, value.float)
        return self
    }
    
    @discardableResult
    public func marginRight(_ value: FlexValue) -> Self {
        YGNodeStyleSetMargin(self.ygNode, YGEdgeRight, value.float)
        return self
    }
    
    @discardableResult
    public func marginTop(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetMarginPercent(self.ygNode, YGEdgeTop, percent.value())
        return self
    }
    
    @discardableResult
    public func marginLeft(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetMarginPercent(self.ygNode, YGEdgeLeft, percent.value())
        return self
    }
    
    @discardableResult
    public func marginBottom(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetMarginPercent(self.ygNode, YGEdgeBottom, percent.value())
        return self
    }
    
    @discardableResult
    public func marginRight(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetMarginPercent(self.ygNode, YGEdgeRight, percent.value())
        return self
    }

    @discardableResult
    public func marginStart(_ value: FlexValue) -> Self {
        YGNodeStyleSetMargin(self.ygNode, YGEdgeStart, value.float)
        return self
    }
    
    @discardableResult
    public func marginEnd(_ value: FlexValue) -> Self {
        YGNodeStyleSetMargin(self.ygNode, YGEdgeEnd, value.float)
        return self
    }
    
    @discardableResult
    public func marginStart(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetMarginPercent(self.ygNode, YGEdgeStart, percent.value())
        return self
    }
    
    @discardableResult
    public func marginEnd(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetMarginPercent(self.ygNode, YGEdgeEnd, percent.value())
        return self
    }
    
    @discardableResult
    public func marginHorizontal(_ value: FlexValue) -> Self {
        YGNodeStyleSetMargin(self.ygNode, YGEdgeHorizontal, value.float)
        return self
    }
    
    @discardableResult
    public func marginHorizontal(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetMarginPercent(self.ygNode, YGEdgeHorizontal, percent.value())
        return self
    }
    
    @discardableResult
    public func marginVertical(_ value: FlexValue) -> Self {
        YGNodeStyleSetMargin(self.ygNode, YGEdgeVertical, value.float)
        return self
    }
    
    @discardableResult
    public func marginVertical(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetMarginPercent(self.ygNode, YGEdgeVertical, percent.value())
        return self
    }
    
    @discardableResult
    public func margin(_ insets: UIEdgeInsets) -> Self {
        self.marginTop(insets.top).marginLeft(insets.left).marginRight(insets.right).marginBottom(insets.bottom)
        return self
    }
    
    /**
     Set all margins to the specified value.
     */
    
    @discardableResult
    public func margin(_ percent: FlexPercent) -> Self {
        self.marginTop(percent).marginLeft(percent).marginRight(percent).marginBottom(percent)
        return self
    }
    
    @discardableResult
    func margin(_ horizontal: FlexPercent, _ vertical: FlexPercent) -> Self {
        self.marginVertical(vertical).marginHorizontal(horizontal)
        return self
    }
    
    @discardableResult
    public func margin(_ top: FlexPercent, _ left: FlexPercent, _ bottom: FlexPercent, _ right: FlexPercent) -> Self {
        self.marginTop(top).marginLeft(left).marginBottom(bottom).marginRight(right)
        return self
    }
}

// MARK: - Padding
extension FlexSpec {
    @discardableResult
    public func paddingTop(_ value: FlexValue) -> Self {
        YGNodeStyleSetPadding(self.ygNode, YGEdgeTop, value.float)
        return self
    }
    
    @discardableResult
    public func paddingLeft(_ value: FlexValue) -> Self {
        YGNodeStyleSetPadding(self.ygNode, YGEdgeLeft, value.float)
        return self
    }

    @discardableResult
    public func paddingBottom(_ value: FlexValue) -> Self {
        YGNodeStyleSetPadding(self.ygNode, YGEdgeBottom, value.float)
        return self
    }
    
    @discardableResult
    public func paddingRight(_ value: FlexValue) -> Self {
        YGNodeStyleSetPadding(self.ygNode, YGEdgeRight, value.float)
        return self
    }
    
    @discardableResult
    public func paddingTop(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetPaddingPercent(self.ygNode, YGEdgeTop, percent.value())
        return self
    }
    
    @discardableResult
    public func paddingLeft(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetPaddingPercent(self.ygNode, YGEdgeLeft, percent.value())
        return self
    }
    
    @discardableResult
    public func paddingBottom(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetPaddingPercent(self.ygNode, YGEdgeBottom, percent.value())
        return self
    }
    
    @discardableResult
    public func paddingRight(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetPaddingPercent(self.ygNode, YGEdgeRight, percent.value())
        return self
    }

    @discardableResult
    public func paddingStart(_ value: FlexValue) -> Self {
        YGNodeStyleSetPadding(self.ygNode, YGEdgeStart, value.float)
        return self
    }
    
    @discardableResult
    public func paddingEnd(_ value: FlexValue) -> Self {
        YGNodeStyleSetPadding(self.ygNode, YGEdgeEnd, value.float)
        return self
    }
    
    @discardableResult
    public func paddingStart(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetPaddingPercent(self.ygNode, YGEdgeStart, percent.value())
        return self
    }
    
    @discardableResult
    public func paddingEnd(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetPaddingPercent(self.ygNode, YGEdgeEnd, percent.value())
        return self
    }
    
    @discardableResult
    public func paddingHorizontal(_ value: FlexValue) -> Self {
        YGNodeStyleSetPadding(self.ygNode, YGEdgeHorizontal, value.float)
        return self
    }
    
    @discardableResult
    public func paddingHorizontal(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetPaddingPercent(self.ygNode, YGEdgeHorizontal, percent.value())
        return self
    }
    
    @discardableResult
    public func paddingVertical(_ value: FlexValue) -> Self {
        YGNodeStyleSetPadding(self.ygNode, YGEdgeVertical, value.float)
        return self
    }
    
    @discardableResult
    public func paddingVertical(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetPaddingPercent(self.ygNode, YGEdgeVertical, percent.value())
        return self
    }
    
    @discardableResult
    public func padding(_ insets: UIEdgeInsets) -> Self {
        self.paddingTop(insets.top).paddingLeft(insets.left).paddingRight(insets.right).paddingBottom(insets.bottom)
        return self
    }
    
    @discardableResult
    public func padding(_ percent: FlexPercent) -> Self {
        self.paddingTop(percent).paddingLeft(percent).paddingRight(percent).paddingBottom(percent)
        return self
    }
    
    @discardableResult
    public func padding(_ value: FlexValue) -> Self {
        self.paddingTop(value).paddingLeft(value).paddingRight(value).paddingBottom(value)
        return self
    }
    
    @discardableResult
    func padding(_ horizontal: FlexPercent, _ vertical: FlexPercent) -> Self {
        self.paddingVertical(vertical).paddingHorizontal(horizontal)
        return self
    }
    
    @discardableResult
    public func padding(_ top: FlexPercent, _ left: FlexPercent, _ bottom: FlexPercent, _ right: FlexPercent) -> Self {
        self.paddingTop(top).paddingLeft(left).paddingBottom(bottom).paddingRight(right)
        return self
    }
}

// MARK: - Min/Max width/height
extension FlexSpec {
    @discardableResult
    public func minWidth(_ value: FlexValue) -> Self {
        YGNodeStyleSetMinWidth(self.ygNode, value.float)
        return self
    }
    
    @discardableResult
    public func minWidth(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetMinWidthPercent(self.ygNode, percent.value())
        return self
    }

    /**
     The value specifies the view's maximum width in pixels. The value must be non-negative.
     */
    @discardableResult
    public func maxWidth(_ value: FlexValue) -> Self {
        YGNodeStyleSetMinWidth(self.ygNode, value.float)
        return self
    }
    
    /**
     The value specifies the view's maximum width in percentage of its container width. The value must be non-negative.
     */
    @discardableResult
    public func maxWidth(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetMinWidthPercent(self.ygNode, percent.value())
        return self
    }
    
    /**
     The value specifies the view's minimum height in pixels. The value must be non-negative.
     */
    @discardableResult
    public func minHeight(_ value: FlexValue) -> Self {
        YGNodeStyleSetMinHeight(self.ygNode, value.float)
        return self
    }
    
    /**
     The value specifies the view's minimum height in percentage of its container height. The value must be non-negative.
     */
    @discardableResult
    public func minHeight(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetMinHeightPercent(self.ygNode, percent.value())
        return self
    }

    /**
     The value specifies the view's maximum height in pixels. The value must be non-negative.
     */
    @discardableResult
    public func maxHeight(_ value: FlexValue) -> Self {
        YGNodeStyleSetMaxHeight(self.ygNode, value.float)
        return self
    }
    
    /**
     The value specifies the view's maximum height in percentage of its container height. The value must be non-negative.
     */
    @discardableResult
    public func maxHeight(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetMaxHeightPercent(self.ygNode, percent.value())
        return self
    }
    
    /**
     AspectRatio is a property introduced by Yoga that don't exist in CSS. AspectRatio solves the problem of knowing
     one dimension of an element and an aspect ratio, this is very common when it comes to images, videos, and other
     media types. AspectRatio accepts any FlexValueing point value > 0, the default is undefined.
    
     - Parameter value:
     - Returns:
    */
    @discardableResult
    public func aspectRatio(_ value: FlexValue) -> FlexSpec {
        YGNodeStyleSetAspectRatio(self.ygNode, value.float)
        return self
    }
}

// MARK: - Size
extension FlexSpec {

    @discardableResult
    public func basis(_ value: FlexValue) -> Self {
        YGNodeStyleSetFlexBasis(self.ygNode, value.float)
        return self
    }

    @discardableResult
    public func basis(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetFlexBasisPercent(self.ygNode, percent.value())
        return self
    }

    @discardableResult
    public func width(_ value: FlexValue?) -> Self {
        if let value = value {
            YGNodeStyleSetWidth(self.ygNode, value.float)
        } else {
            YGNodeStyleSetWidthAuto(self.ygNode)
        }
        return self
    }
    
    @discardableResult
    public func width(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetWidthPercent(self.ygNode, percent.value())
        return self
    }
    
    @discardableResult
    public func height(_ value: FlexValue?) -> Self {
        if let value = value {
            YGNodeStyleSetHeight(self.ygNode, value.float)
        } else {
            YGNodeStyleSetHeightAuto(self.ygNode)
        }
        return self
    }
    
    @discardableResult
    public func height(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetHeightPercent(self.ygNode, percent.value())
        return self
    }
    
    /**
     The value specifies view's width and the height in pixels. Values must be non-negative.
     */
    @discardableResult
    public func size(_ size: CGSize?) -> Self {
        if let size = size {
            self.width(size.width).height(size.height)
        } else {
            self.width(nil).height(nil)
        }
        return self
    }
    
    /**
     The value specifies the width and the height of the view in pixels, creating a square view. Values must be non-negative.
     */
    @discardableResult
    public func size(_ sideLength: FlexValue) -> Self {
        self.width(sideLength).height(sideLength)
        return self
    }
}

// MARK: Absolute Margin
public extension FlexSpec {
    
    @discardableResult
    func left(_ value: FlexValue) -> Self {
        YGNodeStyleSetPosition(self.ygNode, YGEdgeLeft, value.float)
        return self
    }
    
    @discardableResult
    func top(_ value: FlexValue) -> Self {
        YGNodeStyleSetPosition(self.ygNode, YGEdgeTop, value.float)
        return self
    }
    
    @discardableResult
    func bottom(_ value: FlexValue) -> Self {
        YGNodeStyleSetPosition(self.ygNode, YGEdgeBottom, value.float)
        return self
    }
    
    @discardableResult
    func right(_ value: FlexValue) -> Self {
        YGNodeStyleSetPosition(self.ygNode, YGEdgeRight, value.float)
        return self
    }
    
    @discardableResult
    func start(_ value: FlexValue) -> Self {
        YGNodeStyleSetPosition(self.ygNode, YGEdgeStart, value.float)
        return self
    }
    
    @discardableResult
    func end(_ value: FlexValue) -> Self {
        YGNodeStyleSetPosition(self.ygNode, YGEdgeEnd, value.float)
        return self
    }
    
    @discardableResult
    func horizontally(_ value: FlexValue) -> Self {
        YGNodeStyleSetPosition(self.ygNode, YGEdgeHorizontal, value.float)
        return self
    }
    
    @discardableResult
    func vertically(_ value: FlexValue) -> Self {
        YGNodeStyleSetPosition(self.ygNode, YGEdgeVertical, value.float)
        return self
    }
    
    @discardableResult
    func all(_ value: FlexValue) -> Self {
        self.top(value).left(value).bottom(value).right(value)
        return self
    }

    @discardableResult
    func left(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetPositionPercent(self.ygNode, YGEdgeLeft, percent.value())
        return self
    }
        
    @discardableResult
    func top(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetPositionPercent(self.ygNode, YGEdgeTop, percent.value())
        return self
    }
    @discardableResult
    func bottom(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetPositionPercent(self.ygNode, YGEdgeBottom, percent.value())
        return self
    }
    
    @discardableResult
    func right(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetPositionPercent(self.ygNode, YGEdgeRight, percent.value())
        return self
    }
    
    @discardableResult
    func start(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetPositionPercent(self.ygNode, YGEdgeStart, percent.value())
        return self
    }
    
    @discardableResult
    func end(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetPositionPercent(self.ygNode, YGEdgeEnd, percent.value())
        return self
    }
    
    @discardableResult
    func horizontally(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetPositionPercent(self.ygNode, YGEdgeHorizontal, percent.value())
        return self
    }
    @discardableResult
    func vertically(_ percent: FlexPercent) -> Self {
        YGNodeStyleSetPositionPercent(self.ygNode, YGEdgeVertical, percent.value())
        return self
    }
    
    @discardableResult
    func all(_ percent: FlexPercent) -> Self {
        self.top(percent).left(percent).bottom(percent).right(percent)
        return self
    }
    
    @discardableResult
    func all(_ insets: UIEdgeInsets) -> Self {
        self.top(insets.top).left(insets.left).bottom(insets.bottom).right(insets.right)
        return self
    }
}
