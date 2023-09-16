//
//  LikeViewController.swift
//  MyNaverShopping
//
//  Created by 이은서 on 2023/09/15.
//

import UIKit
import RealmSwift

class LikeViewController: BaseViewController {

    let searchBar = {
        let view = UISearchBar()
        view.placeholder = "검색어를 입력하세요"
        view.searchTextField.borderStyle = .roundedRect
        view.showsCancelButton = true
        view.tintColor = .white
        view.searchTextField.textColor = .white
        view.searchTextField.tintColor = .white
        view.searchBarStyle = .minimal
        return view
    }()
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.layout())
        view.register(DisplayItemCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.backgroundColor = .black
        return view
    }()
    
    func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 20
        let size = UIScreen.main.bounds.width - 30
        layout.itemSize = CGSize(width: size / 2 , height: (size / 2) * 1.42)
        return layout
    }
    
    let realm = try! Realm()
    var allLikeTable: Results<LikedItem>!
    var likeTable: Results<LikedItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        
        allLikeTable = realm.objects(LikedItem.self)
        likeTable = realm.objects(LikedItem.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

    override func configView() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.title = "좋아요 목록"
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

extension LikeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likeTable.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DisplayItemCollectionViewCell else { return UICollectionViewCell() }
        
        let item = likeTable[indexPath.item]

        cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        cell.titleLabel.text = item.title.htmlEscaped
        cell.mallLabel.text = item.mallName
        cell.priceLabel.text = cell.numToDec(num: item.price)
        cell.productImage.image = loadImageFromDocument(fileName: "\(item.productId).jpg")
        cell.completionHandler = { _ in
            print("클릭 true")
            self.removeImageFromDocument(fileName: "\(item.productId).jpg")
            
            do {
                try self.realm.write {
                    let like = self.realm.objects(LikedItem.self).where {
                        $0.productId == item.productId
                        }
                    self.realm.delete(like)
                }
                collectionView.reloadData()
            } catch {
                print(error)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        let item = likeTable[indexPath.item]
        vc.isLiked = true
        vc.productId = item.productId
        vc.itemTitle = item.title
        
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension LikeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        if text.count == 0 {
            likeTable = allLikeTable
        }
        let result = allLikeTable.where {
            $0.title.contains(text)
        }
        likeTable = result
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        view.endEditing(true)
        likeTable = allLikeTable
        collectionView.reloadData()
    }
}
