//
//  ButtonsView.swift
//  MyNaverShopping
//
//  Created by 이은서 on 2023/09/15.
//

import UIKit

class ButtonsView: BaseView {
    
    let accuracySortButton = {
        let view = SortButton()
        view.setTitle(" 정확도 ", for: .normal)
        view.setSelectedColor()
        return view
    }()
    let dateSortButton = {
        let view = SortButton()
        view.setTitle(" 날짜순 ", for: .normal)
        return view
    }()
    let highestPriceSortButton = {
        let view = SortButton()
        view.setTitle(" 가격높은순 ", for: .normal)
        return view
    }()
    let lowestPriceSortButton = {
        let view = SortButton()
        view.setTitle(" 가격낮은순 ", for: .normal)
        return view
    }()
    
    override func configView() {
        addSubview(accuracySortButton)
        addSubview(dateSortButton)
        addSubview(highestPriceSortButton)
        addSubview(lowestPriceSortButton)
        backgroundColor = .clear
    }
    
    override func setConstraints() {
        accuracySortButton.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
        }
        
        dateSortButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalTo(accuracySortButton.snp.trailing).offset(6)
        }
        
        highestPriceSortButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalTo(dateSortButton.snp.trailing).offset(6)
        }
        
        lowestPriceSortButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalTo(highestPriceSortButton.snp.trailing).offset(6)
        }
        
        
    }
    
    func switchColor(_ item: SortButton) {
        let buttons = [accuracySortButton, dateSortButton, highestPriceSortButton, lowestPriceSortButton]
        
        for i in buttons {
            i.setNormalColor()
        }
        item.setSelectedColor()
    }
    
    
}
