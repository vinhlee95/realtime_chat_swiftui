//
//  PrivateChatView.swift
//  realtime_chat
//
//  Created by Vinh Le on 20.9.2022.
//

import SwiftUI

struct PrivateChatView: View {
    let chatUser: ChatUser?
    
    var body: some View {
            ScrollView {
                ForEach(0..<10) { num in
                    HStack {
                        Spacer()
                        HStack {
                            Text("FAKE MESSAGE FOR NOW")
                                .foregroundColor(.white)
                                .padding()
                        }
                        .background(.blue)
                        .cornerRadius(8)
                    }
                    .padding(.horizontal, 8)
                }
                
                HStack {
                    Spacer()
                }
            }
            .navigationTitle(chatUser?.email ?? "")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.init(white: 0.95, alpha: 1)))
        }
}

struct PrivateChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PrivateChatView(chatUser: .init(data: [
                "email": "test@test.com",
                "id": "rXU3I3ki0fbMD8btWJtoF8rRLXf1",
                "profileImageUrl": "https://firebasestorage.googleapis.com:443/v0/b/swiftui-realtime-chat.appspot.com/o/images%2Fprofile%2FrXU3I3ki0fbMD8btWJtoF8rRLXf1.jpg?alt=media&token=d6267fc7-4761-4d67-b56a-a235fd486b96"
            ]))
        }
    }
}
