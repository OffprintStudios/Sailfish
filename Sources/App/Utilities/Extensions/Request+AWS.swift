//
//  Request+AWS.swift
//
//
//  Created by Alyx Mote on 10/15/23.
//

import Vapor
import SotoS3

public extension Request {
    var aws: AWS {
        .init(request: self)
    }
    
    struct AWS {
        let request: Request
        
        var client: AWSClient {
            request.application.aws.client
        }
    }
}
