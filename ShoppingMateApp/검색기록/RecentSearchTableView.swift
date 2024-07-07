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
        self.register(RecentSearchCell.self, forCellReuseIdentifier: RecentSearchCell.reuseIdentifier)
        self.backgroundColor = .customWhite
        self.separatorStyle = .none
    }
    
    @objc private func deleteAllButtonTapped() {
        recentSearchRepository.deleteAll()
        recentSearches.removeAll()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchCell.reuseIdentifier, for: indexPath) as? RecentSearchCell else {
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

class RecentSearchCell: UITableViewCell, Reusable {
   // static let identifier = "RecentSearchCell"
    
    let searchLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customBlack
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    let clockIcon: UIImageView = {
        let imageView = UIImageView()
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        let clockImage = UIImage(systemName: "clock", withConfiguration: configuration)
        
        imageView.image = clockImage
        imageView.tintColor = .customBlack
        
        return imageView
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        if let xmarkImage = UIImage(systemName: "xmark")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 13, weight: .regular)) {
            button.setImage(xmarkImage, for: .normal)
        }
        button.tintColor = .customBlack
        
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
        
        clockIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        searchLabel.snp.makeConstraints { make in
            make.leading.equalTo(clockIcon.snp.trailing).offset(15)
            make.trailing.equalTo(deleteButton.snp.leading).offset(-15)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    func configure(with text: String) {
        searchLabel.text = text
    }
    
    @objc private func deleteButtonTapped() {
        onDelete?()
    }
}
