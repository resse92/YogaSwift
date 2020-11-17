//
//  FlexEnum.swift
//  Flexbox
//
//  Created by AlexZHU on 2020/6/4.
//
import yoga

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
        case .column:        return YGFlexDirection.column
        case .columnReverse: return YGFlexDirection.columnReverse
        case .row:           return YGFlexDirection.row
        case .rowReverse:    return YGFlexDirection.rowReverse
        }
    }
}

extension VirtualNode.JustifyContent {
    var yogaValue: YGJustify {
        switch self {
        case .start:        return YGJustify.flexStart
        case .center:       return YGJustify.center
        case .end:          return YGJustify.flexEnd
        case .spaceBetween: return YGJustify.spaceBetween
        case .spaceAround:  return YGJustify.spaceAround
        case .spaceEvenly:  return YGJustify.spaceEvenly
        }
    }
}

extension VirtualNode.AlignContent {
    var yogaValue: YGAlign {
        switch self {
        case .stretch:      return YGAlign.stretch
        case .start:        return YGAlign.flexStart
        case .center:       return YGAlign.center
        case .end:          return YGAlign.flexEnd
        case .spaceBetween: return YGAlign.spaceBetween
        case .spaceAround:  return YGAlign.spaceAround
        }
    }
}

extension VirtualNode.AlignItems {
    var yogaValue: YGAlign {
        switch self {
        case .stretch:      return YGAlign.stretch
        case .start:        return YGAlign.flexStart
        case .center:       return YGAlign.center
        case .end:          return YGAlign.flexEnd
        case .baseline:     return YGAlign.baseline
        }
    }
}

extension VirtualNode.AlignSelf {
    var yogaValue: YGAlign {
        switch self {
        case .auto:         return YGAlign.auto
        case .stretch:      return YGAlign.stretch
        case .start:        return YGAlign.flexStart
        case .center:       return YGAlign.center
        case .end:          return YGAlign.flexEnd
        case .baseline:     return YGAlign.baseline
        }
    }
}

extension VirtualNode.Wrap {
    var yogaValue: YGWrap {
        switch self {
        case .noWrap:      return YGWrap.noWrap
        case .wrap:        return YGWrap.wrap
        case .wrapReverse: return YGWrap.wrapReverse
        }
    }
}

extension VirtualNode.Position {
    var yogaValue: YGPositionType {
        switch self {
        case .relative: return YGPositionType.relative
        case .absolute: return YGPositionType.absolute
        }
    }
}

extension VirtualNode.LayoutDirection {
    var yogaValue: YGDirection {
        switch self {
        case .ltr: return YGDirection.LTR
        case .rtl: return YGDirection.RTL
        default:   return YGDirection.inherit
        }
    }
}

extension VirtualNode.Display {
    var yogaValue: YGDisplay {
        switch self {
        case .flex: return YGDisplay.flex
        case .none: return YGDisplay.none
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
