//
// Created by Alyx Mote on 12/2/22.
//

import App
import Vapor

extension Application {
    private static let runQueue = DispatchQueue(label: "Run")

    func run() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            Self.runQueue.async { [self] in
                do {
                    try run()
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

@main
enum Run {
    static func main() async throws {
        var env = try Environment.detect()
        try LoggingSystem.bootstrap(from: &env)
        let app = Application(env)
        defer { app.shutdown() }

        try await configure(app)
        try await app.run()
    }
}
