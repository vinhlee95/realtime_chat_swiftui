//
//  PrivateChatView.swift
//  realtime_chat
//
//  Created by Vinh Le on 20.9.2022.
//

import SwiftUI

struct PrivateChatView: View {
//    let chatUser: ChatUser?
    
    var body: some View {
            ScrollView {
                ForEach(0..<10) { num in
                    Text("FAKE MESSAGE FOR NOW")
                }
            }
            .navigationTitle("Chat")
        }
}

struct PrivateChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PrivateChatView()
        }
    }
}
