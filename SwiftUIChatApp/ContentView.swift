//
//  ContentView.swift
//  SwiftUIChatApp
//
//  Created by Udin Rajkarnikar on 12/9/21.
//

import SwiftUI

struct ContentView: View {
    
    @State var isLogin = false
    @State var email = ""
    @State var password = ""
    
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
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .padding()
                                .foregroundColor(.black)
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
            
        }
      
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
