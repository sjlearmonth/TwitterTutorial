//
//  EditProfileFooter.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 08/02/2021.
//

import UIKit

protocol EditProfileFooterDelegate: class {
    func handleLogout()
}

class EditProfileFooter: UIView {
    
    // MARK: - Properties
    
    private lazy var logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        button.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
        button.backgroundColor = .red
        button.layer.cornerRadius = 5
        return button
    }()
    
    weak var delegate: EditProfileFooterDelegate?
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logOutButton)
        logOutButton.setHeight(to: 60)
        logOutButton.centerY(inView: self)
        logOutButton.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 16.0, paddingRight: 16.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleLogOut() {
        delegate?.handleLogout()
    }
}
