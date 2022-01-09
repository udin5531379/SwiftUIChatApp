//
//  ContentView.swift
//  SwiftUIChatApp
//
//  Created by Udin Rajkarnikar on 12/9/21.
//

import SwiftUI
import Firebase

class FirebaseManager: NSObject {
    
    let auth : Auth
    let storage : Storage
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        super.init()
    }
    
}

struct ContentView: View {
    
    @State var isLogin = false
    @State var email = ""
    @State var password = ""
    
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
            }
            
        }
        
        
        
    }
    
    private func login(){
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                
                print("Failed to login User: ", error)
                
                return
            }
            
            print("Sucessfully logged in a user: ", result?.user.uid ?? "")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
