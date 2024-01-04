//
//  ViewController.swift
//  IpadExperiment
//
//  Created by Jack.Costigan on 04/01/2024.
//

import UIKit

class DogViewController: UIViewController {
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "dog.circle")
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    func setupSubviews() {
        view.addSubview(image)
        view.backgroundColor = .white
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            image.heightAnchor.constraint(equalToConstant: 100.0),
            image.widthAnchor.constraint(equalTo: image.heightAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startSpinning()
    }
    
    func startSpinning() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = 1.0
        rotateAnimation.repeatCount = .greatestFiniteMagnitude
        image.layer.add(rotateAnimation, forKey: "rotation")
    }
}

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

#Preview("Split view controller") {
    let split = UISplitViewController(style: .doubleColumn)
    split.viewControllers = [DogViewController(), WoofViewController()]
    return split
}

