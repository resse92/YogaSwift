// YogaSwift_Example
// Created by: resse

import Foundation

import UIKit
import YogaSwift

enum Demo2 {}

extension Demo2 {
    class ViewController: UIViewController {
        lazy var tableView: UITableView = {
            let tb = UITableView()
            tb.delegate = self
            tb.dataSource = self
            tb.register(Cell.self, forCellReuseIdentifier: NSStringFromClass(Cell.self))
            tb.estimatedRowHeight = 80
            return tb
        }()
        
        var datasources: [String] = []
        
        let tempCell = Cell()
        
        override func loadView() {
            super.loadView()
            self.view = tableView
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = .white
            DispatchQueue.global().async {
                self.datasources = [Int](100...1000).map { String(randomOfLength: $0) }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension Demo2.ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.datasources.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(Demo2.Cell.self)) as? Demo2.Cell
        cell?.label.text = self.datasources[indexPath.row]
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let time = CFAbsoluteTimeGetCurrent()
        tempCell.label.text = self.datasources[indexPath.row]
        tempCell.label.flexSpec.markDirty()
        let size = tempCell.contentView.flexSpec.calculateLayout(size: CGSize(width: tableView.frame.width, height: .nan))
        print("耗时: \((CFAbsoluteTimeGetCurrent() - time) * 1000)ms")
        return size.height
    }
}

extension Demo2 {
    class Cell: UITableViewCell {
        lazy var label: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 17)
            label.textColor = .black
            label.numberOfLines = 100
            return label
        }()
        
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            let size = self.contentView.flexSpec.calculateLayout(size: .init(width: size.width, height: .nan))
            return size
        }
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            Column(self.contentView) {
                self.label.flexSpec.grow(1)
            }.padding(.init(top: 10, left: 10, bottom: 10, right: 10))
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            self.contentView.flexSpec.layout()
        }
    }
}

extension String {
    init(randomOfLength length: Int) {
        guard length > 0 else {
            self.init()
            return
        }

        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        for _ in 1...length {
            randomString.append(base.randomElement()!)
        }
        self = randomString
    }
}
