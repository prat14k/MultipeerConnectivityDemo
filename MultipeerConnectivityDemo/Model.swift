//
//  Model.swift
//  MultipeerConnectivityDemo
//
//  Created by Prateek Sharma on 6/27/19.
//  Copyright © 2019 Prateek Sharma. All rights reserved.
//

import Foundation

struct User: Codable {
    
//    let identifier = UUID()
    let name: String
    let playsFifa: Bool
    let address: String
    
    init(name: String, address: String, playsFifa: Bool) {
        self.name = name
        self.address = address
        self.playsFifa = playsFifa
    }
}
