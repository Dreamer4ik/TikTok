//
//  Notifications.swift
//  TikTok
//
//  Created by Ivan Potapenko on 03.05.2022.
//

import Foundation

struct Notification {
    let text: String
    let date: Date
    
    static func mockData() -> [Notification] {
        return Array(0...100).compactMap({
            Notification(text: "Something happened: \($0)", date: Date())
        })
    }
}
