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
        
        Column(self) {
            self.imageViews[1].flexSpec.grow(1)
        }.alignItems(.stretch)
        
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
        
        Column(self) {
            self.titleLabel.flexSpec
            Row {
                Column {
                    self.subtitleLabel.flexSpec.shrink(0)
                    
                    self.imageViews[0].flexSpec.marginTop(2).grow(1).aspectRatio(1).alignSelf(.center).shrink(1)
                }.alignItems(.stretch).justifyContent(.start).grow(1).width(50%).shrink(2)
                
                self.imageViews[1].flexSpec.aspectRatio(1).marginLeft(10).alignSelf(.center).width(50%).shrink(2)
            }.marginTop(4).grow(1).alignItems(.stretch).shrink(2)
        }.padding(10)
        
        self.imageViews[0].tag = 10
        self.imageViews[0].image = UIImage.p1
        self.imageViews[1].image = UIImage.p5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
        
        Column(view) {
            Row {
                self.left.flexSpec.grow(1).shrink(2).width(50%)
                Column {
                    self.rightTop.flexSpec.grow(1).height(50%).shrink(2)
                    self.rightBottom.flexSpec.grow(1).marginTop(10).height(50%).shrink(2)
                }
                .alignItems(.stretch)
                .grow(1)
                .marginLeft(10)
                .shrink(2)
                .width(50%)
            }
            .size(CGSize(width: 375, height: 300))
            .padding(10)
            .alignItems(.stretch)
        }.alignItems(.center).justifyContent(.center)

        self.view.backgroundColor = UIColor(0xf5f5f5)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.view.flex.layout()
        self.view.subviews.forEach { $0.backgroundColor = UIColor.white }
    }
}

