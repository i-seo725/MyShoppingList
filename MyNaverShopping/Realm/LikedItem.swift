//
//  LikedItem.swift
//  MyNaverShopping
//
//  Created by 이은서 on 2023/09/15.
//

import Foundation
import RealmSwift

class LikedItem: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var productId: String
    @Persisted var mallName: String
    @Persisted var price: String
    @Persisted var image: String
    
    convenience init(title: String, productId: String, mallName: String, price: String, image: String) {
        
        self.init()
        self.title = title
        self.productId = productId
        self.mallName = mallName
        self.price = price
        self.image = image
    }
}
