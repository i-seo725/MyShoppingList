//
//  DetailViewController.swift
//  MyNaverShopping
//
//  Created by 이은서 on 2023/09/15.
//

import UIKit
import WebKit

class DetailViewController: BaseViewController {
    
    var webView = WKWebView()
    var isLiked = false
    var likeBarButton: UIBarButtonItem!
    var itemTitle: String?
    var productId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let productId, let itemTitle else { return }
        navigationItem.title = itemTitle.htmlEscaped
        let url = URL(string: "https://msearch.shopping.naver.com/product/" + productId)
        let request = URLRequest(url: url!)
        webView.load(request)
    
        likeBarButton.image = isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
    
    override func configView() {
        view.addSubview(webView)
        setAppearance()
    }
    
    override func setConstraints() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setAppearance() {
        let navAppearance = UINavigationBarAppearance()
        navAppearance.backgroundColor = .black
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.standardAppearance = navAppearance
        navigationController?.navigationBar.tintColor = .white
        likeBarButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(likeBarButtonClicked))
        navigationItem.rightBarButtonItem = likeBarButton
        
        let tabAppearance = UITabBarAppearance()
        tabAppearance.backgroundColor = .black
        tabBarController?.tabBar.standardAppearance = tabAppearance
    }
    
    @objc func likeBarButtonClicked() {
        print("좋아요 바 버튼 클릭")
    }
    
    
}
