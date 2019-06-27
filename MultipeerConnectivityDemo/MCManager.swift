//
//  MCManager.swift
//  MultipeerConnectivityDemo
//
//  Created by Prateek Sharma on 6/27/19.
//  Copyright © 2019 Prateek Sharma. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol MCManagerProtocol: class {
    func didRecieve(data: Data)
    func didFailSendingData(error: Error)
    func didCompleteAvailableSessionBrowsing()
}

class MCManager: NSObject {
    
    static private let serviceType = "mc-datashare"
    static var shared = MCManager()
    weak var delegate: MCManagerProtocol?
    private let peerID: MCPeerID
    private var session: MCSession
    private var advertiserAssistant: MCAdvertiserAssistant
    
    private override init() {
        peerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        
        /*
            The serviceType parameter is a short text string used to describe the app's networking protocol. It should be in the same format as a Bonjour service type: up to 15 characters long and valid characters include ASCII lowercase letters, numbers, and the hyphen. A short name that distinguishes itself from unrelated services is recommended; for example, a text chat app made by ABC company could use the service type "abc-txtchat".
        */
        advertiserAssistant = MCAdvertiserAssistant(serviceType: MCManager.serviceType, discoveryInfo: nil, session: session)
        super.init()
        session.delegate = self
    }
    
    var connectedUsers: Int {
        return session.connectedPeers.count
    }
    
    func joinSession(from vc: UIViewController?) {
        let browserViewController = MCBrowserViewController(serviceType: MCManager.serviceType, session: session)
        browserViewController.delegate = self
        vc?.present(browserViewController, animated: true, completion: nil)
    }
    
    func startSession() {
        advertiserAssistant.start()
    }
    
    func broadcast(data: Data) {
        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            delegate?.didFailSendingData(error: error)
        }
    }
}

extension MCManager: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("\(state.name) - \(peerID.displayName)")
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
//        guard let user = try? JSONDecoder().decode(User.self, from: data)  else { return }
        delegate?.didRecieve(data: data)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) { }
}

extension MCManager: MCBrowserViewControllerDelegate {
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        delegate?.didCompleteAvailableSessionBrowsing()
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        delegate?.didCompleteAvailableSessionBrowsing()
    }
}


extension MCSessionState {
    
    var name: String {
        switch self {
        case .connected: return "Connected"
        case .connecting: return "Connecting"
        case .notConnected: return "Not Connected"
        @unknown default: fatalError("Error")
        }
    }
    
}


