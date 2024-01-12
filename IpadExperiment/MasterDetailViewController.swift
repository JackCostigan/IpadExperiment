//
//  MasterDetailViewController.swift
//  IpadExperiment
//
//  Created by Jack.Costigan on 12/01/2024.
//

import UIKit

class MasterDetailViewController: UIViewController {
    private var masterViewController: UIViewController
    private var detailViewController: UIViewController
    private lazy var masterContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var detailContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var containerWidthConstraint = detailContainer.widthAnchor.constraint(equalTo: masterContainer.widthAnchor, multiplier: ratio)
    private let ratio: Double
    
    init(ratio: Double = 2.0,
         masterViewController: UIViewController = createEmptyPlaceholderViewController(),
         detailViewController: UIViewController = createEmptyPlaceholderViewController()) {
        self.ratio = ratio
        self.masterViewController = masterViewController
        self.detailViewController = detailViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    private func setupSubviews() {
        view.addSubview(masterContainer)
        addMasterViewController()
        view.addSubview(detailContainer)
        addDetailViewController()
        NSLayoutConstraint.activate([
            masterContainer.topAnchor.constraint(equalTo: view.topAnchor),
            masterContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            masterContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailContainer.topAnchor.constraint(equalTo: view.topAnchor),
            detailContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            detailContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            masterContainer.trailingAnchor.constraint(equalTo: detailContainer.leadingAnchor),
            containerWidthConstraint
        ])
    }
    
    private static func createEmptyPlaceholderViewController() -> UIViewController {
        let vc = UIViewController()
        let label = UILabel()
        label.text = "Placeholder"
        label.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(label)
        label.backgroundColor = .red
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor),
        ])
        return vc
    }
    
    func setMasterViewController(_ vc: UIViewController) {
        self.masterViewController.removeFromParent()
        self.masterViewController = vc
        addMasterViewController()
    }
    
    func setDetailViewController(_ vc: UIViewController) {
        self.detailViewController.removeFromParent()
        self.detailViewController = vc
        addDetailViewController()
    }
    
    private func addMasterViewController() {
        addChild(masterViewController)
        masterContainer.addSubview(masterViewController.view)
        masterViewController.didMove(toParent: self)
        NSLayoutConstraint.activate([
            masterViewController.view.leadingAnchor.constraint(equalTo: masterContainer.leadingAnchor),
            masterViewController.view.trailingAnchor.constraint(equalTo: masterContainer.trailingAnchor),
            masterViewController.view.topAnchor.constraint(equalTo: masterContainer.topAnchor),
            masterViewController.view.trailingAnchor.constraint(equalTo: masterContainer.trailingAnchor),
        ])
    }
    
    private func addDetailViewController() {
        addChild(detailViewController)
        detailContainer.addSubview(detailViewController.view)
        detailViewController.didMove(toParent: self)
        NSLayoutConstraint.activate([
            detailViewController.view.leadingAnchor.constraint(equalTo: detailContainer.leadingAnchor),
            detailViewController.view.trailingAnchor.constraint(equalTo: detailContainer.trailingAnchor),
            detailViewController.view.topAnchor.constraint(equalTo: detailContainer.topAnchor),
            detailViewController.view.trailingAnchor.constraint(equalTo: detailContainer.trailingAnchor),
        ])
    }
}

#Preview {
    let vc = MasterDetailViewController(ratio: 1.8)
    let one = UIViewController()
    one.view.backgroundColor = .blue
    vc.setMasterViewController(one)
    let two = UIViewController()
    two.view.backgroundColor = .red
    vc.setDetailViewController(two)
    return vc
}
