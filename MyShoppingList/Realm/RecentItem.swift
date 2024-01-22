//
//  RecentItem.swift
//  MyShoppingList
//
//  Created by 이은서 on 1/21/24.
//

import Foundation
import RealmSwift

class RecentItem: Object {
    @Persisted(primaryKey: true) var productId: String
    @Persisted var title: String
    @Persisted var mallName: String
    @Persisted var price: String
    @Persisted var image: String
    @Persisted var date: Date
    
    convenience init(title: String, productId: String, mallName: String, price: String, image: String, date: Date = Date()) {
        
        self.init()
        self.title = title
        self.productId = productId
        self.mallName = mallName
        self.price = price
        self.image = image
        self.date = date
    }
}
