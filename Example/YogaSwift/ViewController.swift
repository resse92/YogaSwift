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
    case Demo1
    
    func vc() -> UIViewController {
        let vc: UIViewController
        switch self {
        case .Demo1:
            vc = Demo1ViewController()
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
        Column(self.view) {
            self.tableView.flexSpec.grow(1).alignSelf(.stretch)
        }.size(UIScreen.main.bounds.size)
        self.view.backgroundColor = .white
//        self.view.setNeedsLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.flexSpec.layout()
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
