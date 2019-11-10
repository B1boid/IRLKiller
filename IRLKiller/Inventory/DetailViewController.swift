//
//  DetailViewController.swift
//  IRLKiller
//
//  Created by Даниил Королёв on 09.11.2019.
//  Copyright © 2019 Aleksandr Vorobev. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        button.backgroundColor = .red
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        button.titleLabel?.text = "Close"
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.sizeToFit()
        button.layer.cornerRadius = button.bounds.height / 2
        
        button.frame = CGRect(x: 20, y: 20, width: 100, height: 100)
        UIView.animate(withDuration: 1, animations: {
            self.view.alpha = 0.6
        }, completion: nil)
    }
    
    @objc func closeVC() {
        self.dismiss(animated: true, completion: nil)
    }
}
