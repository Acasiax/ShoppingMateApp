//
//  Resuse.swift
//  ShoppingMateApp
//
//  Created by 이윤지 on 6/14/24.
//

import UIKit

class ReuseBaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setConstraints()
    }
    
    func configureView() { }
    func setConstraints() { }
}

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() { }
    func setConstraints() { }
}

class BaseCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() { }
    func setConstraints() { }
}
