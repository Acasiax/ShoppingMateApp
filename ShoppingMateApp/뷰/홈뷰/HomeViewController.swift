//
//  HomeViewController.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/14/24.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    var totalResults: Int?
    var isSearching = false
    var shopManager = NetworkManager.shared
    var productItems: [Item] = []
    var isDataEnd = false
    var pageStartNumber = 1
    var isDataLoading = false
    var recentSearchRepository = RecentSearchRepository()
    var recentSearches: [String] = [] {
        didSet {
            recentSearchTableView.recentSearches = recentSearches
            updateVisibility()
        }
    }
    
    let searchBar: UISearchBar = {
            let searchBar = UISearchBar()
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            return searchBar
        }()
    
    let headerView: UIView = {
        let headerView = UIView()
        headerView.backgroundColor = .customWhite
        
        let titleLabel = UILabel()
        titleLabel.text = "최근 검색"
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
        let deleteAllButton = UIButton(type: .system)
        deleteAllButton.setTitle("전체 삭제", for: .normal)
        deleteAllButton.setTitleColor(.customOrange, for: .normal)
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
        label.textColor = .customBlack
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        
        setupUI()
        loadRecentSearches()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isSearching = false
        loadRecentSearches()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
     
    private func setupUI() {
        setupNavigationUI()
        setupSearchBar()
        setupEmptyImageView()
        setupRecentSearchTableView()
        
        searchBar.delegate = self
        
    }

    private func setupSearchBar() {
           view.addSubview(searchBar)
           searchBar.snp.makeConstraints { make in
               make.top.equalTo(view.safeAreaLayoutGuide).offset(6)
               make.horizontalEdges.equalToSuperview()
               make.height.equalTo(50)
           }
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

    func navigateToSearchResults(query: String) {
        let searchResultsVC = SearchResultsViewController(query: query)
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
        navigationController?.navigationBar.tintColor = .customBlack
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
        updateVisibility()
        navigationController?.popViewController(animated: true)
    }

    func updateVisibility() {
        let isEmpty = productItems.isEmpty
        emptyImageView.isHidden = !isEmpty
        emptyLabel.isHidden = !isEmpty
        recentSearchTableView.isHidden = recentSearches.isEmpty
        recentSearchTableView.reloadData()
    }
    
    
    private func loadRecentSearches() {
        recentSearches = FileManagerHelper.shared.loadRecentSearches().map { $0.searchTerm }
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
        navigationController?.navigationBar.tintColor = .customBlack
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

extension HomeViewController {
     
    private func setupRecentSearchTableView() {
        view.addSubview(containerView)
        containerView.addSubview(headerView)
        containerView.addSubview(recentSearchTableView)
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
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
    
    private func setupNavigationUI() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.customWhite
        appearance.titleTextAttributes = [.foregroundColor: UIColor.customBlack]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.customBlack]
        appearance.shadowColor = .clear

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .customWhite
        navigationController?.navigationBar.isTranslucent = false
        let nickname = getNickname()
        navigationItem.title = "\(nickname)'s MEANING OUT"
    }
}
