//
//  RecentViewController.swift
//  MyShoppingList
//
//  Created by 이은서 on 1/21/24.
//

import UIKit
import RealmSwift

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
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.layout())
        view.register(DisplayItemCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return view
    }()
    
    func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 20
        let size = UIScreen.main.bounds.width - 30
        layout.itemSize = CGSize(width: (size / 3) * 0.97 , height: (size / 3) * 1.42)
        return layout
    }
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configView() {
        super.configView()
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationItem.title = "최근 본 상품 목록"
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(14)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension RecentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DisplayItemCollectionViewCell else { return UICollectionViewCell() }
        
        cell.backgroundColor = .sky
        
//        let item = likeTable[indexPath.item]
//
//        cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//        cell.titleLabel.text = item.title.htmlEscaped
//        cell.mallLabel.text = item.mallName
//        cell.priceLabel.text = cell.numToDec(num: item.price)
//        cell.productImage.image = loadImageFromDocument(fileName: "\(item.productId).jpg")
//        cell.completionHandler = { _ in
//            print("클릭 true")
//            self.removeImageFromDocument(fileName: "\(item.productId).jpg")
//            
//            do {
//                try self.realm.write {
//                    let like = self.realm.objects(LikedItem.self).where {
//                        $0.productId == item.productId
//                        }
//                    self.realm.delete(like)
//                }
//                collectionView.reloadData()
//            } catch {
//                print(error)
//            }
//        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vc = DetailViewController()
//        let item = likeTable[indexPath.item]
//        vc.isLiked = true
//        vc.productId = item.productId
//        vc.itemTitle = item.title
//        vc.scene = .like
//        vc.selectedItem = item
//        vc.thumbImage = loadImageFromDocument(fileName: "\(item.productId).jpg")
//        navigationController?.pushViewController(vc, animated: true)
    }
}
