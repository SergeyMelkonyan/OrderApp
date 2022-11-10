//
//  MenuItemDetailViewController.swift
//  OrderApp
//
//  Created by Sergey Melkonyan on 04.11.22.
//

import UIKit

class MenuItemDetailViewController: UIViewController {

    // MARK: - Subviews
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailTextLabel: UILabel!
    @IBOutlet weak var addToOrderButton: UIButton!

    // MARK: - API
    var menuItem: MenuItem?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        addToOrderButton.layer.cornerRadius = 5
        updateUI()
    }

    // MARK: - Helpers
    func updateUI() {
        guard let menuItem else { return }
        nameLabel.text = menuItem.name
        priceLabel.text = MenuItem.priceFormatter.string(from: NSNumber(value: menuItem.price))
        detailTextLabel.text = menuItem.detailText
        imageView.image = UIImage(systemName: "photo.on.rectangle")
        MenuController.shared.fetchImage(url: menuItem.imageURL) { image in
            guard let image else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }

    // MARK: - Callbacks
    @IBAction func addToOrderButtonTapped(_ sender: UIButton) {
        UIView.animate(
            withDuration: 0.5, delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.1,
            options: [], animations: {
                self.addToOrderButton.transform =
                CGAffineTransform(scaleX: 2.0, y: 2.0)
                self.addToOrderButton.transform =
                CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        )

        if let menuItem {
            MenuController.shared.order.menuItems.append(menuItem)
        }
    }
}

extension MenuItemDetailViewController: MenuTableViewControllerDelegate {
    // MARK: - Delegation
    func menuDidSelect(menuItem: MenuItem) {
        self.menuItem = menuItem
    }
}
