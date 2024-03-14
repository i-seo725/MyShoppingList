//
//  SearchDisplayTableViewCell.swift
//  MyShoppingList
//
//  Created by 이은서 on 3/14/24.
//

import UIKit

class SearchDisplayTableViewCell: UITableViewCell {
    
    let productImage = {
        let view = UIImageView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .sky
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
        view.textColor = .black
        view.textAlignment = .left
        view.text = "TITLE !!!!!!!!! @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        view.numberOfLines = 2
        return view
    }()
    
    let priceLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 14)
        view.textColor = .black
        view.textAlignment = .left
        view.text = "PRICE @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        view.numberOfLines = 1
        return view
    }()
    
    let likeButton = {
        let view = UIButton()
        view.backgroundColor = .white
        view.setImage(UIImage(systemName: "heart"), for: .normal)
        view.tintColor = .gold
        view.clipsToBounds = true
        view.layer.cornerRadius = 35/2
        return view
    }()
    
    var completionHandler: ((UIButton) -> Void)?
    var isLiked = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        productImage.image = nil
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
            make.height.leading.equalToSuperview().inset(2)
            make.width.equalTo(productImage.snp.height)
            make.top.equalToSuperview()
        }
        mallLabel.snp.makeConstraints { make in
            make.top.equalTo(productImage.snp.top).offset(1)
            make.leading.equalTo(productImage.snp.trailing).offset(4)
            
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallLabel.snp.bottom).offset(4)
            make.leading.equalTo(productImage.snp.trailing).offset(4)
            make.trailing.equalTo(likeButton.snp.leading).inset(4)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(productImage.snp.trailing).offset(4)
        }
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(35)
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
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
