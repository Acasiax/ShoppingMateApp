//
//  ProfileSettingViewController.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/15/24.
//

import UIKit

class ProfileSettingViewController: UIViewController {

    private var navigationTitle: String
    private var showSaveButton: Bool
    
    init(navigationTitle: String, showSaveButton: Bool) {
           self.navigationTitle = navigationTitle
           self.showSaveButton = showSaveButton
           super.init(nibName: nil, bundle: nil)
       }
    
    required init?(coder: NSCoder) {
        self.navigationTitle = ""
        self.showSaveButton = false
        super.init(coder: coder)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
       
    }
    
    private func setupNavigationBar() {
        navigationItem.title = navigationTitle
             navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 18)]
             
             if showSaveButton {
                 let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
                 saveButton.setTitleTextAttributes([.foregroundColor: UIColor.black, .font: UIFont.boldSystemFont(ofSize: 16)], for: .normal)
                 navigationItem.rightBarButtonItem = saveButton
             }
        
    }
    @objc private func saveButtonTapped() {
            // 저장 버튼 기능
        }
}
