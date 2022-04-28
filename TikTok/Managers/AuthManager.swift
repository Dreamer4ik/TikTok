//
//  AuthManager.swift
//  TikTok
//
//  Created by Ivan Potapenko on 20.04.2022.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    
    public static let shared = AuthManager()
    
    private init() {}
    
    enum SignInMethod {
        case email
        case facebook
        case google
    }
    
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    public func signIn(with method: SignInMethod) {
        
    }
    
    public func signOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        }
        catch {
            print(error)
            completion(false)
        }
    }
    
}
