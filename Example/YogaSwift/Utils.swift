//
//  Utils.swift
//  YogaSwift_Example
//
//  Created by chenmu on 2020/11/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
extension UIImage {
    class var p1: UIImage {
        UIImage(named: "1.jpg")!
    }
    
    class var p2: UIImage {
        UIImage(named: "2.jpeg")!
    }
    
    class var p3: UIImage {
        UIImage(named: "3.jpeg")!
    }
    
    class var p4: UIImage {
        UIImage(named: "4.jpg")!
    }
    
    class var p5: UIImage {
        UIImage(named: "5.jpg")!
    }
}


extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
    
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }

    convenience init(_ rgb: Int, a: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            a: a
        )
    }
}

extension UIView {
    var pSafeAreaInset: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return self.safeAreaInsets
        } else {
            return UIEdgeInsets.zero
        }
    }
}
