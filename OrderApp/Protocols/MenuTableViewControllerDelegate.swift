//
//  MenuTableViewControllerDelegate.swift
//  OrderApp
//
//  Created by Sergey Melkonyan on 04.11.22.
//

import Foundation

protocol MenuTableViewControllerDelegate: AnyObject {
    func menuDidSelect(menuItem: MenuItem)
}
