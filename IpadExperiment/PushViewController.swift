//
//  PushViewController.swift
//  IpadExperiment
//
//  Created by Jack.Costigan on 22/01/2024.
//

import UIKit

class PushViewController: UIViewController {
    lazy var depthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Depth \(depth)"
        return label
    }()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()
    
    lazy var pushButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Push me!", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(buttonWasPushed), for: .touchUpInside)
        return button
    }()
    
    private let depth: Int
    
    init(depth: Int) {
        self.depth = depth
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
        view.backgroundColor = .white
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        stack.addArrangedSubview(depthLabel)
        stack.addArrangedSubview(pushButton)
    }
    
    @objc private func buttonWasPushed() {
        buttonCallback?(self)
    }
    
    var buttonCallback: ((PushViewController) -> Void)?
}

#Preview {
    PushViewController(depth: 3)
}
