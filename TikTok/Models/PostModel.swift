//
//  PostModel.swift
//  TikTok
//
//  Created by Ivan Potapenko on 21.04.2022.
//

import Foundation

struct PostModel {
    let identifier: String
    let user: User
    var fileName: String = ""
    var caption: String = ""
    
    var isLikedByCurrentUser = false
    
    static func mockModels() -> [PostModel] {
        var posts = [PostModel]()
        for _ in 0...100 {
            let post = PostModel(
                identifier: UUID().uuidString,
                user: User(
                    username: "potus",
                    profilePictureURL: nil,
                    identifier: UUID().uuidString
                )
            )
            posts.append(post)
        }
        return posts
    }
    
    var videoChildPath: String {
        return ("videos/\(user.username.lowercased())/\(fileName)")
    }
}
