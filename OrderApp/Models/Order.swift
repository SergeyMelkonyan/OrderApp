//
//  Order.swift
//  OrderApp
//
//  Created by Sergey Melkonyan on 04.11.22.
//

import Foundation

struct Order: Codable {
    var menuItems: [MenuItem]

    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
