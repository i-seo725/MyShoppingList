//
//  DisplayItemCollectionViewCell.swift
//  MyNaverShopping
//
//  Created by 이은서 on 2023/09/15.
//

import UIKit

class DisplayItemCollectionViewCell: UICollectionViewCell {
    
    let productImage = {
        let view = UIImageView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .brown
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    let mallLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 11)
        view.textColor = .lightGray
        view.textAlignment = .left
        view.text = "MALL @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        view.numberOfLines = 1
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12.5)
        view.textColor = .white
        view.textAlignment = .left
        view.text = "TITLE !!!!!!!!! @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        view.numberOfLines = 2
        return view
    }()
    
    let priceLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 16)
        view.textColor = .white
        view.textAlignment = .left
        view.text = "PRICE @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        view.numberOfLines = 1
        return view
    }()
    
    let likeButton = {
        let view = UIButton()
        view.backgroundColor = .white
        view.setImage(UIImage(systemName: "heart"), for: .normal)
        view.tintColor = .black
        view.clipsToBounds = true
        return view
    }()
    
    var completionHandler: ((UIButton) -> Void)?
    var isLiked = false
    
    func makeCircle(_ view: UIView) {
        DispatchQueue.main.async {
            view.layer.cornerRadius = view.frame.width / 2
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
        setConstraints()
        makeCircle(likeButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        productImage.image = nil
        makeCircle(likeButton)
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    func configView() {
        contentView.addSubview(productImage)
        contentView.addSubview(mallLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(likeButton)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    @objc func likeButtonTapped() {
        completionHandler?(likeButton)
    }
    
    func setConstraints() {
        productImage.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(productImage.snp.width)
            make.top.equalToSuperview()
        }
        mallLabel.snp.makeConstraints { make in
            make.top.equalTo(productImage.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(4)
            
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(4)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(4)
        }
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(35)
            make.bottom.trailing.equalTo(productImage).inset(8)
        }
    }
    
    func numToDec(num: String) -> String {
        let numFormatter = NumberFormatter()
        numFormatter.numberStyle = .decimal
        guard let num = Int(num), let result = numFormatter.string(for: num) else {
            print(num, "@@", numFormatter.string(for: num))
            return "" }
        return result
    }
    
    
}
