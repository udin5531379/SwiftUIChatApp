//
//  SwiftUIView.swift
//  SwiftUIChatApp
//
//  Created by Udin Rajkarnikar on 1/25/22.
//

import SwiftUI

struct NewMessageView: View {
    
    @ObservedObject var vm = CreateNewUserViewModel()
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                ForEach(vm.users, id: \.self) { user in
                    
                    HStack {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .padding()
                        
                        Text("\(user.email)")
                            .padding()
                        
                        Spacer()
                    }
                    
                }
                
                Text("\(vm.message)")
                
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
                
                let data = ss.data()
//                self.message = "\(data)"
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
