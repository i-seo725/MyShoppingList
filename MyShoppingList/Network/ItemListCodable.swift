//
//  ItemListCodable.swift
//  MyNaverShopping
//
//  Created by 이은서 on 2023/09/15.
//

import Foundation

struct Items: Codable {
    let total, start: Int
    var items: [ItemList]
}

struct ItemList: Codable {
    let title: String
    let image: String
    let mallName, productId: String
    let lprice: String
}
