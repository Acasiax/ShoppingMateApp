//
//  HomeViewController.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/14/24.
//
import UIKit
import SnapKit
import RealmSwift

class HomeViewController: ReuseBaseViewController {
    var totalResults: Int? //검색 총결과 수
    var isSearching = false
    
    let homeView = MainSearchView()
    var shopManager = NetworkManager.shared
    var productItems: [Item] = []
    var favoriteItems: Results<LikeTable>!
    let realmDatabase = try! Realm()
    let likeTableRepository = LikeTableRepository()
    var isDataEnd = false
    var pageStartNumber = 1
    var isDataLoading = false
    var recentSearchRepository = RecentSearchRepository()
    var recentSearches: [String] = [] {
        didSet {
            print("HomeViewController recentSearches didSet🌟: \(recentSearches)")
            recentSearchTableView.recentSearches = recentSearches
            updateRecentSearchVisibility()
        }
    }
    
    
    let headerView: UIView = {
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "최근 검색"
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
        let deleteAllButton = UIButton(type: .system)
        deleteAllButton.setTitle("전체 삭제", for: .normal)
        deleteAllButton.setTitleColor(.orange, for: .normal)
        deleteAllButton.addTarget(self, action: #selector(deleteAllButtonTapped), for: .touchUpInside)
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(deleteAllButton)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(headerView).offset(15)
            make.centerY.equalTo(headerView)
        }
        
        deleteAllButton.snp.makeConstraints { make in
            make.trailing.equalTo(headerView).offset(-15)
            make.centerY.equalTo(headerView)
        }
        
        return headerView
    }()

    let containerView: UIView = {
        let view = UIView()
        return view
    }()

    
    

