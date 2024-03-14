//
//  BaseViewController.swift
//  MyNaverShopping
//
//  Created by 이은서 on 2023/09/15.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        setConstraints()
    }
    
    func configView() {
        view.backgroundColor = .white
    }
    
    func setConstraints() { }
    
}
