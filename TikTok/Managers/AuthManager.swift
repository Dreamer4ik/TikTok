//
//  AuthManager.swift
//  TikTok
//
//  Created by Ivan Potapenko on 20.04.2022.
//

import Foundation
import FirebaseAuth

/// Manager responsible for signing in, up and out
final class AuthManager {
    /// Shared singletion instance
    public static let shared = AuthManager()
    /// Private constructor
    private init() {}

    /// Represents method to sign in
    enum SignInMethod {
        case email
        case facebook
        case google
    }

    /// Represents errors that can occur in auth flows
    enum AuthError: Error {
        case signInFailed
    }

    /// Represents if user is signed in
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }

    /// Attempt to sign in
    /// - Parameters:
    ///   - email: User email
    ///   - password: User password
    ///   - completion: Async callback result closure
    public func signIn(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(AuthError.signInFailed))
                }
                return
            }

            DatabaseManager.shared.getUsername(for: email) { username in
                if let username = username {
                    UserDefaults.standard.setValue(username, forKey: "username")
                    print("Got username: \(username)")
                }
            }

            // Successful sign in
            completion(.success(email))
        }
    }

    /// Attempt to sign up
    /// - Parameters:
    ///   - username: Desired username
    ///   - email: User email
    ///   - password: User password
    ///   - completion: Async callback result closure
    public func signUp(
        username: String,
        email: String,
        password: String,
        completion: @escaping (Bool) -> Void
    ) {
        // Make sure entered username is available
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }

            UserDefaults.standard.setValue(username, forKey: "username")

            DatabaseManager.shared.insertUser(with: email, username: username, completion: completion)
        }
    }

    /// Attempt to sign out
    /// - Parameter completion: Async callback of sing out result
    public func signOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch {
            print(error)
            completion(false)
        }
    }

}