    let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "empty")
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        return imageView
    }()
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색어가 없어요"
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.isHidden = true
        return label
    }()
    
    let recentSearchTableView: RecentSearchTableView = {
        let tableView = RecentSearchTableView()
        tableView.isHidden = true
        return tableView
    }()
    
    override func loadView() {
        self.view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        
        setupUI()
        setupEmptyImageView()
        setupRecentSearchTableView()
        loadRecentSearches()
        updateRecentSearchVisibility()
        updateEmptyImageViewVisibility()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isSearching = false
        loadRecentSearches()
        updateRecentSearchVisibility()
        updateEmptyImageViewVisibility()
        homeView.collectionView.reloadData()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    private func setupUI() {
        setupNavigationUI()
        homeView.searchBar.delegate = self
        homeView.collectionView.delegate = self
        homeView.collectionView.dataSource = self
        homeView.collectionView.prefetchDataSource = self
        
        homeView.accuracyButton.addTarget(self, action: #selector(toggleButtonColor), for: .touchUpInside)
        homeView.dateButton.addTarget(self, action: #selector(toggleButtonColor), for: .touchUpInside)
        homeView.upPriceButton.addTarget(self, action: #selector(toggleButtonColor), for: .touchUpInside)
        homeView.downPriceButton.addTarget(self, action: #selector(toggleButtonColor), for: .touchUpInside)
        
        homeView.accuracyButton.addTarget(self, action: #selector(changeSort), for: .touchUpInside)
        homeView.dateButton.addTarget(self, action: #selector(changeSort), for: .touchUpInside)
        homeView.upPriceButton.addTarget(self, action: #selector(changeSort), for: .touchUpInside)
        homeView.downPriceButton.addTarget(self, action: #selector(changeSort), for: .touchUpInside)

        if let cancelButton = homeView.searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        }
    }

    private func setupNavigationUI() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .lightGray
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.shadowColor = .clear

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        //navigationItem.title = "이윤지's MEANING OUT"
        let nickname = getNickname()
            navigationItem.title = "\(nickname)'s MEANING OUT"
    }

    private func setupEmptyImageView() {
        view.addSubview(emptyImageView)
        view.addSubview(emptyLabel)
        
        emptyImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(230)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupRecentSearchTableView() {
        view.addSubview(containerView)
        containerView.addSubview(headerView)
        containerView.addSubview(recentSearchTableView)
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(homeView.searchBar.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalTo(containerView)
            make.height.equalTo(50)
        }
        
        recentSearchTableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.bottom.equalTo(containerView)
        }
        
        recentSearchTableView.onSelectSearch = { [weak self] selectedSearch in
            self?.navigateToSearchResults(query: selectedSearch)
        }
        
        recentSearchTableView.onDeleteSearch = { [weak self] deletedSearch in
            self?.deleteSearch(deletedSearch)
        }
    }

    
    func navigateToSearchResults(query: String) {
        let searchResultsVC = SearchResultsViewController(query: query)
        
        // 네비게이션 백버튼 설정
           let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
           navigationItem.backBarButtonItem = backBarButtonItem
           navigationController?.navigationBar.tintColor = UIColor.black
        
        navigationController?.pushViewController(searchResultsVC, animated: true)
    }
    
    private func deleteSearch(_ searchTerm: String) {
        recentSearchRepository.deleteSearch(searchTerm)
        loadRecentSearches()
    }
    
    @objc private func deleteAllButtonTapped() {
        recentSearchRepository.deleteAll()
        recentSearches.removeAll()
    }
    
    @objc private func cancelButtonTapped() {
        productItems.removeAll()
        homeView.collectionView.reloadData()
        updateEmptyImageViewVisibility()
        updateRecentSearchVisibility()
        navigationController?.popViewController(animated: true)
    }

    @objc private func toggleButtonColor(sender: UIButton) {
        let allButtons = [homeView.accuracyButton, homeView.dateButton, homeView.upPriceButton, homeView.downPriceButton]
        for button in allButtons {
            button.isSelected = false
            button.backgroundColor = .gray
            button.setTitleColor(.red, for: .normal)
        }
        sender.isSelected.toggle()
        if sender.isSelected {
            sender.backgroundColor = .white
            sender.setTitleColor(.brown, for: .normal)
        }
    }

    @objc private func changeSort(sender: UIButton) {
        guard !isDataLoading else { return }
        guard let query = homeView.searchBar.text, !query.isEmpty else { return }

        var sortValue: String
        switch sender {
        case homeView.accuracyButton:
            sortValue = "sim"
        case homeView.dateButton:
            sortValue = "date"
        case homeView.upPriceButton:
            sortValue = "dsc"
        case homeView.downPriceButton:
            sortValue = "asc"
        default:
            return
        }

        productItems.removeAll()
        isDataLoading = true
        shopManager.shoppingRequest(query: query, sort: sortValue) { total, items in
            self.isDataLoading = false
            guard let items = items else { return }
            self.totalResults = total // 총 결과 수 업데이트
            self.productItems.append(contentsOf: items)
            self.homeView.collectionView.reloadData()
            self.updateEmptyImageViewVisibility()
        }
    }
    
    func loadData(query: String, sort: String = "sim", display: Int = 30, start: Int = 1) {
        shopManager.shoppingRequest(query: query, display: display, start: start, sort: sort) { total, items in
            self.isDataLoading = false
            guard let items = items else { return }
            self.totalResults = total
            self.productItems.append(contentsOf: items)
            self.homeView.collectionView.reloadData()
            self.updateEmptyImageViewVisibility()
        }
    }
    
    func updateEmptyImageViewVisibility() {
        let isEmpty = productItems.isEmpty
        emptyImageView.isHidden = !isEmpty
        emptyLabel.isHidden = !isEmpty
        recentSearchTableView.isHidden = recentSearches.isEmpty
        recentSearchTableView.reloadData()
    }
    
    func updateRecentSearchVisibility() {
        print("Updating recent search visibility: \(recentSearches)")
        recentSearchTableView.isHidden = recentSearches.isEmpty
        recentSearchTableView.reloadData()
    }
    
    private func loadRecentSearches() {
        recentSearches = recentSearchRepository.fetchAll()
        print("Loaded recent searches: \(recentSearches)")
    }
    
    private func getNickname() -> String {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "UserNickname") ?? "닉네임 없음"
    }

    
    
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard !isSearching else { return }
        isSearching = true
        guard let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        if !recentSearches.contains(query) {
            recentSearches.append(query)
            recentSearchRepository.saveSearch(query)
        }
        
        navigateToSearchResults(query: query)
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
