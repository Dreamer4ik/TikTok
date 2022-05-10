//
//  TikTokTests.swift
//  TikTokTests
//
//  Created by Ivan Potapenko on 09.05.2022.
//

import XCTest

@testable import TikTok

class TikTokTests: XCTestCase {
    func testPostModelChildPath() {
        let id = UUID().uuidString
        let user = User(username: "joerogan",
                        profilePictureURL: nil,
                        identifier: "123")
        
        var post = PostModel(identifier: id,
                             user: user)
        XCTAssertTrue(post.caption.isEmpty)
        post.caption = "Message"
        XCTAssertFalse(post.caption.isEmpty)
        XCTAssertEqual(post.caption, "Message")
        XCTAssertEqual(post.videoChildPath, "videos/joerogan/")
        
    }
  
}
