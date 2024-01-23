//
//  ViewController.swift
//  IpadExperiment
//
//  Created by Jack.Costigan on 04/01/2024.
//

import UIKit

// TODO
// Setup same heirarchy on both iphone and ipad
// setup delegate methods
// figure out what I need to do to get the desired correct navigation when pushing to secondary



class ViewController: UIViewController {
    lazy var content: [Content] = [
        .init(title: "pushy") { [weak self] in self!.createPushyViewController(atDepth: 0) },
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
    lazy var ipadDelegate = IpadListViewDelegate(parent: self)
    lazy var noSelectionViewController = EmptyViewController()
    private let useUiSplitViewController = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIpadSubviews()
    }
    
    private func createPushyViewController(atDepth: Int) -> PushViewController {
        let vc = PushViewController(depth: atDepth)
        vc.buttonCallback = { [weak self] _ in
            guard let self else {
                return
            }
            let vc = createPushyViewController(atDepth: atDepth+1)
            pushSecondaryScreen(vc)
        }
        return vc
    }
    
    private func setupIpadSubviews() {
        if useUiSplitViewController {
            addChild(uiSplit)
            view.addSubview(uiSplit.view)
            uiSplit.preferredDisplayMode = .oneBesideSecondary
            uiSplit.preferredSplitBehavior = .tile
            uiSplit.setViewController(list, for: .primary)
            uiSplit.setViewController(noSelectionViewController, for: .secondary)
            uiSplit.delegate = self
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
    
    func pushSecondaryScreen(_ viewController: UIViewController) {
        guard let secondarViewController = uiSplit.viewController(for: .secondary),
              let navigationController = secondarViewController as? UINavigationController
//              let navigationController = uiSplit.viewController(for: .secondary)?.navigationController,
        else {
            return
        }
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func setSecondaryScreen(_ viewController: UIViewController) {
        // NOTE: If you want to replace the current secondary screen, make sure to wrap in a navigation controller.
        // This will ensure that old secondary screens are removed from the back stack
        let navigationController = UINavigationController(rootViewController: viewController)
        uiSplit.showDetailViewController(navigationController, sender: self)
    }
}

extension ViewController: UISplitViewControllerDelegate {
    // NOTES
    // Need to show/hide primary vc navigation bar when the view is collapsed/expanded
    // Need to add/remove empty view controller based on expanded/collapsed
    
    func splitViewControllerDidCollapse(_ svc: UISplitViewController) {
        // called when the secondary view is hidden
        print("XXX split view controller did collapse \(svc.viewControllers) | \((svc.viewControllers.first as? UINavigationController)?.viewControllers)")
        uiSplit.viewController(for: .primary)?.navigationController?.isNavigationBarHidden = false
    }

    func splitViewControllerDidExpand(_ svc: UISplitViewController) {
        // called when the secondary view is shown again
        print("XXX split view conmtrolelr did expand \(svc.viewControllers) | \((svc.viewControllers.first as? UINavigationController)?.viewControllers)")
        uiSplit.viewController(for: .primary)?.navigationController?.isNavigationBarHidden = true
    }

    func splitViewController(_ svc: UISplitViewController, 
                             topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        print("XXX split view controller top column for collapsing to proposed: \(proposedTopColumn)")
        // Could I return a different value here depending on whether or not the secondary view controller is empty?
        let secondaryViewController = uiSplit.viewController(for: .secondary)
        return secondaryViewController == noSelectionViewController ? .primary : .secondary
    }
}

extension ViewController {
    class IpadListViewDelegate: ListViewDelegate {
        weak var parent: ViewController?
        
        init(parent: ViewController) {
            self.parent = parent
        }
        
        func didSelectCell(atIndex index: Int) {
            guard let parent else { return }
            let contentViewController = parent.content[index].factory()
            if parent.useUiSplitViewController {
                parent.setSecondaryScreen(contentViewController)
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
