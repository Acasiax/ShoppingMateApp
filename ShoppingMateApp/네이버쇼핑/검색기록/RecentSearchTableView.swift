//
//  RecentSearchTableView.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/16/24.

import UIKit
import SnapKit

class RecentSearchTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    var recentSearches: [String] = [] {
        didSet {
            print("RecentSearchTableView recentSearches didSet: \(recentSearches)")
            reloadData()
            isHidden = recentSearches.isEmpty // 검색어가 없으면 테이블 뷰 숨김
        }
    }
    
    var onSelectSearch: ((String) -> Void)?
    var onDeleteSearch: ((String) -> Void)?
    var recentSearchRepository = RecentSearchRepository()
        
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        self.delegate = self
        self.dataSource = self
        self.register(RecentSearchCell.self, forCellReuseIdentifier: RecentSearchCell.identifier)
        self.backgroundColor = .white
       // self.tableHeaderView = createTableHeaderView()
        self.separatorStyle = .none
    }
    
//    private func createTableHeaderView() -> UIView {
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 50))
//        headerView.backgroundColor = .white
//        
//        let titleLabel = UILabel()
//        titleLabel.text = "최근 검색"
//        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        let deleteAllButton = UIButton(type: .system)
//        deleteAllButton.setTitle("전체 삭제", for: .normal)
//        deleteAllButton.setTitleColor(.orange, for: .normal)
//        deleteAllButton.addTarget(self, action: #selector(deleteAllButtonTapped), for: .touchUpInside)
//        deleteAllButton.translatesAutoresizingMaskIntoConstraints = false
//        
//        headerView.addSubview(titleLabel)
//        headerView.addSubview(deleteAllButton)
//        
//        NSLayoutConstraint.activate([
//            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
//            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
//            
//            deleteAllButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
//            deleteAllButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
//        ])
//        
//        return headerView
//    }
    
    @objc private func deleteAllButtonTapped() {
        recentSearchRepository.deleteAll()
        recentSearches.removeAll()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of rows in section \(section): \(recentSearches.count)")
        return recentSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchCell.identifier, for: indexPath) as? RecentSearchCell else {
            return UITableViewCell()
        }
        cell.configure(with: recentSearches[indexPath.row])
        cell.onDelete = { [weak self] in
            guard let self = self else { return }
            let deletedSearch = self.recentSearches[indexPath.row]
            self.recentSearches.remove(at: indexPath.row)
            self.onDeleteSearch?(deletedSearch) // 삭제 핸들러 호출
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSearch = recentSearches[indexPath.row]
        onSelectSearch?(selectedSearch) // 검색어 선택 시 핸들러 호출
    }
}

class RecentSearchCell: UITableViewCell {
    static let identifier = "RecentSearchCell"
    
    let searchLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    let clockIcon: UIImageView = {
        let imageView = UIImageView()
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        let clockImage = UIImage(systemName: "clock", withConfiguration: configuration)
        
        imageView.image = clockImage
        imageView.tintColor = .black
        
        return imageView
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("X", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    var onDelete: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(clockIcon)
        contentView.addSubview(searchLabel)
        contentView.addSubview(deleteButton)
        
        clockIcon.translatesAutoresizingMaskIntoConstraints = false
        searchLabel.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            clockIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            clockIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            clockIcon.widthAnchor.constraint(equalToConstant: 20),
            clockIcon.heightAnchor.constraint(equalToConstant: 20),
            
            searchLabel.leadingAnchor.constraint(equalTo: clockIcon.trailingAnchor, constant: 15),
            searchLabel.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -15),
            searchLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            searchLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 30),
            deleteButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    func configure(with text: String) {
        searchLabel.text = text
    }
    
    @objc private func deleteButtonTapped() {
        onDelete?()
    }
}


import Foundation
import RealmSwift

class RecentSearch: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var searchTerm: String
    @Persisted var date: Date
    
    convenience init(searchTerm: String) {
        self.init()
        self.searchTerm = searchTerm
        self.date = Date()
    }
}

class RecentSearchRepository {
    private let realm = try! Realm()
    
    func fetchAll() -> [String] {
        let searches = realm.objects(RecentSearch.self).sorted(byKeyPath: "date", ascending: false)
        return Array(searches.map { $0.searchTerm })
    }
    
    func saveSearch(_ searchTerm: String) {
        let recentSearch = RecentSearch(searchTerm: searchTerm)
        try! realm.write {
            realm.add(recentSearch, update: .all)
        }
    }
    
    func deleteSearch(_ searchTerm: String) {
        if let objectToDelete = realm.objects(RecentSearch.self).filter("searchTerm == %@", searchTerm).first {
            try! realm.write {
                realm.delete(objectToDelete)
            }
        }
    }
    
    func deleteAll() {
        try! realm.write {
            realm.delete(realm.objects(RecentSearch.self))
        }
    }
}
