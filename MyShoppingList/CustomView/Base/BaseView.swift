//
//  BaseView.swift
//  MyNaverShopping
//
//  Created by 이은서 on 2023/09/15.
//

import UIKit
import SnapKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView() { }
    func setConstraints() { }
    
}
