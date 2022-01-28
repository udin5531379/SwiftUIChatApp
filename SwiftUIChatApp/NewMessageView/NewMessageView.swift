//
//  SwiftUIView.swift
//  SwiftUIChatApp
//
//  Created by Udin Rajkarnikar on 1/25/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct NewMessageView: View {
    
    @ObservedObject var vm = CreateNewUserViewModel()
    @Environment (\.presentationMode) var presentationMode
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                
                VStack {
                    ForEach(vm.users, id: \.self) { user in
                        VStack(spacing: 5.0) {
                            
                            Button {
                                self.presentationMode.wrappedValue.dismiss()
                            } label: {
                                HStack {
                                    WebImage(url: URL(string: user.profileImageURL))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 70, height: 70)
                                        .clipped()
                                        .cornerRadius(44)
                                        .padding(.horizontal)
                                    
                                    Text("\(user.email)")
                                        .bold()
                                        .foregroundColor(.black)
                                        
                                    
                                    Spacer()
                                }
                                
                                
                            }
                            
                            Divider()
                        }
                        
                        
                    }
                    
                }
            }.navigationTitle("New Message")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Cancel") {
                                presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
        }
 
    }
}

class CreateNewUserViewModel: ObservableObject {
    
    @Published var message = ""
    @Published var users = [ChatUser]()
    
    
    init () {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        
        FirebaseManager.shared.firestore.collection("user").getDocuments { snapshots, err in
            if let err = err {

                self.message = "\(err)"
                return

            }

            guard let snapshots = snapshots?.documents else { return }
            
            snapshots.forEach { ss in
                
                let data = ss.data() //data dictionary
                let user = ChatUser(data: data)
                
                if user.uid != uid {
                    self.users.append(.init(data: data))
                }
   
            }

        }
        
        
        
    
    }
}


struct NewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        NewMessageView()
    }
}
