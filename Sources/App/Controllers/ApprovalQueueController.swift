//
//  Created by Alyx Mote on 12/12/22.
//

import Vapor
import Fluent

struct ApprovalQueueController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let queue = routes.grouped("approval-queue")
    }
}
