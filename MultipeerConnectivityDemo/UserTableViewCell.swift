//
//  UserCell.swift
//  MultipeerConnectivityDemo
//
//  Created by Prateek Sharma on 6/27/19.
//  Copyright © 2019 Prateek Sharma. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    static let identifier = "userCell"
    
    @IBOutlet weak private var nameLbl: UILabel!
    @IBOutlet weak private var addressLbl: UILabel!
    @IBOutlet weak private var playsFifaLbl: UILabel!
    
    func setup(user: User) {
        nameLbl.text = user.name
        addressLbl.text = user.address
        playsFifaLbl.textColor = user.playsFifa ? UIColor.green : UIColor.lightGray
    }
    
}
