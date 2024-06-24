//
//  SearchResult+Alert.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/24/24.
//

import UIKit

extension SearchResultsViewController {
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

