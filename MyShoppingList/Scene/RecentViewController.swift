//
//  RecentViewController.swift
//  MyShoppingList
//
//  Created by 이은서 on 1/21/24.
//

import UIKit
import RealmSwift
import Kingfisher

class RecentViewController: BaseViewController {
    
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
    var recentTable: Results<RecentItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        checkNumberOfTable()
//        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkNumberOfTable()
        collectionView.reloadData()
    }
    
    override func configView() {
        super.configView()
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationItem.title = "최근 본 상품 목록"
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(14)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func checkNumberOfTable() {
        recentTable = realm.objects(RecentItem.self).sorted(by: \.date, ascending: false)
        while recentTable.count > 30 {
            let item = realm.objects(RecentItem.self).sorted(by: \.date, ascending: true).first!
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print(error)
            }
        }
        recentTable = realm.objects(RecentItem.self).sorted(by: \.date, ascending: false)
    }
    
}

extension RecentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentTable.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DisplayItemCollectionViewCell else { return UICollectionViewCell() }
        

        
        let item = recentTable[indexPath.item]

        cell.likeButton.isHidden = true
        cell.titleLabel.text = item.title.htmlEscaped
        cell.mallLabel.text = item.mallName
        cell.priceLabel.text = cell.numToDec(num: item.price)
        cell.productImage.kf.setImage(with: URL(string: item.image))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        let item = recentTable[indexPath.item]
        vc.isLiked = false
        vc.productId = item.productId
        vc.itemTitle = item.title
        vc.scene = .search
        vc.thumbImage = loadImageFromDocument(fileName: "\(item.productId).jpg")
        navigationController?.pushViewController(vc, animated: true)
    }
}
