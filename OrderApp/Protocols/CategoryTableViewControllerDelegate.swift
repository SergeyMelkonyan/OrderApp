//
//  CategoryTableViewControllerDelegate.swift
//  OrderApp
//
//  Created by Sergey Melkonyan on 04.11.22.
//

import Foundation

protocol CategoryTableViewControllerDelegate: AnyObject {
    func categoryDidSelect(category: String)
}
