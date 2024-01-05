//
//  WoofViewController.swift
//  IpadExperiment
//
//  Created by Jack.Costigan on 05/01/2024.
//

import UIKit

class WoofViewController: UIViewController {
    let numberOfWoofs = 5
    
    lazy var woofs: [UILabel] = {
        func createWoof() -> UILabel {
            let label = UILabel()
            label.text = "woof"
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: 20.0)
            return label
        }
        return (0..<numberOfWoofs).map { _ in createWoof() }
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
    WoofViewController()
}
