//
//  ProfileImage.swift
//  realtime_chat
//
//  Created by Vinh Le on 13.9.2022.
//
import SwiftUI
import SDWebImageSwiftUI

extension WebImage {
    static func profileImage(url: String) -> some View {
        return WebImage(url: URL(string: url))
            .resizable()
            .clipped()
            .frame(width: 52, height: 52, alignment: .center)
            .cornerRadius(42)
            .shadow(radius: 10)
    }
}
