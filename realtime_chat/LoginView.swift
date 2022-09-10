//
//  ContentView.swift
//  realtime_chat
//
//  Created by Vinh Le on 29.7.2022.
//

import SwiftUI

enum LoginMode {
    case login
    case createNewAccount
}

extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}

struct LoginView: View {
    // Callback that will be executed when the user successfully logged in
    let handleLoginSuccess: () -> ()
    
    @State private var mode = LoginMode.login
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isImagePickerShown = false
    @State private var profileImage: UIImage?
        
    var body: some View {
        NavigationView {
            ScrollView {
                Picker(selection: $mode, label: Text("Picker here")) {
                    Text("Login").tag(LoginMode.login)
                    Text("Create account").tag(LoginMode.createNewAccount)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(5)
                
                // Only render image picker button in Create account mode
                if self.mode == LoginMode.createNewAccount {
                    Button {
                        isImagePickerShown.toggle()
                    } label: {
                        if let image = profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 128, height: 128)
                                .cornerRadius(64)
                        } else {
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .padding()
                        }
                    }

                }
                
                TextField("Email", text: $email)
                    .onChange(of: email, perform: { newValue in
                        if !errorMessage.isEmpty {
                            errorMessage = ""
                        }
                    })
                    .padding().keyboardType(.emailAddress).autocapitalization(.none).background(.white).cornerRadius(4)
                
                SecureField("Password", text: $password)
                    .onChange(of: password, perform: { newValue in
                        if !errorMessage.isEmpty {
                            errorMessage = ""
                        }
                    })
                    .padding().background(.white).cornerRadius(4)
                
                Text(!errorMessage.isEmpty ? errorMessage.firstUppercased : "").foregroundColor(.red)
                
                Button {
                    handleAuthenticate()
                } label: {
                    HStack {
                        Spacer()
                        Text(mode == LoginMode.login ? "Login" : "Create account")
                            .foregroundColor(Color.white)
                            .padding(.vertical, 10)
                        Spacer()
                    }.background(Color.blue)
                }.cornerRadius(4)
            }
            .navigationTitle(mode == LoginMode.login ? "Login" : "Create new account")
            .padding(.horizontal, 20)
            .background(Color(.init(white: 0, alpha: 0.05)))
            .fullScreenCover(isPresented: $isImagePickerShown) {
                ImagePicker(image: $profileImage)
            }
            
        }
    }
    
    private func handleAuthenticate() {
        if mode == LoginMode.login {
            login()
        } else if mode == LoginMode.createNewAccount {
            createNewAccount()
        } else {
            print("no action")
        }
    }
    
    private func login() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
            if let err = error {
                self.errorMessage = "failed to create new account \(err.localizedDescription)"
                return
            }
            self.handleLoginSuccess()
        }
    }
    
    private func createNewAccount() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, error in
            if let err = error {
                self.errorMessage = "failed to create new account \(err.localizedDescription)"
                return
            }
            uploadProfileImage()
        }
    }
    
    // Upload use's profile image to Firebase Storage
    // https://firebase.google.com/docs/storage/ios/upload-files
    private func uploadProfileImage() {
        guard let userId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        guard let uploadingImage = self.profileImage?.jpegData(compressionQuality: 0.5) else {return}
        
        let storageRef = FirebaseManager.shared.storage.reference()
        let userProfileImageRef = storageRef.child("images/profile/\(userId).jpg")
        
        userProfileImageRef.putData(uploadingImage, metadata: nil) { metadata, error in
            guard let metadata = metadata else {
                guard let errorMessage = error?.localizedDescription else {return}
                self.errorMessage = errorMessage
                return
            }
            
            print("Successfully uploaded profile image", metadata)
            
            userProfileImageRef.downloadURL { url, error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                guard let email = FirebaseManager.shared.auth.currentUser?.email else {return}
                
                guard let profileImageUrl = url?.absoluteString else {return}
                
                saveUser(userId: userId, email: email, profileImageUrl: profileImageUrl)
                
                self.handleLoginSuccess()
            }
        }
    }
    
    private func saveUser(userId: String, email: String, profileImageUrl: String) {
        FirebaseManager.shared.database.collection("users").document(userId).setData(["id": userId, "email": email, "profileImageUrl": profileImageUrl]) { err in
            if let err = err {
                self.errorMessage = err.localizedDescription
                return
            }
            print("Successfully saved user to DB")
        }
    }
}

struct ContentView_Previews2: PreviewProvider {
    static var previews: some View {
        LoginView(handleLoginSuccess:  {
            
        })
    }
}
