//
//  OrderTableViewController.swift
//  OrderApp
//
//  Created by Sergey Melkonyan on 04.11.22.
//

import UIKit

class OrderTableViewController: UITableViewController {

    var minutesToPrepare = 0

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem

        NotificationCenter.default.addObserver(
            tableView!,
            selector: #selector(UITableView.reloadData),
            name: MenuController.orderUpdatedNotification,
            object: nil
        )

        
    }

    // MARK: - Delegation
    weak var delegate: OrderTableViewControllerDelegate?

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuController.shared.order.menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: OrderTableViewController.self, for: indexPath)
        let menuItem = MenuController.shared.order.menuItems[indexPath.row]

        var config = cell.defaultContentConfiguration()
        config.text = menuItem.name
        config.secondaryText = MenuItem.priceFormatter.string(from: NSNumber(value: menuItem.price))
        cell.contentConfiguration = config
        config.image = UIImage(systemName: "photo.on.rectangle")

        MenuController.shared.fetchImage(url: menuItem.imageURL) { image in
            guard let image else {
                return
            }
            DispatchQueue.main.async {
                if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath != indexPath {
                    return
                }

                config.image = image
                cell.contentConfiguration = config
                cell.setNeedsLayout()
            }
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            MenuController.shared.order.menuItems.remove(at: indexPath.row)
        }
    }

    // MARK: - Callbacks
    @IBAction func submitButtonTapped(_ sender: UIBarButtonItem) {
        let orderTotal = MenuController.shared.order.menuItems.reduce(0.0) { (result, menuItem) -> Double in
            return result + Double(menuItem.price)
        }

        let formattedTotal = MenuItem.priceFormatter.string(from: NSNumber(value: orderTotal)) ?? "\(orderTotal)"

        let alertController = UIAlertController(
            title: "Confirm Order",
            message: "You are about to submit your order with a total of \(formattedTotal)",
            preferredStyle: .actionSheet
        )
        alertController.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
            self.uploadOrder()
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }

    func uploadOrder() {
        guard let orderConfirmationVC = storyboard?.instantiateViewController(
            withIdentifier: "orderConfirmationID"
        ) as? OrderConfirmationViewController
        else { return }

        delegate = orderConfirmationVC

        let menuIDs = MenuController.shared.order.menuItems.map { $0.id }
        MenuController.shared.submitOrder(forMenuIDs: menuIDs) { result in
            switch result {
            case .success(let minutesToPrepare):
                DispatchQueue.main.async {
                    self.minutesToPrepare = minutesToPrepare
                    self.delegate?.submitDidTapped(minutesToPrepare: minutesToPrepare)
                    self.present(orderConfirmationVC, animated: true)
                }
            case .failure(let error):
                self.displayError(error, title: "Order Submission Failed")
            }
        }
    }

    func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alert, animated: true)
        }
    }
}
