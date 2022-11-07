//
//  CategoryTableViewController.swift
//  OrderApp
//
//  Created by Sergey Melkonyan on 04.11.22.
//

import UIKit

class CategoryTableViewController: UITableViewController {

    // MARK: - TableView Data
    var categories = [String]()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchCategories()
    }

    // MARK: - Delegate
    weak var delegate: CategoryTableViewControllerDelegate?

    // MARK: - Helpers
    func fetchCategories() {
        MenuController.shared.fetchCategories { result in
            switch result {
            case .success(let categories):
                self.updateUI(with: categories)
            case .failure(let error):
                self.displayError(error, title: "Failed to fetch categories")
            }
        }
    }

    func updateUI(with categories: [String]) {
        DispatchQueue.main.async {
            self.categories = categories
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

    // MARK: - TableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: CategoryTableViewController.self, for: indexPath)

        var config = cell.defaultContentConfiguration()
        config.text = categories[indexPath.row].capitalized
        cell.contentConfiguration = config

        return cell
    }

    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuTableViewController = storyboard?.instantiateViewController(
            withIdentifier: "menuVC"
        ) as? MenuTableViewController
        else { return }

        delegate = menuTableViewController
        delegate?.categoryDidSelect(category: categories[indexPath.row])
        navigationController?.pushViewController(menuTableViewController, animated: true)
    }
}
