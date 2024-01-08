//
//  SpinnyViewController.swift
//  IpadExperiment
//
//  Created by Jack.Costigan on 05/01/2024.
//

import UIKit

class SpinnyViewController: UIViewController {
    private let imageName: String
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: imageName)
        return image
    }()
    
    init(imageName: String = "dog.circle") {
        self.imageName = imageName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

#Preview {
    SpinnyViewController()
}
