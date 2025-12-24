//
//  S3Manager.swift
//  dogether
//
//  Created by seungyooooong on 2/17/25.
//

import UIKit

final class S3Manager {
    static let shared = S3Manager()

    private init() {}
    
    func uploadImage(image: UIImage?) async throws -> String? {
        let request: PresignedUrlRequest = PresignedUrlRequest(dailyTodoId: 0, uploadFileTypes: [FileTypes.image.rawValue])
        let response: PresignedUrlResponse = try await NetworkManager.shared.request(
            S3Router.presignedUrls(presignedUrlRequest: request)
        )
        
        guard let imageData = image?.pngData(), let presignedUrl = URL(string: response.presignedUrls[0]) else { return nil }
        return try await uploadImageToS3(imageData: imageData, presignedUrl: presignedUrl)
    }
    
    // TODO: 추후 NetworkLayer로 이동
    func uploadImageToS3(imageData: Data, presignedUrl: URL) async throws -> String {
        var request = URLRequest(url: presignedUrl)
        request.httpMethod = "PUT"
        request.setValue("image/png", forHTTPHeaderField: "Content-Type")
        
        let (_, _) = try await URLSession.shared.upload(for: request, from: imageData)
        
        return getImageUrlString(from: presignedUrl)
    }
    
    func getImageUrlString(from url: URL) -> String {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return url.absoluteString }
        components.query = nil
        return (components.url ?? url).absoluteString
    }

}
