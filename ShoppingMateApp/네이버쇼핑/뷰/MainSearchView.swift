//
//  MainSearchView.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/14/24.
//

import UIKit
import SnapKit

class MainSearchView: BaseView, UISearchBarDelegate {

    lazy var searchBar: UISearchBar = {
        return self.createSearchBar(delegate: self)
    }()

    let accuracyButton: UIButton = {
        return UIView().createButton(title: "정확도가짜야")
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
        view.backgroundColor = .white
        return view
    }()
  
   
    override func configureView() {
        self.backgroundColor = .white
       addSubview(searchBar)
//        addSubview(accuracyButton)
//        addSubview(dateButton)
//        addSubview(upPriceButton)
//        addSubview(downPriceButton)
        addSubview(collectionView)
    }


    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
//        accuracyButton.snp.makeConstraints { make in
//            make.top.equalTo(searchBar.snp.bottom).offset(20)
//            make.leading.equalToSuperview().offset(10)
//            make.width.equalTo(55)
//            make.height.equalTo(38)
//        }
//        dateButton.snp.makeConstraints { make in
//            make.top.equalTo(searchBar.snp.bottom).offset(20)
//            make.leading.equalTo(accuracyButton.snp.trailing).offset(7)
//            make.width.equalTo(55)
//            make.height.equalTo(38)
//        }
//        upPriceButton.snp.makeConstraints { make in
//            make.top.equalTo(searchBar.snp.bottom).offset(20)
//            make.leading.equalTo(dateButton.snp.trailing).offset(7)
//            make.width.equalTo(80)
//            make.height.equalTo(38)
//        }
//        downPriceButton.snp.makeConstraints { make in
//            make.top.equalTo(searchBar.snp.bottom).offset(20)
//            make.leading.equalTo(upPriceButton.snp.trailing).offset(7)
//            make.width.equalTo(80)
//            make.height.equalTo(38)
//        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            // make.top.equalTo(accuracyButton.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
       
    }

}


