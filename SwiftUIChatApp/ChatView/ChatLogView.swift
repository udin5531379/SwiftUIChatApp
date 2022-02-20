//
//  ChatLogView.swift
//  SwiftUIChatApp
//
//  Created by Udin Rajkarnikar on 1/28/22.
//

import SwiftUI
import Firebase



struct ChatMessage: Identifiable {
    
    var id : String { documentId }
    
    let documentId: String
    let fromID, toID, textMessage, timestamp: String
    
    init (documentId: String, data : [String : Any]){
        self.documentId = documentId
        self.fromID = data["fromID"] as? String ?? ""
        self.toID = data["toID"] as? String ?? ""
        self.textMessage = data["textMessage"] as? String ?? ""
        self.timestamp = data["timestamp"] as? String ?? ""
        
    }
    
}

class ChatLogViewModel : ObservableObject {
    
    @Published var textMessage: String = ""
    @Published var chatMessages = [ChatMessage]() //empty array of type ChatMessage
    
    let chatUser : ChatUser?
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        
        fetchMessages()
    }
    
    func fetchMessages() {
        
        guard let fromID = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toID = chatUser?.uid else { return }
            
        FirebaseManager.shared.firestore.collection("messages")
            .document(fromID)
            .collection(toID)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print(error)
                    return
                }
            
                querySnapshot?.documentChanges.forEach({ change in

                    if change.type == .added { //to listen to changes and call this snapshot only when there are changes to the document

                        let data = change.document.data()
                        let chatMessage = ChatMessage(documentId: change.document.documentID , data: data)
                        print(chatMessage)
                        self.chatMessages.append(chatMessage)
                    }
            })
            
//            querySnapshot?.documents.forEach({ querySnapshotDocuments in
//                print(querySnapshotDocuments)
//                let data = querySnapshotDocuments.data()
//                let chatMessage = ChatMessage(documentId: querySnapshotDocuments.documentID, data: data)
//                self.chatMessages.append(chatMessage)
//            })

        }
        
    }
    
    
    
    func handleSendText(text: String) {
        
        //sending messages from the current user
        
        guard let fromID = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toID = chatUser?.uid else { return }
        
        print("Sending message to: \(toID ) & mesasge is: \(text)...")
        
        let document = FirebaseManager.shared.firestore.collection("messages").document(fromID).collection(toID).document()
        let messageData = ["fromID": fromID, "toID": toID, "textMessage": text, "timestamp ": Timestamp()] as [String : Any]
        
        document.setData(messageData) { error in
            if let error = error {
                
                print(error)
                return
                
            }
            //After sucessfully sending message we want to empty out the textField
            self.textMessage = ""
            
            print("Message Sent to \(self.chatUser?.email ?? "") having uid \(toID) from \(fromID)")
        }
        
        //recipient receving the message...
        
        let documentForRecipient = FirebaseManager.shared.firestore.collection("messages").document(toID).collection(fromID).document()
        
        documentForRecipient.setData(messageData) { error in
            if let error = error {
                
                print(error)
                return
                
            }
            
            print("Message Sent from \(fromID) to me \(self.chatUser?.email ?? "") having uid \(toID) ")
        }
        
    }
    
}

struct ChatLogView: View {
    
    let chatUser: ChatUser?
    @ObservedObject var vm : ChatLogViewModel //first ma chahe empty
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser //"white" chatUser is bahera bata aako chatUser...self.chatUser bhaenyko chahe yo ChatLogView ma define bhako chatUser.
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
    
     var messagesView: some View {
        
        ScrollView {
            
            ForEach(vm.chatMessages) { message in
                if message.fromID == FirebaseManager.shared.auth.currentUser?.uid {
                    HStack{
                        Spacer()
                        Text(message.textMessage)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                            .padding(.vertical, 5)
                        
                    }.padding(.horizontal)
                } else {
                    HStack{
                        Text(message.textMessage)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                            .padding(.vertical, 5)
                        
                        Spacer()
                     }.padding(.horizontal)
                }
                        
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
