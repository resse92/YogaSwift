//
//  ViewController.swift
//  YogaSwift
//
//  Created by zhuruliang on 09/17/2020.
//  Copyright (c) 2020 zhuruliang. All rights reserved.
//

import UIKit
import YogaSwift
class ViewController: UIViewController {
    
    var subview: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let v = UIView()
        v.backgroundColor = UIColor.red
        self.view.addSubview(v)
        self.view.flex.direction(.column).alignItems(.center).justifyContent(.center).build {
            v.flex.size(CGSize(width: 100, height: 100))
        }
        self.subview = v
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.flex.layout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.subview?.removeFromSuperview()
        self.subview = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

