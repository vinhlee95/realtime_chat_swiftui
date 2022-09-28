//
//  PrivateChatView.swift
//  realtime_chat
//
//  Created by Vinh Le on 20.9.2022.
//

import SwiftUI

struct PrivateChatView: View {
    let chatUser: ChatUser?
    @State private var chatText: String = ""
    
    var body: some View {
        VStack {
            chatList
            chatForm
        }
        .navigationTitle(chatUser?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)
        // fix the issue where the ScrollView blend to the nav bar
        .padding(.top, 1)
    }
    
    private var chatList: some View {
        ScrollView {
            Spacer().padding(.top, 4)
            ForEach(0..<20) { num in
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
                .padding(.vertical, 4)
            }
            
            HStack {
                Spacer()
            }
        }.background(Color(.init(white: 0.95, alpha: 1)))
    }
    
    private var chatForm: some View {
        HStack {
            Image(systemName: "photo").padding(.horizontal, 8)
            // Render placeholder for TextEditor since it does not have one by default
            ZStack {
                HStack {
                    Text("Description").padding(.leading, 4)
                    Spacer()
                }
                TextEditor(text: $chatText).frame(height: 40).opacity(chatText.isEmpty ? 0.5 : 1)
            }
            Button {
            } label: {
                Text("Send").foregroundColor(.white).padding(.horizontal, 16).padding(.vertical, 8)
            }.background(.blue).cornerRadius(4)
        }.padding(.vertical, 8).padding(.horizontal, 12)
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
