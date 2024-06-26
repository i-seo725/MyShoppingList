//
//  SortButton.swift
//  MyNaverShopping
//
//  Created by 이은서 on 2023/09/15.
//

import UIKit

class SortButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView() {
        layer.cornerRadius = 9
        layer.borderWidth = 1
        titleLabel?.font = .systemFont(ofSize: 12)
        setNormalColor()
    }
    
    func setNormalColor() {
        layer.borderColor = UIColor.sky.cgColor
        setTitleColor(.gray, for: .normal)
        backgroundColor = .clear
    }
    
    func setSelectedColor() {
        layer.borderColor = UIColor.sky.cgColor
        backgroundColor = .sky
        setTitleColor(.white, for: .normal)
    }
    
}
