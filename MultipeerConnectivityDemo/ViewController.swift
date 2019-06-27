//
//  ViewController.swift
//  MultipeerConnectivityDemo
//
//  Created by Prateek Sharma on 6/27/19.
//  Copyright © 2019 Prateek Sharma. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UITableViewController {

    private var users = [User]()
    private let mcManager = MCManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mcManager.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let formController = segue.destination as? FormViewController  else { return }
        formController.delegate = self
    }
    
    @IBAction private func configureSession() {
        let alert = UIAlertController(title: "Share user", message: "Do you want to host or join a session for sharing", preferredStyle: .actionSheet)
        let hostAction = UIAlertAction(title: "Host Action", style: .default) { [weak self] (action) in
            self?.mcManager.startSession()
        }
        let joinAction = UIAlertAction(title: "Join Action", style: .default) { [weak self] (action) in
            self?.mcManager.joinSession(from: self)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(hostAction)
        alert.addAction(joinAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as! UserTableViewCell
        cell.setup(user: users[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension ViewController: UserFormProtocol {
    
    func saveUser(_ user: User) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self  else { return }
            weakSelf.users.append(user)
            weakSelf.tableView.insertRows(at: [IndexPath(row: weakSelf.users.count - 1, section: 0)], with: .top)
        }
    }
}

extension ViewController: UserTableViewCellProtocol {
    
    func didRequestShare(_ cell: UserTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              mcManager.connectedUsers > 0,
              let data = try? JSONEncoder().encode(users[indexPath.row])
        else { return }
        mcManager.broadcast(data: data)
    }
}

extension ViewController: MCManagerProtocol {
    func didCompleteAvailableSessionBrowsing() {
        dismiss(animated: true, completion: nil)
    }
    
    func didRecieve(data: Data) {
        guard let user = try? JSONDecoder().decode(User.self, from: data)  else { return }
        saveUser(user)
    }
    
    func didFailSendingData(error: Error) {
        print(error)
    }
}
