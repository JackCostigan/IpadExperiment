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
    private lazy var containerWidthConstraint = detailContainer.widthAnchor.constraint(equalTo: masterContainer.widthAnchor, multiplier: ratio)
    private let ratio: Double
    private lazy var border: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = borderColor
        return view
    }()
    private let borderColor: UIColor
    private let borderWidth: Double
    
    init(ratio: Double = 2.0,
         borderColor: UIColor = .systemGray3,
         borderWidth: Double = 1.0,
         masterViewController: UIViewController = createEmptyPlaceholderViewController(),
         detailViewController: UIViewController = createEmptyPlaceholderViewController()) {
        self.ratio = ratio
        self.borderColor = borderColor
        self.borderWidth = borderWidth
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
        view.addSubview(border)
        NSLayoutConstraint.activate([
            masterContainer.topAnchor.constraint(equalTo: view.topAnchor),
            masterContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            masterContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailContainer.topAnchor.constraint(equalTo: view.topAnchor),
            detailContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            detailContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            border.topAnchor.constraint(equalTo: view.topAnchor),
            border.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            border.leadingAnchor.constraint(equalTo: masterContainer.trailingAnchor),
            border.trailingAnchor.constraint(equalTo: detailContainer.leadingAnchor),
            border.widthAnchor.constraint(equalToConstant: borderWidth),
            containerWidthConstraint,
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
        let oldViewController = self.masterViewController
        self.masterViewController = vc
        addMasterViewController()
        oldViewController.willMove(toParent: nil)
        oldViewController.view.removeFromSuperview()
        oldViewController.removeFromParent()
    }
    
    func setDetailViewController(_ vc: UIViewController) {
        let oldViewController = self.detailViewController
        self.detailViewController = vc
        addDetailViewController()
        oldViewController.willMove(toParent: nil)
        oldViewController.view.removeFromSuperview()
        oldViewController.removeFromParent()
    }
    
    private func addMasterViewController() {
        addChild(masterViewController)
        masterViewController.view.frame = masterContainer.frame
        masterContainer.addSubview(masterViewController.view)
        masterViewController.didMove(toParent: self)
        masterViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            masterViewController.view.leadingAnchor.constraint(equalTo: masterContainer.leadingAnchor),
            masterViewController.view.trailingAnchor.constraint(equalTo: masterContainer.trailingAnchor),
            masterViewController.view.topAnchor.constraint(equalTo: masterContainer.topAnchor),
            masterViewController.view.bottomAnchor.constraint(equalTo: masterContainer.bottomAnchor),
        ])
    }
    
    private func addDetailViewController() {
        addChild(detailViewController)
        detailViewController.view.frame = detailContainer.frame
        detailContainer.addSubview(detailViewController.view)
        detailViewController.didMove(toParent: self)
        detailViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailViewController.view.leadingAnchor.constraint(equalTo: detailContainer.leadingAnchor),
            detailViewController.view.trailingAnchor.constraint(equalTo: detailContainer.trailingAnchor),
            detailViewController.view.topAnchor.constraint(equalTo: detailContainer.topAnchor),
            detailViewController.view.bottomAnchor.constraint(equalTo: detailContainer.bottomAnchor),
        ])
    }
    
    func expand() {
        // deactivate one set of constraints
        // activate another
        // remove views
    }
    
    func collapse() {
        containerWidthConstraint.isActive = false
        detailContainer.widthAnchor.constraint(equalToConstant: 0.0).isActive = true
        detailViewController.view.removeFromSuperview()
        detailViewController.didMove(toParent: nil)
        detailViewController.removeFromParent()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("XXX view did layout subviews \(view.bounds) XXX")
        if view.bounds.width < 500 {
            // send message to a delegate
            // remove master view
        }
    }
    
    override func willTransition(
        to newCollection: UITraitCollection,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.willTransition(to: newCollection, with: coordinator)
        print("XXX will transition \(view.bounds) XXX")
    }
}

class ExampleViewController: UIViewController {
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    init(color: UIColor, text: String) {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = color
        self.view.layer.borderColor = UIColor.white.cgColor
        self.view.layer.borderWidth = 8.0
        self.label.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    private func setupSubviews() {
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

#Preview {
    let vc = MasterDetailViewController(ratio: 1.8, borderWidth: 5.0)
    let one = ExampleViewController(color: .red, text: "Red view")
    let two = ExampleViewController(color: .blue, text: "Blue view")
    let three = ExampleViewController(color: .green, text: "Green view")
    vc.setMasterViewController(one)
    vc.setDetailViewController(two)
    vc.setDetailViewController(three)
    return vc
}
