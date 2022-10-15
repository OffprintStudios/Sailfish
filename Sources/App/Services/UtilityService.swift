//
// Created by Alyx Mote on 10/14/22.
//

import Foundation
import Vapor
import SotoS3

struct UtilityService {
    let request: Request

    private let s3 = S3(
        client: AWSClient(
            credentialProvider: .static(
                accessKeyId: Environment.get("DIGITALOCEAN_SPACES_ACCESS_KEY") ?? "nil",
                secretAccessKey: Environment.get("DIGITALOCEAN_SPACES_SECRET") ?? "nil"
            ),
            httpClientProvider: .createNew
        ),
        endpoint: Environment.get("DIGITALOCEAN_SPACES_ENDPOINT") ?? "nil"
    )

    func uploadImage(file: File, itemId: String, folder: String) async throws -> String {
        try validateImage(file)
        let ext = try getExtension(file)
        let bucket = "\(Environment.get("DIGITALOCEAN_SPACES_NAME") ?? "nil")/\(folder)"
        let newFilename = "\(itemId)-\(UUID()).\(ext)"

        let imgRequest = S3.PutObjectRequest(
            acl: .publicRead,
            body: AWSPayload.byteBuffer(file.data),
            bucket: bucket,
            contentType: file.multipart?.contentType,
            key: newFilename
        )

        let response = try await s3.putObject(imgRequest)
        if response.eTag != nil {
            return "https://images.offprint.net/\(folder)/\(newFilename)"
        } else {
            throw Abort(.internalServerError, reason: "Failed to process image upload")
        }
    }

    private func validateImage(_ file: File) throws {
        if file.multipart != nil {
            if let contentType = file.contentType {
                if contentType.description != "image/jpg" && contentType.description != "image/jpeg" && contentType.description != "image/png" {
                    throw Abort(.badRequest, reason: "Uploads must either be a JPEG or PNG image.")
                } else {
                    return
                }
            } else {
                throw Abort(.badRequest, reason: "Uploads must either be a JPEG or PNG image.")
            }
        } else {
            throw Abort(.badRequest, reason: "Uploads must either be a JPEG or PNG image.")
        }
    }

    private func getExtension(_ file: File) throws -> String {
        if let filetype = file.extension {
            if filetype == "image/jpeg" || filetype == "image/jpg" {
                return "jpg"
            } else {
                return "png"
            }
        } else {
            throw Abort(.internalServerError, reason: "Could not find valid extension.")
        }
    }
}

extension Request {
    var utilityService: UtilityService {
        .init(request: self)
    }
}
