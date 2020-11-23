//
//  Utilities.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 23/11/2020.
//

import UIKit

class Utilities {
    
    static func createCustomInputContainerView(withImage image: UIImage, andTextField textField: UITextField) -> UIView {
        
        let view = UIView()
        let iv = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        iv.image = image
        view.addSubview(iv)
        iv.anchor(left: view.leftAnchor,
                  bottom: view.bottomAnchor,
                  paddingLeft: 8.0,
                  paddingBottom: 8.0)
        iv.setDimensions(width: 24.0, height: 24.0)
        
        view.addSubview(textField)
        textField.anchor(left: iv.rightAnchor,
                         bottom: view.bottomAnchor,
                         right: view.rightAnchor,
                         paddingLeft: 8.0,
                         paddingBottom: 8.0)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        
        view.addSubview(dividerView)
        dividerView.anchor(left:view.leftAnchor,
                           bottom: view.bottomAnchor,
                           right: view.rightAnchor,
                           paddingLeft: 8.0,
                           paddingRight: 8.0,
                           height: 0.75)
        
        return view
    }
    
    static func createCustomTextField(withPlaceholder placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.textColor = .white
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                      attributes: [NSAttributedString.Key.foregroundColor:
                                                                   UIColor.white])
        return tf
    }
    
    static func createCustomButton(withFirstPart first: String,
                                   secondPart second: String,
                                   target: Any?,
                                   andSelector selector: Selector) -> UIButton {
        
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: first,
                                                        attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                                                                     NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string: second,
                                                  attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
                                                               NSAttributedString.Key.foregroundColor: UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(target, action: selector, for: .touchUpInside)

        return button
    }
}
