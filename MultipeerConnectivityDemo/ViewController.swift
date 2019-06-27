//
//  ViewController.swift
//  MultipeerConnectivityDemo
//
//  Created by Prateek Sharma on 6/27/19.
//  Copyright © 2019 Prateek Sharma. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    private var users = [User]()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let formController = segue.destination as? FormViewController  else { return }
        formController.delegate = self
    }
}

extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as! UserTableViewCell
        cell.setup(user: users[indexPath.row])
        return cell
    }
}

extension ViewController: UserFormProtocol {
    
    func saveUser(_ user: User) {
        users.append(user)
        tableView.insertRows(at: [IndexPath(row: users.count - 1, section: 0)], with: .top)
    }
}
