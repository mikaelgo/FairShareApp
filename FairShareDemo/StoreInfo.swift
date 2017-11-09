//
//  StoreInfo.swift
//  FairShareDemo
//
//  Created by Mikael on 26/10/2017.
//  Copyright © 2017 Mikael. All rights reserved.
//

import UIKit

class StoreInfo {
    
    //MARK: Properties
    var storeName: String
    var storeChain: String
    var address: String
    var postalNumber: Int
    var contactPerson: String
    var phoneNumber: Int
    var modules: Int
    var shelfHeight: Int
    var shelfWidth: Int
    var shelfDepth: Int
    
    //MARK: Initialization
    init?(storeName: String, storeChain: String, address: String, postalNumber: Int, contactPerson: String, phoneNumber: Int,
         modules: Int, shelfHeight: Int, shelfWidth: Int, shelfDepth: Int) {
        
        if storeName.isEmpty || storeChain.isEmpty || address.isEmpty || postalNumber < 0 || contactPerson.isEmpty || phoneNumber < 0 || modules < 0 || shelfHeight < 0 || shelfWidth < 0 || shelfDepth < 0 {
            
            return nil
        }
        
        self.storeName = storeName
        self.storeChain = storeChain
        self.address = address
        self.postalNumber = postalNumber
        self.contactPerson = contactPerson
        self.phoneNumber = phoneNumber
        self.modules = modules
        self.shelfHeight = shelfHeight
        self.shelfWidth = shelfWidth
        self.shelfDepth = shelfDepth
        
    }
}
