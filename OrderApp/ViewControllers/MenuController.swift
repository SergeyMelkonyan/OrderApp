//
//  MenuController.swift
//  OrderApp
//
//  Created by Sergey Melkonyan on 04.11.22.
//

import Foundation
import UIKit

class MenuController {

    let baseURL = URL(string: "http://localhost:8080/")

    var order = Order() {
        didSet {
            NotificationCenter.default.post(name: MenuController.orderUpdatedNotification, object: nil)
        }
    }

    static let shared = MenuController()
    private init() { }

    static let orderUpdatedNotification = Notification.Name("MenuController.orderUpdated")

    func fetchCategories(completion: @escaping (Result<[String], Error>) -> Void) {
        let categoriesURL = (baseURL?.appending(path: "categories"))!
        DispatchQueue.main.async {
            URLSession.shared.dataTask(with: categoriesURL) { data, response, error in
                if let data {
                    do {
                        let categoriesResponse = try JSONDecoder().decode(CategoriesResponse.self, from: data)
                        completion(.success(categoriesResponse.categories))
                    } catch {
                        completion(.failure(error))
                    }
                } else if let error {
                    completion(.failure(error))
                }
            }.resume()
        }
    }

    func fetchMenuItems(forCategory categoryName: String, completion: @escaping (Result<[MenuItem], Error>) -> Void) {
        let baseMenuURL = baseURL?.appending(path: "menu")
        var components = URLComponents(url: baseMenuURL!, resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        let menuURL = components?.url
        DispatchQueue.main.async {
            URLSession.shared.dataTask(with: menuURL!) { data, response, error in
                if let data {
                    do {
                        let menuResponse = try JSONDecoder().decode(MenuResponse.self, from: data)
                        completion(.success(menuResponse.items))
                    } catch {
                        completion(.failure(error))
                    }
                } else if let error {
                    completion(.failure(error))
                }
            }.resume()
        }
    }

    typealias MinutesToPrepare = Int

    func submitOrder(forMenuIDs menuIDs: [MinutesToPrepare], completion: @escaping (Result<Int, Error>) -> Void) {
        let orderURL = baseURL?.appending(path: "order")
        var request = URLRequest(url: orderURL!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let data = ["menuIds": menuIDs]
        let jsonData = try? JSONEncoder().encode(data)
        request.httpBody = jsonData

        DispatchQueue.main.async {
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data {
                    do {
                        let orderResponse = try JSONDecoder().decode(OrderResponse.self, from: data)
                        completion(.success(orderResponse.prepTime))
                    } catch {
                        completion(.failure(error))
                    }
                } else if let error {
                    completion(.failure(error))
                }

            }.resume()
        }
    }

    func fetchImage(url: URL, completion: @escaping (UIImage?)
       -> Void) {
        let task = URLSession.shared.dataTask(with: url)
           { (data, response, error) in
            if let data = data,
                let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}
