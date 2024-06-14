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
   
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 30) / 2, height: 250)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "MainCollectionViewCell")
        view.backgroundColor = .blue
        return view
    }()

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

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MainCollectionViewCell")
        view.addSubview(collectionView)
        view.backgroundColor = .blue
    }

    func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(50)
        }
        accuracyButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(50)
            make.height.equalTo(38)
        }
        dateButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.equalTo(accuracyButton.snp.trailing).offset(7)
            make.width.equalTo(50)
            make.height.equalTo(38)
        }
        upPriceButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.equalTo(dateButton.snp.trailing).offset(7)
            make.width.equalTo(80)
            make.height.equalTo(38)
        }
        downPriceButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.equalTo(upPriceButton.snp.trailing).offset(7)
            make.width.equalTo(80)
            make.height.equalTo(38)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(accuracyButton.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
       
    }
}


