//
//  NewMessageView.swift
//  realtime_chat
//
//  Created by Vinh Le on 13.9.2022.
//

import SwiftUI
import SDWebImageSwiftUI

class NewMessageViewModel: ObservableObject {
    @Published var users = [ChatUser]()
    @Published var error: String = ""
    
    init() {
        fetchUsers()
    }
    
    private func fetchUsers() {
        FirebaseManager.shared.database.collection("users").getDocuments { snapshot, error in
            if let error = error {
                self.error = error.localizedDescription
                return
            }
            
            snapshot?.documents.forEach({ snapshot in
                let userData = snapshot.data()
                
                if FirebaseManager.shared.auth.currentUser?.uid != userData["id"] as? String {
                    self.users.append(.init(data: snapshot.data()))
                }
                
            })
        }
    }
}

struct NewMessageView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var model = NewMessageViewModel()
    
    let handleSelectChatUser: (ChatUser) -> ()
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(self.model.users) { user in
                    Button {
                        handleSelectChatUser(user)
                    } label: {
                        HStack {
                            WebImage.profileImage(url: user.profileImageUrl)
                            VStack(alignment: .leading) {
                                Text(user.email).foregroundColor(Color(.label))
                            }
                            Spacer()
                        }.padding(.horizontal)
                    }

                    Divider()
                }
            }.navigationTitle("New message")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                        }

                    }
                }
        }
    }
}

struct NewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        NewMessageView {user in
            
        }
    }
}
