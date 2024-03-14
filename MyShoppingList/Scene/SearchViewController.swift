//
//  ViewController.swift
//  MyNaverShopping
//
//  Created by 이은서 on 2023/09/15.
//

import UIKit
import RealmSwift

class SearchViewController: BaseViewController {

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
    let buttonsView = ButtonsView()
    
    let realm = try! Realm()
    var likeTable: Results<LikedItem>!
    var sort: Sort = .sim
    var searchResult = Items(total: 0, start: 0, items: [])
    var startPoint = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
    
        searchBar.delegate = self
        likeTable = realm.objects(LikedItem.self)
    }

    override func configView() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(buttonsView)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.title = "상품 검색"
        buttonsView.accuracySortButton.addTarget(self, action: #selector(simButtonTapped), for: .touchUpInside)
        buttonsView.dateSortButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
        buttonsView.highestPriceSortButton.addTarget(self, action: #selector(highestButtonTapped), for: .touchUpInside)
        buttonsView.lowestPriceSortButton.addTarget(self, action: #selector(lowestButtonTapped), for: .touchUpInside)
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
        buttonsView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(14)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        collectionView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(buttonsView.snp.bottom).offset(14)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
    
    @objc func simButtonTapped() {
        buttonsView.switchColor(buttonsView.accuracySortButton)
        sort = .sim
        NetworkManager.shared.callRequest(query: searchBar.text ?? "", sort: .sim) { data in
            self.searchResult = data
            self.collectionView.reloadData()
        }
    }
    
    @objc func dateButtonTapped() {
        buttonsView.switchColor(buttonsView.dateSortButton)
        sort = .date
        NetworkManager.shared.callRequest(query: searchBar.text ?? "", sort: .date) { data in
            self.searchResult = data
            self.collectionView.reloadData()
        }
    }
    
    @objc func highestButtonTapped() {
        buttonsView.switchColor(buttonsView.highestPriceSortButton)
        sort = .dsc
        NetworkManager.shared.callRequest(query: searchBar.text ?? "", sort: .dsc) { data in
            self.searchResult = data
            self.collectionView.reloadData()
        }
    }
  
    @objc func lowestButtonTapped() {
        buttonsView.switchColor(buttonsView.lowestPriceSortButton)
        sort = .asc
        NetworkManager.shared.callRequest(query: searchBar.text ?? "", sort: .asc) { data in
            self.searchResult = data
            self.collectionView.reloadData()
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResult.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DisplayItemCollectionViewCell else { return UICollectionViewCell() }
        
        let item = searchResult.items[indexPath.item]
        let like = likeTable.where { data in
            data.productId == item.productId
        }.first
        
        if let like {
            cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        
        cell.mallLabel.text = item.mallName
        cell.titleLabel.text = item.title.htmlEscaped
        cell.priceLabel.text = cell.numToDec(num: item.lprice)
        
        if let url = URL(string: item.image) {
            DispatchQueue.global().async {
                let data = try! Data(contentsOf: url)
                DispatchQueue.main.async {
                    cell.productImage.image = UIImage(data: data)
                    
                    cell.completionHandler = {
                        switch cell.isLiked {
                        case true:
                            print("클릭 true")
                            cell.isLiked = false
                            $0.setImage(UIImage(systemName: "heart"), for: .normal)
                            self.removeImageFromDocument(fileName: "\(item.productId).jpg")
                            
                            do {
                                try self.realm.write {
                                    let like = self.realm.objects(LikedItem.self).where {
                                        $0.productId == item.productId
                                        }
                                    self.realm.delete(like)
                                }
                            } catch {
                                print(error)
                            }
                            
                          
                        case false:
                            print("클릭 false")
                            cell.isLiked = true
                            self.saveImageToDocument(fileName: "\(item.productId).jpg", image: cell.productImage.image ?? UIImage(systemName: "xmark")!)
                            $0.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                            
                            do {
                                try self.realm.write {
                                    self.realm.add(LikedItem(title: item.title, productId: item.productId, mallName: item.mallName, price: item.lprice, image: item.image))
                                }
                            } catch {
                                print(error)
                            }
                        }
                       
                    }
                }
            }
        }
        
      
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DisplayItemCollectionViewCell else { return }
        let vc = DetailViewController()
        let item = searchResult.items[indexPath.item]
        if let url = URL(string: item.image) {
            DispatchQueue.global().async {
                let data = try! Data(contentsOf: url)
                vc.thumbImage = UIImage(data: data)
            }
        }
        vc.productId = item.productId
        vc.itemTitle = item.title
        vc.resultItem = item
        vc.scene = .search
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for i in indexPaths {
            print(indexPaths)
            if searchResult.items.count - 1 == i.item {
                if let text = searchBar.text {
                    startPoint += 30
                    NetworkManager.shared.callRequest(query: text, startPoint: startPoint, sort: sort) { data in
                        self.searchResult.items.append(contentsOf: data.items)
                        collectionView.reloadData()
                    }
                }
            }
        }
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        startPoint = 1
        guard let text = searchBar.text else {
            print("유효한 검색어를 입력해주세요")
            return
        }
        NetworkManager.shared.callRequest(query: text, sort: sort) { data in
            self.searchResult = data
            self.collectionView.reloadData()
        }
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        view.endEditing(true)
    }
    
}
