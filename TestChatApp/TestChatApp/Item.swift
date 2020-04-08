//
//  Item.swift
//  TestChatApp
//
//  Created by 小林裕 on 2020/03/30.
//  Copyright © 2020 KobayashiYu. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Item{
    var ref: DatabaseReference?
    var title:String?
    
    init (snapshot: DataSnapshot){
        ref = snapshot.ref
        
        let data = snapshot.value as! Dictionary<String, String>
        title = data["title"]! as String
    }
}
