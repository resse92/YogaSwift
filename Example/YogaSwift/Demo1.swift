//
//  Demo1.swift
//  YogaSwift_Example
//
//  Created by chenmu on 2020/11/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import YogaSwift

private class BaseView: UIView {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    var imageViews = [ImageView(), UIImageView()]
}

private class LeftView: BaseView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Column(self).alignItems(.stretch).build {
            self.imageViews[1].flex.grow(1)
        }
        
        self.imageViews[1].image = UIImage.p2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ImageView: UIImageView {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let size = super.sizeThatFits(size)
        print(size)
        return size
    }
}

private class RightView: BaseView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Column(self).padding(10).build {
            self.titleLabel.flex
            
            Row().marginTop(4).grow(1).alignItems(.stretch).shrink(2)
                .build {
                    Column().alignItems(.stretch).justifyContent(.start).grow(1).width(50%).shrink(2)
                        .build {
                            self.subtitleLabel.flex.shrink(0)
                            
                            self.imageViews[0].flex.marginTop(2).grow(1).aspectRatio(1).alignSelf(.center).shrink(1)
                        }
                    
                    self.imageViews[1].flex.aspectRatio(1).marginLeft(10).alignSelf(.center).width(50%).shrink(2)
                }
        }
        self.imageViews[0].tag = 10
        self.imageViews[0].image = UIImage.p1
        self.imageViews[1].image = UIImage.p5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.flex.layout()
    }
}

class Demo1ViewController: UIViewController {
    private let left = LeftView()
    
    private let rightTop: RightView = {
        let view = RightView()
        view.titleLabel.text = "Right Top Title"
        view.subtitleLabel.text = "Right Top sub Title"
        return view
    }()
    
    private let rightBottom: RightView = {
        let view = RightView()
        view.titleLabel.text = "Right Bottom Title"
        view.subtitleLabel.text = "Right Bottom sub Title"
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Column(view).alignItems(.center).justifyContent(.center).build {
            Row().padding(10).alignItems(.stretch).build {
                self.left.flex.grow(1).shrink(2).width(50%)
                Column().alignItems(.stretch).grow(1).marginLeft(10).shrink(2).width(50%)
                    .build {
                        self.rightTop.flex.grow(1).height(50%).shrink(2)
                        self.rightBottom.flex.grow(1).marginTop(10).height(50%).shrink(2)
                    }
            }.size(CGSize(width: 375, height: 263))
        }
//        
        self.view.backgroundColor = UIColor(0xf5f5f5)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.flex.layout()
        self.view.subviews.forEach { $0.backgroundColor = UIColor.white }
    }
}

