//
//  ViewController.swift
//  YogaSwift
//
//  Created by zhuruliang on 09/17/2020.
//  Copyright (c) 2020 zhuruliang. All rights reserved.
//

import UIKit
import YogaSwift

enum DemoEnums: String, CaseIterable {
    case demo1
    case demo2
    
    func vc() -> UIViewController {
        let vc: UIViewController
        switch self {
        case .demo1:
            vc = Demo1ViewController()
        case .demo2:
            vc = Demo2.ViewController()
        }
        vc.title = self.rawValue
        return vc
    }
}

class ViewController: UIViewController {
    
    var allcases = DemoEnums.allCases
    
    lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.delegate = self
        tb.dataSource = self
        tb.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tb.tableFooterView = UIView()
        return tb
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.view.flexSpec.layout()
        self.tableView.frame = self.view.bounds
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allcases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tbc = tableView.dequeueReusableCell(withIdentifier: "cell") else { fatalError() }
        tbc.textLabel?.text = allcases[indexPath.row].rawValue
        return tbc
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(self.allcases[indexPath.row].vc(), animated: true)
    }
}
