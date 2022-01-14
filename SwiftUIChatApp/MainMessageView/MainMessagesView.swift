//
//  MainMessagesView.swift
//  SwiftUIChatApp
//
//  Created by Udin Rajkarnikar on 1/13/22.
//

import SwiftUI

struct MainMessagesView: View {
    
    @State var shouldShowLogoutOptions = false
    
    var body: some View {
        
        NavigationView {
            
            VStack{
                
                customNavBar
                
                messagesView
                
            }.overlay(newMessageButton, alignment: .bottom)
            
        }
        
    }
    
    private var customNavBar: some View {
        
        HStack(spacing: 16){
            
            Image(systemName: "person.fill")
                .font(.system(size: 40))
            
            VStack(alignment: .leading, spacing: 3) {
                
                Text("Username")
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
                    
                }), .cancel() ])
            }
        
        
    }
    
    
    private var messagesView: some View {
        
        ScrollView {
            ForEach(0..<10, id: \.self) { num in
                
                VStack{
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
                        
                    }.padding()
                    
                    Divider()
                
                }.navigationBarHidden(true)
                   
            }
        }
        
    }
    
    
    private var newMessageButton: some View {
        Button {
            
            print("New Message Pressed")
            
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
            
        
        }
    }
    
}


struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
