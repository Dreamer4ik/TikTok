//
//  AuthField.swift
//  TikTok
//
//  Created by Ivan Potapenko on 29.04.2022.
//

import UIKit

class AuthField: UITextField {
    
    enum FieldType {
        case username
        case email
        case password
        
        var title: String {
            switch self {
            case .email:
                return "Email Adress"
            case .password:
                return "Password"
            case .username:
                return "Username"
            }
        }
    }
    
    private let type: FieldType
    
    init(type: FieldType) {
        self.type = type
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        autocapitalizationType = .none
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 8
        layer.masksToBounds = true
        placeholder = type.title
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: height))
        leftViewMode = .always
        returnKeyType = .done
        autocorrectionType = .no
        
        if type == .password {
            textContentType = .oneTimeCode
            isSecureTextEntry = true
        }
        else if type == .email {
            keyboardType = .emailAddress
            textContentType = .emailAddress
        }
    }
}
