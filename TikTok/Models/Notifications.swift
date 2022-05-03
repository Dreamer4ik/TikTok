//
//  Notifications.swift
//  TikTok
//
//  Created by Ivan Potapenko on 03.05.2022.
//

import Foundation

enum NotificationType {
    case postLike(postName: String)
    case userFollow(username: String)
    case postComment(postName: String)
    
    var id: String {
        switch self {
        case .postLike:
            return "postLike"
        case .userFollow:
            return "userFollow"
        case .postComment:
            return "postComment"
        }
    }
}

struct Notification {
    let text: String
    let type: NotificationType
    let date: Date
    
    static func mockData() -> [Notification] {
        let first = Array(0...5).compactMap({
            Notification(
                text: "Something happened: \($0)",
                type: .postComment(postName: "mavr"),
                date: Date()
            )
        })
        let second = Array(0...5).compactMap({
            Notification(
                text: "Something happened: \($0)",
                type: .userFollow(username: "gordon"),
                date: Date()
            )
        })

        let third = Array(0...5).compactMap({
            Notification(
                text: "Something happened: \($0)",
                type: .postLike(postName: "mavr"),
                date: Date()
            )
        })
        
        return first + second + third
    }
}
