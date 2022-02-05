//
//  ChatLogView.swift
//  SwiftUIChatApp
//
//  Created by Udin Rajkarnikar on 1/28/22.
//

import SwiftUI
import Firebase

class ChatLogViewModel : ObservableObject {
    
    @Published var textMessage: String = ""
    
    let chatUser : ChatUser?
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
    }
    
    func handleSendText(text: String) {
        
        guard let fromID = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        guard let toID = chatUser?.uid else { return }
        
        print("Sending message to: \(toID ) & mesasge is: \(text)...")
        
        let document = FirebaseManager.shared.firestore.collection("messages").document(fromID).collection(toID).document()
        
        let messageData = ["fromID": fromID, "toID": toID, "textMessage": text, "timestamp ": Timestamp()] as [String : Any]
        
        document.setData(messageData) { [self] error in
            if let error = error {
                
                print(error)
                return
                
            }
            
            print("Message Sent to \(chatUser?.email ?? "") having uid \(toID) from \(fromID)")
        }
        
    }
    
}

struct ChatLogView: View {
    
    let chatUser: ChatUser?
    @ObservedObject var vm : ChatLogViewModel //first ma chahe empty
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser //"white" chatUser is bahera bata aako chatUser...
        self.vm = ChatLogViewModel(chatUser: chatUser)
    }

    var body: some View {
        
        ZStack {
            
            messagesView
            
            VStack {
                
                Spacer()
                chatBottomBar
            }
            
        }
           
    }
    
    private var chatBottomBar: some View {
        
        HStack(alignment: .bottom) {
            
            Button {
                print("Button to send photos")
            } label: {
                Image(systemName: "photo.on.rectangle")
                    .font(.system(size: 20))
            }.foregroundColor(.black)
                .padding(.vertical, 10)
            
            ZStack {
                
                TextEditor(text: $vm.textMessage)
                    
                
                HStack {
                    
                    Text("Send Message...")
                        .padding(.horizontal, 10)
                        .foregroundColor(.gray)
                        .cornerRadius(5.0)
                        .opacity(vm.textMessage.isEmpty ? 0.2 : 0.0)
                        
                    
                    Spacer()
                }.frame(height: 40)
            }
           
            
            Button("Send"){
                
                print("Send Button pressed")
                vm.handleSendText(text: vm.textMessage)
                
                
            }.padding(.horizontal, 20)
                .padding(.vertical, 12)
                .foregroundColor(Color.black)
                .cornerRadius(10)
                .padding(.top, 30)

        }.padding(.horizontal)
        .frame(height: 40)
        .background(Color.white)
        
        
    }
    
    private var messagesView: some View {
        
        ScrollView {
            ForEach(0..<20) { num in
                
                HStack{
                    
                    Spacer()
                    
                    Text("Fake Messages")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                        .padding(.vertical, 5)
                    
                }.padding(.horizontal)
            }
            .navigationBarTitle(chatUser?.email ?? "")
             .navigationBarTitleDisplayMode(.inline)
             .padding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0))
            
        }.background(Color.init(white: 0.9, opacity: 1))
            

        
    }

}

    

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatLogView(chatUser: .init(data: ["uid": "1JrH4gvioDVSAH1ObrTaNOaqbp33", "email": "ann@gmail.com"]))
        }
     }
}
