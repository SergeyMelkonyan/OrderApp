//
//  UITableView+Generic.swift
//  OrderApp
//
//  Created by Sergey Melkonyan on 04.11.22.
//

import Foundation
import UIKit

extension UITableView {
    func dequeueReusableCell<CellType: UITableViewCell>(
        ofType type: UIViewController.Type,
        for indexPath: IndexPath
    ) -> CellType {
        let reuseIdentifier = String(describing: type.self)
        guard let cell = self.dequeueReusableCell(
            withIdentifier: reuseIdentifier,
            for: indexPath
        ) as? CellType
        else { fatalError()}

        return cell
    }
}
