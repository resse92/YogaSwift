//
//  FlexEnum.swift
//  Flexbox
//
//  Created by resse on 2020/6/4.
//

// MARK: Enums
extension VirtualNode {
    
    /**
     */
    public enum Direction {
        // Default value. The flexible items are displayed vertically, as a column.
        case column
        // Same as column, but in reverse order
        case columnReverse
        // The flexible items are displayed horizontally, as a row.
        case row
        // Same as row, but in reverse order
        case rowReverse
    }
    
    /**
     */
    public enum JustifyContent {
        // Default value. Items are positioned at the beginning of the container.
        case start
        // Items are positioned at the center of the container
        case center
        // Items are positioned at the end of the container
        case end
        // Items are positioned with space between the lines
        case spaceBetween
        // Items are positioned with space before, between, and after the lines
        case spaceAround
        // Items are positioned with space distributed evenly, items have equal space around them.
        case spaceEvenly
    }
    
    /**
     */
    public enum AlignContent {
        // Default value. Lines stretch to take up the remaining space
        case stretch
        // Lines are packed toward the start of the flex container
        case start
        // Lines are packed toward the center of the flex container
        case center
        // Lines are packed toward the end of the flex container
        case end
        // Lines are evenly distributed in the flex container
        case spaceBetween
        // Lines are evenly distributed in the flex container, with half-size spaces on either end    Play it »
        case spaceAround
    }
    
    /**
     */
    public enum AlignItems {
        // Default. Items are stretched to fit the container
        case stretch
        // Items are positioned at the beginning of the container
        case start
        // Items are positioned at the center of the container
        case center
        // Items are positioned at the end of the container
        case end
        // Items are positioned at the baseline of the container
        case baseline
    }
    
    /**
     */
    public enum AlignSelf {
        // Default. The element inherits its parent container's align-items property, or "stretch" if it has no parent container
        case auto
        // The element is positioned to fit the container
        case stretch
        // The element is positioned at the beginning of the container
        case start
        // The element is positioned at the center of the container
        case center
        // The element is positioned at the end of the container
        case end
        // The element is positioned at the baseline of the container
        case baseline
    }
    
    /**
     */
    public enum Wrap {
        // Default value. Specifies that the flexible items will not wrap
        case noWrap
        // Specifies that the flexible items will wrap if necessary
        case wrap
        // Specifies that the flexible items will wrap, if necessary, in reverse order
        case wrapReverse
    }
    
    /**
     */
    public enum Position {
        // Default value.
        case relative
        // Positioned absolutely in regards to its container. The item is positionned using properties top, bottom, left, right, start, end.
        case absolute
        
        case `static`
    }
    
    /**
     */
    public enum LayoutDirection {
        // Default value.
        case inherit
        // Left to right layout direction
        case ltr
        // Right to right layout direction
        case rtl
        //case auto       // Detected automatically
    }
    
    /**
     Defines how the `layout(mode:)` method layout its flex items.
     */
    public enum LayoutMode {
        // This is the default mode when no parameter is specified. Children are layouted **inside** the container's size (width and height).
        case fitContainer
        // In this mode, children are layouted **using only the container's width**. The container's height will be adjusted to fit the flexbox's children
        case adjustHeight
        // In this mode, children are layouted **using only the container's height**. The container's width will be adjusted to fit the flexbox's children
        case adjustWidth
    }
    
    /**
     */
    public enum Display {
        // Default value
        case flex
        // With this value, the item will be hidden and not be calculated
        case none
    }
}

extension VirtualNode.Direction {
    var yogaValue: YGFlexDirection {
        switch self {
        case .column:        return YGFlexDirectionColumn
        case .columnReverse: return YGFlexDirectionColumnReverse
        case .row:           return YGFlexDirectionRow
        case .rowReverse:    return YGFlexDirectionRowReverse
        }
    }
}

extension VirtualNode.JustifyContent {
    var yogaValue: YGJustify {
        switch self {
        case .start:        return YGJustifyFlexStart
        case .center:       return YGJustifyCenter
        case .end:          return YGJustifyFlexEnd
        case .spaceBetween: return YGJustifySpaceBetween
        case .spaceAround:  return YGJustifySpaceAround
        case .spaceEvenly:  return YGJustifySpaceEvenly
        }
    }
}

extension VirtualNode.AlignContent {
    var yogaValue: YGAlign {
        switch self {
        case .stretch:      return YGAlignStretch
        case .start:        return YGAlignFlexStart
        case .center:       return YGAlignCenter
        case .end:          return YGAlignFlexEnd
        case .spaceBetween: return YGAlignSpaceBetween
        case .spaceAround:  return YGAlignSpaceAround
        }
    }
}

extension VirtualNode.AlignItems {
    var yogaValue: YGAlign {
        switch self {
        case .stretch:      return YGAlignStretch
        case .start:        return YGAlignFlexStart
        case .center:       return YGAlignCenter
        case .end:          return YGAlignFlexEnd
        case .baseline:     return YGAlignBaseline
        }
    }
}

extension VirtualNode.AlignSelf {
    var yogaValue: YGAlign {
        switch self {
        case .auto:         return YGAlignAuto
        case .stretch:      return YGAlignStretch
        case .start:        return YGAlignFlexStart
        case .center:       return YGAlignCenter
        case .end:          return YGAlignFlexEnd
        case .baseline:     return YGAlignBaseline
        }
    }
}

extension VirtualNode.Wrap {
    var yogaValue: YGWrap {
        switch self {
        case .noWrap:      return YGWrapNoWrap
        case .wrap:        return YGWrapWrap
        case .wrapReverse: return YGWrapWrapReverse
        }
    }
}

extension VirtualNode.Position {
    var yogaValue: YGPositionType {
        switch self {
        case .relative: return YGPositionTypeRelative
        case .absolute: return YGPositionTypeAbsolute
        case .static: return YGPositionTypeStatic
        }
    }
}

extension VirtualNode.LayoutDirection {
    var yogaValue: YGDirection {
        switch self {
        case .ltr: return YGDirectionLTR
        case .rtl: return YGDirectionRTL
        default:   return YGDirectionInherit
        }
    }
}

extension VirtualNode.Display {
    var yogaValue: YGDisplay {
        switch self {
        case .flex: return YGDisplayFlex
        case .none: return YGDisplayNone
        }
    }
}

/*extension Flex.Overflow {
    var yogaValue: YGOverflow {
        switch self {
        case .visible: return YGOverflow.visible
        case .hidden:  return YGOverflow.hidden
        case .scroll:  return YGOverflow.scroll
        }
    }
}*/
