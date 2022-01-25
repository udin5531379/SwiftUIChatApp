//
//  ContentView.swift
//  SwiftUIChatApp
//
//  Created by Udin Rajkarnikar on 12/9/21.
//

import SwiftUI
import Firebase
import FirebaseFirestore


struct LoginView: View {
    
    let didCompleteLoginProcess : () -> ()
    
    @State var isLogin = false
    @State var email = ""
    @State var password = ""
    @State var message = ""
    
    //For imagePicker
    @State var changeProfileImage = false
    
    @State var imageSelected : UIImage?
    
   
    
    var body: some View {
        NavigationView{
            
            VStack(spacing: 10){
                ScrollView{
                    Picker(selection: $isLogin) {
                        
                        Text("Login")
                            .tag(true)
                        
                        Text("Create Account")
                            .tag(false)
                    
                    } label: {
                        
                        Text("Any topic")
                    
                    }.pickerStyle(SegmentedPickerStyle())
                        
                    if !isLogin{
                        
                        VStack {
                            
                            //Presenting an image picker...
                            Button {
                                
                                changeProfileImage.toggle()
                        
                                
                                
                            } label: {
                                
                                if let imageSelected = self.imageSelected {
                                    
                                    Image(uiImage: imageSelected)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                                    
                                } else {
                                    
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 64))
                                        .padding()
                                        .foregroundColor(.black)
                                    
                                }
                                
                            }
                            
                        }.fullScreenCover(isPresented: $changeProfileImage) {
                            ImagePicker(selectedImage: $imageSelected)
                        }
                        
                    }
                    
                    
                    Group{
                        
                        TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        
                        
                        SecureField("Password", text: $password)
                        
                    }
                    .padding(14)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(Color.white, lineWidth: 0.5)
                    )
                    .padding(.top, 10)
                    
                    
                    Button {
                        
                        handleAction()
                        
                    } label: {
                        HStack{
                            Spacer()
                            Text(isLogin ? "Login" : "Create Account")
                                .foregroundColor(Color.white)
                                .padding()
                            Spacer()
                        }.background(Color.blue)
                    }.cornerRadius(5)
                        .padding(.top)
                
                Text("\(message)")
                        .foregroundColor(Color.red)
                    
                    
                }.navigationTitle(isLogin ? "Login" : "Account Creation")
                    
            }.padding()
            .background(Color(.init(white: 0, alpha: 0.05)).ignoresSafeArea())
                
            
        }.navigationViewStyle(StackNavigationViewStyle())
      
    }
    
    private func handleAction() {
        if isLogin {
            
            login()
        
        } else {
            
            createNewAccount()
        
        }
    }
    
    private func createNewAccount(){
        
        if imageSelected == nil {
            print("Select an image")
        }
        
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                
                print("Failed to create User: ", error)
                
                return
            }
            
            print("Sucessfully created a user: ", result?.user.uid ?? "")
            
            persistImageToStorage()
            
        }
        
    }
    
    //used to save ProfileImage to firebase
    private func persistImageToStorage() {
        
        if imageSelected == nil {
            
            message = "Please select an image"
            
        }
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        
        guard let imageData = self.imageSelected?.jpegData(compressionQuality: 0.5) else { return }
        
        ref.putData(imageData, metadata: nil) { metadata, err in
            
            if let err = err {
                
                print("Error: ", err)
                
                return
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    
                    print("Error downloading the url: ", err)
                    
                    return
                
                }
                
                
                print("Sucessfully stored the image with downloaded the url: ", url?.absoluteString ?? "")
                
                guard let url = url else { return }
                storeUserInformation(imageProfileURL: url)
            }
            
        }
        
        
    }
    
    func storeUserInformation(imageProfileURL: URL) {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let userData = ["email": email, "uid": uid, "profileImageURL": imageProfileURL.absoluteString]
        
        FirebaseManager.shared.firestore.collection("user").document(uid).setData(userData) { error in
                
                guard let error = error else { return }
                
                print ("Failed to save user in DB", error)
                
                return
            }
        
        print("Sucessfully saved user in DB")
        
        self.didCompleteLoginProcess()
        
    }
    
    private func login(){
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                
                print("Failed to login User: ", error)
                
                return
            }
            
            print("Sucessfully logged in a user: ", result?.user.uid ?? "")
            
            self.didCompleteLoginProcess()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(didCompleteLoginProcess: {
            
        })
    }
}
