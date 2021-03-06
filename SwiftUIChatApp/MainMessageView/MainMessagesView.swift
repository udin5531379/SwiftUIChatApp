//
//  MainMessagesView.swift
//  SwiftUIChatApp
//
//  Created by Udin Rajkarnikar on 1/13/22.
//

import SwiftUI
import SDWebImageSwiftUI

class MainMessageViewModel: ObservableObject {
    
    @Published var chatUser: ChatUser?
    
    init() {
        
        //utill and unless the user is loggedin, LOGINVIEW will be shown
        DispatchQueue.main.async{
            self.isUserLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil //user not logged in i.e uid == nil it is true
        }
        
        
        fetchCurrentUser()
    
    }
    
    func fetchCurrentUser(){
        
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        FirebaseManager.shared.firestore.collection("user").document(uid).getDocument { snapshot, error in
            
            if let error = error {
                print("Error in fetching the current users data", error)
                return
            }
            
            guard let data = snapshot?.data() else {
                return
            }
            
            self.chatUser = ChatUser(data: data)
            
            
        }
        
    }
    
    @Published var isUserLoggedOut =  false
    
    func handleUserSignout() {
        
        isUserLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
        
    }
    
}


struct MainMessagesView: View {
    
    @ObservedObject var vm  = MainMessageViewModel()
    
    @State var shouldShowLogoutOptions = false
    
    var body: some View {
        
        NavigationView {
            
            VStack{
                
                customNavBar
                
                messagesView
                
                NavigationLink("", isActive: $shouldNavigateToChatLogView) {
                    ChatLogView(chatUser: self.chatUser)
                }
                
            }.overlay(newMessageButton, alignment: .bottom)
            
        }
        
    }
    
    private var customNavBar: some View {
        
        
        HStack(spacing: 16){
            
            WebImage(url: URL(string: vm.chatUser?.profileImageURL ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipped()
                .cornerRadius(44)
            VStack(alignment: .leading, spacing: 3) {
                
                Text("\(vm.chatUser?.email ?? "")")
                    .font(.system(size: 27, weight: .bold))
                
            
                HStack{
                    
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(Color.green)
                    
                    Text("online")
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                    
                }
                
            }
            
            Spacer()
            
            Button {
                print("Setting button pressed")
                shouldShowLogoutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .foregroundColor(.black)
                    .font(.system(size: 20))
            }

            
        }.padding(.horizontal)
        .actionSheet(isPresented: $shouldShowLogoutOptions) {
                .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons:
                        [.destructive(Text("Signout"), action: {
                    
                    print("Handle Signout")
                    self.vm.handleUserSignout()
                }), .cancel() ])
            }
        
        .fullScreenCover(isPresented: $vm.isUserLoggedOut, onDismiss: nil) { //this fullscreencover is gonna create the content as soon as this view loads
            LoginView(didCompleteLoginProcess: {                             //fullScreenCover ley view matra daykhayo.... then Login click gareysi which is in                                                                             LoginView didCompleteLoginProcess() function execute huncha
                self.vm.isUserLoggedOut = false
                self.vm.fetchCurrentUser()
            })
        }
        
        
    }
    
    
    private var messagesView: some View {
        
        ScrollView {
            ForEach(0..<10, id: \.self) { num in
                
                VStack{
                    
                    NavigationLink {
                        ChatLogView(chatUser: chatUser)
                    } label: {
                        HStack(spacing: 18) {
                            
                            Image(systemName: "person.fill")
                                .padding(5)
                                .font(.system(size: 32, weight: .heavy))
                                .overlay(RoundedRectangle(cornerRadius: 44)
                                            .stroke(Color(.label), lineWidth: 1))
                            
                            VStack(alignment: .leading){
                                Text("Username")
                                    .font(.system(size: 16, weight: .bold))
                                    
                                Text("Message sent to user")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Text("22d")
                                .foregroundColor(Color.black)
                            
                        }.padding()
                            .foregroundColor(Color.black)
                    }
                    
                    Divider()
                
                }.navigationBarHidden(true)
                   
            }
        }
        
    }
    
    @State var isNewMessageViewOnTheScreen = false
    @State var shouldNavigateToChatLogView = false
    @State var chatUser : ChatUser?
    
    private var newMessageButton: some View {
        Button {
            
            print("New Message Pressed")
            self.isNewMessageViewOnTheScreen.toggle()
            
        } label: {
            
            HStack {
                Spacer()
                
                Text("+ New Message")
                
                Spacer()
            }.foregroundColor(Color.white)
                .padding(.vertical)
                .background(Color.blue)
                .cornerRadius(30)
                .padding(.horizontal)
            
        
        }.sheet(isPresented: $isNewMessageViewOnTheScreen, onDismiss: nil) {
            NewMessageView(didSelectNewUser: { user in  //user being passed back from callback..NewMessageView ma chahe button click gareysi forEach users ko euta user select huncha...
                print(user.email)                       //Tyo user chahe this view "MainMessageView" ma pass huncha and that user ko chahe email print gareyko
                
                self.shouldNavigateToChatLogView.toggle()
                self.isNewMessageViewOnTheScreen = false
                self.chatUser = user
            })
        }
    }
    
}


struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
