//
//  Created by Alyx Mote on 6/18/23.
//

import Foundation
import Vapor
import Fluent

struct SpecialEventService {
    let request: Request
    
    func checkEvent() async throws {
        let event = try await SpecialEvent.query(on: request.db)
            .filter(\.$event)
    }
}

extension Request {
    var specialEventService: SpecialEventService {
        .init(request: self)
    }
}
