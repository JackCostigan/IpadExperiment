//
//  ViewController.swift
//  IpadExperiment
//
//  Created by Jack.Costigan on 04/01/2024.
//

import UIKit

class ViewController: UIViewController {
    let content: [Content] = [
        .init(title: "dog") { DogViewController() },
        .init(title: "woof") { WoofViewController() }
    ]
    lazy var split = UISplitViewController(style: .doubleColumn)
    lazy var list = ListViewController(content: content.map { $0.title })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    private func setupSubviews() {
        addChild(split)
        view.addSubview(split.view)
        split.preferredDisplayMode = .oneBesideSecondary
        split.didMove(toParent: self)
        split.setViewController(list, for: .primary)
        split.setViewController(EmptyViewController(), for: .secondary)
        // Gets rid of the collapse button
        split.presentsWithGesture = false
        list.delegate = self
    }
}

extension ViewController: ListViewDelegate {
    func didSelectCell(atIndex index: Int) {
        let contentViewController = content[index].factory()
        let navigationController = UINavigationController(rootViewController: contentViewController)
        split.setViewController(navigationController, for: .secondary)
    }
}

extension ViewController {
    struct Content {
        let title: String
        let factory: () -> UIViewController
    }
}

extension ViewController {
    class EmptyViewController: UIViewController {
        lazy var emptyLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Try selecting an item on the left"
            return label
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupSubviews()
        }
        
        private func setupSubviews() {
            view.backgroundColor = .white
            view.addSubview(emptyLabel)
            view.backgroundColor = .white
            NSLayoutConstraint.activate([
                emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    }
}

#Preview("Split view") {
    ViewController()
}
