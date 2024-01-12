//
//  ListViewController.swift
//  IpadExperiment
//
//  Created by Jack.Costigan on 05/01/2024.
//

import UIKit

class ListViewController: UITableViewController {
    var content: [String] = []
    weak var delegate: ListViewDelegate?
    
    init(content: [String]) {
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(Cell.self, forCellReuseIdentifier: "Cell")
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        let title = content[indexPath.row]
        cell.configure(with: title)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectCell(atIndex: indexPath.row)
    }
}

protocol ListViewDelegate: AnyObject {
    func didSelectCell(atIndex index: Int)
}

extension ListViewController {
    class Cell: UITableViewCell {
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupSubviews()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        func configure(with title: String) {
            titleLabel.text = title
        }
        
        func setupSubviews() {
            addSubview(titleLabel)
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
                titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
    }
}

#Preview {
    ListViewController(content: ["dogs", "cats", "mushrooms"])
}
