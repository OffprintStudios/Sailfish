//
//  Created by Alyx Mote on 6/18/23.
//

import Foundation
import Vapor
import Fluent

struct SpecialEventService {
    let request: Request
}

extension Request {
    var specialEventService: SpecialEventService {
        .init(request: self)
    }
}
