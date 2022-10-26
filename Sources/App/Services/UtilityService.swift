//
// Created by Alyx Mote on 10/14/22.
//

import Foundation
import Vapor
import SotoS3

struct UtilityService {
    let request: Request

    func uploadImage(_ image: UploadImage, itemId: String, folder: String) async throws -> String {
        let ext = (image.mime == "image/jpg" || image.mime == "image/jpeg") ? "jpeg" : "png"
        let bucket = "\(Environment.get("DIGITALOCEAN_SPACES_NAME") ?? "nil")/\(folder)"
        let newFilename = "\(itemId)-\(UUID()).\(ext)"
        let buffer = ByteBuffer(data: image.image)

        let s3 = S3(client: request.aws.client, endpoint: Environment.get("DIGITALOCEAN_SPACES_ENDPOINT") ?? "nil")

        let imgRequest = S3.PutObjectRequest(
            acl: .publicRead,
            body: AWSPayload.byteBuffer(buffer),
            bucket: bucket,
            contentType: image.mime,
            key: newFilename
        )

        let response = try await s3.putObject(imgRequest)
        if response.eTag != nil {
            return "https://images.offprint.net/\(folder)/\(newFilename)"
        } else {
            throw Abort(.internalServerError, reason: "Failed to process image upload")
        }
    }
}

extension UtilityService {
    struct UploadImage: Content {
        var image: Data
        var filename: String
        var mime: String
    }
}

extension Request {
    var utilityService: UtilityService {
        .init(request: self)
    }
}
