//
//  RecentViewController.swift
//  MyShoppingList
//
//  Created by 이은서 on 1/21/24.
//

import UIKit

class RecentViewController: BaseViewController {
    
    let searchBar = {
        let view = UISearchBar()
        view.placeholder = "검색어를 입력하세요"
        view.searchTextField.borderStyle = .roundedRect
        view.showsCancelButton = true
        view.tintColor = .sky
        view.searchTextField.tintColor = .sky
        view.searchBarStyle = .minimal
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configView() {
        super.configView()
        view.addSubview(searchBar)
        navigationItem.title = "최근 본 상품 목록"
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
    }
}
