//
//  ChatUser.swift
//  realtime_chat
//
//  Created by Vinh Le on 10.9.2022.
//

import Foundation

struct ChatUser: Identifiable {
    let id, email, profileImageUrl: String
    
    init(data: [String: Any]) {
        self.id = data["id"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
    }
}
