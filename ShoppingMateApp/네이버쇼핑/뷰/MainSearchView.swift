//
//  MainSearchView.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/14/24.
//

import UIKit
import SnapKit

class MainSearchView: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    lazy var searchBar: UISearchBar = {
        return UIView().createSearchBar(delegate: self)
    }()

    let accuracyButton: UIButton = {
        return UIView().createButton(title: "정확도")
    }()

    let dateButton: UIButton = {
        return UIView().createButton(title: "날짜순")
    }()

    let upPriceButton: UIButton = {
        return UIView().createButton(title: "가격높은순", width: 80)
    }()

    let downPriceButton: UIButton = {
        return UIView().createButton(title: "가격낮은순", width: 80)
    }()

   
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 30) / 2, height: 250)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "MainCollectionViewCell")
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .blue
        return view
    }()
    
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    override func viewDidLoad() {
            super.viewDidLoad()
            configureView()
            setConstraints()
        }
    
    override func configureView() {
        self.backgroundColor = .white
        addSubview(searchBar)
        addSubview(accuracyButton)
        addSubview(dateButton)
        addSubview(upPriceButton)
        addSubview(downPriceButton)
        addSubview(collectionView)
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


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath)
        cell.backgroundColor = .lightGray
        return cell
    }
}


