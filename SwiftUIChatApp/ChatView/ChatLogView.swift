//
//  ChatLogView.swift
//  SwiftUIChatApp
//
//  Created by Udin Rajkarnikar on 1/28/22.
//

import SwiftUI

struct ChatLogView: View {
    
    let chatUser: ChatUser?
    @State var textMessage: String = ""
    var placeHolder = "Text Message..."
    
    var body: some View {
        
        ZStack {
            
            messagesView
            
            VStack {
                
                Spacer()
                
                HStack(alignment: .bottom) {
                    
                    Button {
                        print("Button to send photos")
                    } label: {
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 20))
                    }.foregroundColor(.black)
                        .padding(.vertical, 10)
                    
                    ZStack {
                        
                        TextEditor(text: $textMessage)
                            
                        
                        HStack {
                            
                            Text("Send Message...")
                                .padding(.horizontal, 2)
                                .foregroundColor(.gray)
                                .opacity(textMessage.isEmpty ? 0.2 : 0.0)
                                
                            
                            Spacer()
                        }.frame(height: 40)
                    }
                   
                    
                    Button("Send"){
                        print("Send Button pressed")
                    }.padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                        .padding(.top, 30)

                }.padding(.horizontal)
                .frame(height: 40)
                .background(Color.white)
                
                
            }
            
            
            
            
                
        }
           
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
