//
//  MessageListView.swift
//  realtime_chat
//
//  Created by Vinh Le on 1.9.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatUser {
    let id, email, profileImageUrl: String
}

class MainMessagesViewModel: ObservableObject {
    @Published var mainUser: ChatUser?
    @Published var isLoggedOut: Bool = false
    
    init() {
        // Check if the user is currently logged in
        DispatchQueue.main.async {
            self.isLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        
        fetchCurrentUser()
    }
    
    private func fetchCurrentUser() {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        
        FirebaseManager.shared.database.collection("users").document(userId).getDocument { document, error in
            guard let data = document?.data() else {
                print("No user data")
                return
            }
            
            let id = data["id"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let profileImageUrl = data["profileImageUrl"] as? String ?? ""
            
            self.mainUser = ChatUser(id: id, email: email, profileImageUrl: profileImageUrl)
        }
    }
    
    func handleLogout() {
        isLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
}

struct MessageListView: View {
    @State var shouldShowLogoutActionSheet = false
    @ObservedObject private var model = MainMessagesViewModel()
    
    private var CustomNavBar: some View {
        HStack(alignment: .center) {
            WebImage(url: URL(string: model.mainUser?.profileImageUrl ?? ""))
                .resizable()
                .clipped()
                .frame(width: 52, height: 52, alignment: .center)
                .cornerRadius(42)
                .shadow(radius: 10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(model.mainUser?.email ?? "").font(.system(size: 24, weight: .bold))
                HStack {
                    Circle().foregroundColor(.green).frame(width: 14, height: 14)
                    Text("online")
                }
            }
            
            Spacer()
            Button {
                shouldShowLogoutActionSheet.toggle()
            } label: {
                Image(systemName: "gear").font(.system(size: 28))
            }
        }
        .padding()
        .actionSheet(isPresented: $shouldShowLogoutActionSheet) {
            .init(title: Text("Settings"), buttons: [
                .destructive(Text("Logout"), action: {
                    model.handleLogout()
                }),
                .cancel()
            ])
        }
    }
    
    private var NewMessageButton: some View {
        Button(action: {
            print("New message")
        }, label: {
            HStack {
                Spacer()
                Text("+ New Message")
                Spacer()
            }
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(48)
                .shadow(radius: 14)
        })
        .padding()
    }
    
    private var MessageLine: some View {
        HStack {
            Image(systemName: "person.fill").font(.system(size: 32))
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 44)
                        .stroke(Color.black, lineWidth: 1)
                )
            VStack(alignment: .leading) {
                Text("Username")
                Text("Message content")
            }
            Spacer()
            Text("22 days")
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                CustomNavBar
                ScrollView {
                    ForEach(0..<20, id: \.self) {num in
                        MessageLine
                        Divider()
                    }
                }
                .navigationBarHidden(true)
                .padding(.horizontal)
            }
        }
        .overlay(
            NewMessageButton,
            alignment: .bottom
        )
        .fullScreenCover(isPresented: $model.isLoggedOut) {
            LoginView()
        }
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView()
    }
}
