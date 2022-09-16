//
// Created by Alyx Mote on 9/13/22.
//

import Foundation
import Vapor

actor SocketManager {
    static let `default` = SocketManager()

    private var clients = [String: Client]()

    private init() { }

    func insert(id: String, on ws: WebSocket) {
        let session = Client(socket: ws)
        clients[id] = session
    }

    func send(message: String) {
        flush()
        for client in clients {
            client.value.socket.send(message)
        }
    }

    private func flush() {
        clients = clients.filter { _, session in
            !session.socket.isClosed
        }
    }
}

extension SocketManager {
    struct Client {
        let socket: WebSocket
    }
}