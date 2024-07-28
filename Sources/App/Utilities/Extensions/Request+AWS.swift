//
//  Request+AWS.swift
//  
//
//  Created by Alyx Mote on 7/12/24.
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
