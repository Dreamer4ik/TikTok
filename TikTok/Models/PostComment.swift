//
//  PostComment.swift
//  TikTok
//
//  Created by Ivan Potapenko on 23.04.2022.
//

import Foundation

struct PostComment {
    let text: String
    let user: User
    let date: Date
    
    static func mockComments() -> [PostComment] {
        let user = User(username: "Potus",
                        profilePictureURL: nil,
                        identifier: UUID().uuidString)
        var comments = [PostComment]()
        for _ in 0...20 {
            let comment = PostComment(text: "This is an awesome post", user: user, date: Date())
            comments.append(comment)
        }
        return comments
    }
}
