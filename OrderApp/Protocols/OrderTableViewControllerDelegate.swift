//
//  OrderTableViewControllerDelegate.swift
//  OrderApp
//
//  Created by Sergey Melkonyan on 05.11.22.
//

import Foundation

protocol OrderTableViewControllerDelegate: AnyObject {
    func submitDidTapped(minutesToPrepare: Int)
}
