//
//  MainSearchView.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/14/24.
//

import UIKit
import SnapKit

class MainSearchView: UIViewController, UISearchBarDelegate {

    let searchBar = UISearchBar()
    let accuracyButton = UIButton(type: .system)
    let dateButton = UIButton(type: .system)
    let upPriceButton = UIButton(type: .system)
    let downPriceButton = UIButton(type: .system)
    let collectionView: UICollectionView

    init() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setConstraints()
    }

    private func setupUI() {
        view.backgroundColor = .white

        searchBar.delegate = self
        searchBar.placeholder = "Search"
        view.addSubview(searchBar)
        
        accuracyButton.setTitle("정확도", for: .normal)
        view.addSubview(accuracyButton)
        
        dateButton.setTitle("날짜", for: .normal)
        view.addSubview(dateButton)
        
        upPriceButton.setTitle("가격↑", for: .normal)
        view.addSubview(upPriceButton)
        
        downPriceButton.setTitle("가격↓", for: .normal)
        view.addSubview(downPriceButton)
        

        view.addSubview(collectionView)
    }

    func setConstraints() {

    }


    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
     
    }
}

extension MainSearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .lightGray
        return cell
    }
}
