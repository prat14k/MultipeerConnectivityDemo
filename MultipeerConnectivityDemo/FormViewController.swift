//
//  FormViewController.swift
//  MultipeerConnectivityDemo
//
//  Created by Prateek Sharma on 6/27/19.
//  Copyright © 2019 Prateek Sharma. All rights reserved.
//

import UIKit

protocol UserFormProtocol: class {
    func saveUser(_ user: User)
}

class FormViewController: UIViewController {
    
    weak var delegate: UserFormProtocol?
    @IBOutlet weak private var nameTextField: UITextField!
    @IBOutlet weak private var addressTextField: UITextField!
    @IBOutlet weak private var playsFifaBtn: UIButton! {
        didSet {
            playsFifaBtn.backgroundColor = UIColor.lightGray
        }
    }
    
    @IBAction private func dismissScene() {
        dismiss(animated: true)
    }
    
    @IBAction func toggleFifaPlayState() {
        playsFifaBtn.isSelected = !playsFifaBtn.isSelected
        playsFifaBtn.backgroundColor = playsFifaBtn.isSelected ? UIColor.blue.withAlphaComponent(0.7) : UIColor.lightGray
    }
    
    @IBAction func saveUser() {
        if let name = nameTextField.text?.trimmingCharacters(in: .whitespaces), !name.isEmpty,
            let address = addressTextField.text?.trimmingCharacters(in: .whitespaces), !address.isEmpty {
            let user = User(name: name, address: address, playsFifa: playsFifaBtn.isSelected)
            delegate?.saveUser(user)
        }
        dismissScene()
    }
}
