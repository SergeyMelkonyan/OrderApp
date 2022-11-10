//
//  OrderConfirmationViewController.swift
//  OrderApp
//
//  Created by Sergey Melkonyan on 05.11.22.
//

import UIKit

class OrderConfirmationViewController: UIViewController {

    // MARK: - API
    var minutesToPrepare: Int?

    // MARK: - Subviews
    @IBOutlet weak var confirmationLabel: UILabel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmationLabel.text = "Thank you for your order! Your wait time is approximately \(minutesToPrepare ?? 99999) minutes"
    }

    // MARK: - Callbacks
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        MenuController.shared.order.menuItems.removeAll()
        dismiss(animated: true)
    }
}

extension OrderConfirmationViewController: OrderTableViewControllerDelegate {
    func submitDidTapped(minutesToPrepare: Int) {
        self.minutesToPrepare = minutesToPrepare
    }
}
