//
//  BarkViewController.swift
//  IpadExperiment
//
//  Created by Jack.Costigan on 05/01/2024.
//

import UIKit

class BarkViewController: UIViewController {
    private let numberOfBarks = 5
    private let bark: String
    
    init(bark: String = "woof") {
        self.bark = bark
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var woofs: [UILabel] = {
        func createWoof() -> UILabel {
            let label = UILabel()
            label.text = bark
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: 20.0)
            return label
        }
        return (0..<numberOfBarks).map { _ in createWoof() }
    }()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        for woof in woofs {
            stack.addArrangedSubview(woof)
        }
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }

    func setupSubviews() {
        view.addSubview(stack)
        view.backgroundColor = .white
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startAnimation()
    }
    
    func startAnimation() {
        for woof in woofs {
            woof.layer.removeAllAnimations()
            woof.layer.opacity = 1.0
        }
        var delay = 0.0
        for woof in woofs {
            UIView.animate(withDuration: 1.0, delay: delay, options: [.repeat, .autoreverse]) {
                woof.layer.opacity = 0.0
            }
            delay += 0.2
        }
    }
}

#Preview {
    BarkViewController()
}
