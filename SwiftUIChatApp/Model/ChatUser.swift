//
//  ChatUser.swift
//  SwiftUIChatApp
//
//  Created by Udin Rajkarnikar on 1/25/22.
//

import Foundation


struct ChatUser : Identifiable, Hashable{
    var id: String { uid }
    
    
    let email, profileImageURL, uid: String
    
    init(data : [String: Any]) {
        self.email = data["email"] as? String ?? ""
        self.profileImageURL = data["profileImageURL"] as? String ?? ""
        self.uid =  data["uid"] as? String ?? ""
    }
}
