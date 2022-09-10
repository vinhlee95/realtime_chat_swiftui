//
//  MessageListView.swift
//  realtime_chat
//
//  Created by Vinh Le on 1.9.2022.
//

import SwiftUI
import SDWebImageSwiftUI

class MainMessagesViewModel: ObservableObject {
    @Published var mainUser: ChatUser? = nil
    @Published var isLoggedOut: Bool = false
    @Published var error: String = ""
    
    init() {
        // Check if the user is currently logged in
        DispatchQueue.main.async {
            self.isLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        
        fetchCurrentUser()
    }
    
    func fetchCurrentUser() {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        
        FirebaseManager.shared.database.collection("users").document(userId).getDocument { document, error in
            guard let data = document?.data() else {
                self.error = "Failed to fetch data for current user. Please contact app developer."
                return
            }
            
            self.mainUser = .init(data: data)
        }
    }
    
    func handleLogout() {
        // Flip logout state to present login view
        isLoggedOut.toggle()
        
        // Clear local state
        self.mainUser = nil
        self.error = ""
        
        // Signout Firebase user
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
                
                Text(model.error).foregroundColor(.red)
                
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
            LoginView(handleLoginSuccess: {
                self.model.isLoggedOut = false
                self.model.fetchCurrentUser()
            })
        }
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView()
    }
}
