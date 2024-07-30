import Vapor
import Queues

struct EmailCleanup: AsyncScheduledJob {
    func run(context: QueueContext) async throws {
        // TODO: deletes all codes from password_reset_codes and confirm_email_codes that have expired
    }
}