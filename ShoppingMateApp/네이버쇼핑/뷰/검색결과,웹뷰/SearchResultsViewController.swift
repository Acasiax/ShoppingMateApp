//
//  SearchResultsViewController.swift
//  ShoppingMateApp

//  Created by 이윤지 on 6/16/24.
//
import UIKit
import SnapKit

//검색 결과 화면
class SearchResultsViewController: UIViewController {
    
    var totalResults: Int? //검색 총결과 수
    
    private let query: String
    private var shopManager = NetworkManager.shared
    private var productItems: [Item] = []
    private var isDataEnd = false
    private var isDataLoading = false
    private var pageStartNumber = 1
    
    private var selectedButton: UIButton?
    
    let resultsCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.customBlack
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.isHidden = true
        return label
    }()
    
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색어를 입력하세요"
        return searchBar
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
    
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 30) / 2, height: 250)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "MainCollectionViewCell")
        view.backgroundColor = .customWhite
        return view
    }()
    
    //검색한 결과가 네비의 타이틀로
    init(query: String) {
        self.query = query
        super.init(nibName: nil, bundle: nil)
        searchBar.text = query
        self.title = query
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData(query: query)
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
        navigationController?.navigationBar.tintColor = .customBlack
        
    }
    
    private func setupUI() {
        view.backgroundColor = .customWhite
        //  view.addSubview(searchBar)
        view.addSubview(resultsCountLabel)
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
        
        resultsCountLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            // make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        
        accuracyButton.snp.makeConstraints { make in
            make.top.equalTo(resultsCountLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(55)
            make.height.equalTo(38)
        }
        dateButton.snp.makeConstraints { make in
            make.top.equalTo(resultsCountLabel.snp.bottom).offset(10)
            make.leading.equalTo(accuracyButton.snp.trailing).offset(7)
            make.width.equalTo(55)
            make.height.equalTo(38)
        }
        upPriceButton.snp.makeConstraints { make in
            make.top.equalTo(resultsCountLabel.snp.bottom).offset(10)
            make.leading.equalTo(dateButton.snp.trailing).offset(7)
            make.width.equalTo(80)
            make.height.equalTo(38)
        }
        downPriceButton.snp.makeConstraints { make in
            make.top.equalTo(resultsCountLabel.snp.bottom).offset(10)
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
        shopManager.shoppingRequest(query: query, display: display, start: start, sort: sort) { [weak self] result in
            guard let self = self else { return }
            self.isDataLoading = false
            
            switch result {
            case .success(let (total, items)):
                self.totalResults = total // 총 검색 결과 수 업데이트
                self.productItems.append(contentsOf: items)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.updateResultsCountLabel() // 결과 수 라벨 업데이트 호출
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // 🔄 결과 수 라벨 업데이트 메서드 추가
    private func updateResultsCountLabel() {
        if let totalResults = totalResults {
            let fomatterTotalResults = totalResults.formatted()
            resultsCountLabel.text = "\(fomatterTotalResults)개의 검색 결과"
            resultsCountLabel.textColor = .customOrange
            resultsCountLabel.font = .systemFont(ofSize: 15, weight: .bold)
            resultsCountLabel.isHidden = false
        } else {
            resultsCountLabel.isHidden = true
        }
    }
    
    
    
    
    @objc private func changeSort(_ sender: UIButton) {
        
        // 이전에 선택된 버튼이 있으면 색상 복원
        if let previousButton = selectedButton {
            previousButton.backgroundColor = .customWhite
            previousButton.setTitleColor(.customBlack, for: .normal)
        }
        
        // 새로운 버튼을 선택하고 색상 변경
        sender.backgroundColor = .customGray4C4C
        sender.setTitleColor(.customWhite, for: .normal)
        selectedButton = sender
        
        
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
        guard let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let newSearchResultsVC = SearchResultsViewController(query: query)
        newSearchResultsVC.title = query
        navigationController?.pushViewController(newSearchResultsVC, animated: true)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: true)
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
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = productItems[indexPath.row]
        let webVC = WebViewController()
        webVC.productID = item.productID
        webVC.item = item
        webVC.webViewTitle = item.title.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
        navigationController?.pushViewController(webVC, animated: true)
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
       
    }
}


