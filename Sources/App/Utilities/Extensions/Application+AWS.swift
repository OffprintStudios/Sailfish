//
//  Application+AWS.swift
//
//
//  Created by Alyx Mote on 10/15/23.
//

import Vapor
import SotoS3

public extension Application {
    var aws: AWS {
        .init(application: self)
    }
    
    struct AWS {
        let application: Application
        
        struct ClientKey: StorageKey {
            typealias Value = AWSClient
        }
        
        public var client: AWSClient {
            get {
                guard let client = self.application.storage[ClientKey.self] else {
                    fatalError("AWSClient not configured. Use application.aws.client = ...")
                }
                return client
            }
            nonmutating set {
                self.application.storage.set(ClientKey.self, to: newValue) {
                    try $0.syncShutdown()
                }
            }
        }
    }
}
