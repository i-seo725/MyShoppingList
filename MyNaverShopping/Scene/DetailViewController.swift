//
//  DetailViewController.swift
//  MyNaverShopping
//
//  Created by 이은서 on 2023/09/15.
//

import UIKit
import WebKit
import RealmSwift

class DetailViewController: BaseViewController {
    
    var webView = WKWebView()
    var isLiked = false
    var likeBarButton: UIBarButtonItem!
    var itemTitle: String?
    var productId: String?
    let realm = try! Realm()
    var scene: Present = .like
    var thumbImage: UIImage?
    
    var selectedItem: LikedItem?
    lazy var temp = selectedItem
    var likeTable: Results<LikedItem>?
    var resultItem: ItemList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let productId, let itemTitle else { return }
        navigationItem.title = itemTitle.htmlEscaped
        let url = URL(string: "https://msearch.shopping.naver.com/product/" + productId)
        let request = URLRequest(url: url!)
        webView.load(request)
        likeTable = realm.objects(LikedItem.self)
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
        switch scene {
        case .search:
            guard let resultItem, let thumbImage else {
                return }
            switch isLiked {
            case true:
                isLiked = false
                likeBarButton.image = UIImage(systemName: "heart")
                self.removeImageFromDocument(fileName: "\(resultItem.productId).jpg")
                isLiked = false
                do {
                    try self.realm.write {
                        let like = self.realm.objects(LikedItem.self).where {
                            $0.productId == resultItem.productId
                            }
                        self.realm.delete(like)
                    }
                } catch {
                    print(error)
                }
                
            case false:
                isLiked = true
                self.saveImageToDocument(fileName: "\(resultItem.productId).jpg", image: thumbImage)
                likeBarButton.image = UIImage(systemName: "heart.fill")
                
                do {
                    try self.realm.write {
                        self.realm.add(LikedItem(title: resultItem.title, productId: resultItem.productId, mallName: resultItem.mallName, price: resultItem.lprice, image: resultItem.image))
                    }
                } catch {
                    print(error)
                }
            }
        case .like:
            guard let item = selectedItem, let temp, let thumbImage, let id = productId else { return }
           
            switch isLiked {
            case true:
                likeBarButton.image = UIImage(systemName: "heart")
                self.removeImageFromDocument(fileName: "\(temp.productId).jpg")
                isLiked = false
                do {
                    try self.realm.write {
                        self.realm.delete(temp)
                    }
                } catch {
                    print(error)
                }
                
            case false:
                isLiked = true
                do {
                    try self.realm.write {
                        self.realm.add(item)
                    }
                } catch {
                    print(error)
                }
                
                self.saveImageToDocument(fileName: "\(item.productId).jpg", image: thumbImage)
                likeBarButton.image = UIImage(systemName: "heart.fill")
            }
            
        }
        
        
    }
    
    
}
