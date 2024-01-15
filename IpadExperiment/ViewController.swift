//
//  ViewController.swift
//  IpadExperiment
//
//  Created by Jack.Costigan on 04/01/2024.
//

import UIKit

class ViewController: UIViewController {
    let content: [Content] = [
        .init(title: "dog") { SpinnyViewController(imageName: "dog.circle") },
        .init(title: "woof") { BarkViewController(bark: "woof") },
        .init(title: "cat") { SpinnyViewController(imageName: "cat.circle") },
        .init(title: "meow") { BarkViewController(bark: "meow") },
        .init(title: "man") { SpinnyViewController(imageName: "figure.walk.circle") },
        .init(title: "hello") { BarkViewController(bark: "hello") },
        .init(title: "example") { ExampleViewController(color: .red, text: "Example view controller") }
    ]
    lazy var mdSplit = MasterDetailViewController()
    lazy var uiSplit = UISplitViewController(style: .doubleColumn)
    lazy var list = ListViewController(content: content.map { $0.title })
    lazy var navigationStack: UINavigationController = .init(rootViewController: list)
    lazy var ipadDelegate = IpadListViewDelegate(parent: self)
    lazy var iphoneDelegate = IphoneListViewDelegate(parent: self)
    private let useUiSplitViewController = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.userInterfaceIdiom == .phone {
            setupIphoneSubviews()
        } else {
            setupIpadSubviews()
        }
    }
    
    private func setupIpadSubviews() {
        if useUiSplitViewController {
            addChild(uiSplit)
            view.addSubview(uiSplit.view)
            uiSplit.preferredDisplayMode = .oneBesideSecondary
            uiSplit.setViewController(list, for: .primary)
            uiSplit.setViewController(EmptyViewController(), for: .secondary)
            // Gets rid of the collapse button
            uiSplit.presentsWithGesture = false
        } else {
            addChild(mdSplit)
            view.addSubview(mdSplit.view)
            mdSplit.didMove(toParent: self)
            mdSplit.setMasterViewController(list)
            mdSplit.setDetailViewController(EmptyViewController())
        }
        list.delegate = ipadDelegate
    }
    
    private func setupIphoneSubviews() {
        addChild(navigationStack)
        view.addSubview(navigationStack.view)
        navigationStack.didMove(toParent: self)
        list.delegate = iphoneDelegate
    }
}

extension ViewController {
    class IphoneListViewDelegate: ListViewDelegate {
        weak var parent: ViewController?
        
        init(parent: ViewController) {
            self.parent = parent
        }
        
        func didSelectCell(atIndex index: Int) {
            guard let parent else { return }
            let contentViewController = parent.content[index].factory()
            parent.navigationStack.pushViewController(contentViewController, animated: true)
        }
    }
    
    class IpadListViewDelegate: ListViewDelegate {
        weak var parent: ViewController?
        
        init(parent: ViewController) {
            self.parent = parent
        }
        
        func didSelectCell(atIndex index: Int) {
            guard let parent else { return }
            let contentViewController = parent.content[index].factory()
            if parent.useUiSplitViewController {
                let navigationController = UINavigationController(rootViewController: contentViewController)
                parent.uiSplit.setViewController(navigationController, for: .secondary)
            } else {
                parent.mdSplit.setDetailViewController(contentViewController)
            }
        }
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
