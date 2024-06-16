//
//  SearchResultsViewController.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/16/24.
//
import UIKit
import SnapKit

class SearchResultsViewController: ReuseBaseViewController {
    private let query: String
    private var shopManager = NetworkManager.shared
    private var productItems: [Item] = []
    private var isDataEnd = false
    private var isDataLoading = false
    private var pageStartNumber = 1

    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색어를 입력하세요"
        return searchBar
    }()
    
    let accuracyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("정확도", for: .normal)
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let dateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("날짜순", for: .normal)
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let upPriceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("가격높은순", for: .normal)
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let downPriceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("가격낮은순", for: .normal)
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 30) / 2, height: 250)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "MainCollectionViewCell")
        view.backgroundColor = .white
        return view
    }()
    
    init(query: String) {
        self.query = query
        super.init(nibName: nil, bundle: nil)
        searchBar.text = query
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData(query: query)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(accuracyButton)
        view.addSubview(dateButton)
        view.addSubview(upPriceButton)
        view.addSubview(downPriceButton)
        view.addSubview(collectionView)
        
        searchBar.delegate = self
        
        accuracyButton.addTarget(self, action: #selector(changeSort(_:)), for: .touchUpInside)
        dateButton.addTarget(self, action: #selector(changeSort(_:)), for: .touchUpInside)
        upPriceButton.addTarget(self, action: #selector(changeSort(_:)), for: .touchUpInside)
        downPriceButton.addTarget(self, action: #selector(changeSort(_:)), for: .touchUpInside)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }
        
        accuracyButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(55)
            make.height.equalTo(38)
        }
        dateButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.equalTo(accuracyButton.snp.trailing).offset(7)
            make.width.equalTo(55)
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
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
    }
    
    private func loadData(query: String, sort: String = "sim", display: Int = 30, start: Int = 1) {
        isDataLoading = true
        shopManager.shoppingRequest(query: query, display: display, start: start, sort: sort) { items in
            self.isDataLoading = false
            guard let items = items else { return }
            self.productItems.append(contentsOf: items)
            self.collectionView.reloadData()
        }
    }
    
    @objc private func changeSort(_ sender: UIButton) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        var sortValue: String
        switch sender {
        case accuracyButton:
            sortValue = "sim"
        case dateButton:
            sortValue = "date"
        case upPriceButton:
            sortValue = "dsc"
        case downPriceButton:
            sortValue = "asc"
        default:
            return
        }
        productItems.removeAll()
        loadData(query: query, sort: sortValue)
    }
}

extension SearchResultsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        productItems.removeAll()
        loadData(query: text)
    }
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        let item = productItems[indexPath.row]
        cell.configure(with: item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let query = searchBar.text, !isDataLoading else { return }
        if productItems.count - 1 == indexPaths.last?.row {
            pageStartNumber += 1
            loadData(query: query, start: pageStartNumber)
            shopManager.shoppingRequest(query: query, start: pageStartNumber) { items in
                guard let items = items else { return }
                self.productItems.append(contentsOf: items)
                //self.homeView.collectionView.reloadData()
               
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = productItems[indexPath.row]
        let webVC = WebViewController()
        webVC.productID = item.productID
        webVC.item = item
        webVC.webViewTitle = item.title.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
        navigationController?.pushViewController(webVC, animated: true)
    }
}


