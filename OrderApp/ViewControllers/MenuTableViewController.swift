//
//  MenuTableViewController.swift
//  OrderApp
//
//  Created by Sergey Melkonyan on 04.11.22.
//

import UIKit

class MenuTableViewController: UITableViewController {

    var category = ""
    var menuItems = [MenuItem]()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        fetchMenu()
    }

    func fetchMenu() {
        MenuController.shared.fetchMenuItems(forCategory: category) { result in
            switch result {
            case .success(let menuItems):
                self.updateUI(with: menuItems)
            case .failure(let error):
                self.displayError(error, title: "Failed to Fetch Menu Items for \(self.category)")
            }
        }
    }

    // MARK: - Helpers
    func setDelegate() {
        let categoryController = storyboard?.instantiateViewController(
            withIdentifier: "categoryVC"
        ) as? CategoryTableViewController

        categoryController?.delegate = self
    }

    func updateUI(with menuItems: [MenuItem]) {
        DispatchQueue.main.async {
            self.menuItems = menuItems
            self.tableView.reloadData()
        }
    }

    func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alert, animated: true)
        }
    }

    // MARK: - Delegate
    weak var delegate: MenuTableViewControllerDelegate?

    // MARK: - TableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: MenuTableViewController.self, for: indexPath)
        let menuItem = menuItems[indexPath.row]
        self.title = menuItem.name

        var config = cell.defaultContentConfiguration()
        config.text = menuItem.name
        config.secondaryText = MenuItem.priceFormatter.string(from: NSNumber(value: menuItem.price))
        config.image = UIImage(systemName: "photo.on.rectangle")
        
        MenuController.shared.fetchImage(url: menuItem.imageURL) { image in
            guard let image else { return }
            if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath != indexPath {
                return
            }

            config.image = image
        }

        cell.contentConfiguration = config
        cell.setNeedsLayout()
        return cell
    }

    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuDetailVC = storyboard?.instantiateViewController(
            withIdentifier: "menuDetailVC"
        ) as? MenuItemDetailViewController
        else { return }

        delegate = menuDetailVC
        delegate?.menuDidSelect(menuItem: menuItems[indexPath.row])
        navigationController?.pushViewController(menuDetailVC, animated: true)
    }
}

extension MenuTableViewController: CategoryTableViewControllerDelegate {
    func categoryDidSelect(category: String) {
        self.category = category
    }
}
