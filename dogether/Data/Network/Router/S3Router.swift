//
//  S3Router.swift
//  dogether
//
//  Created by seungyooooong on 2/12/25.
//

import Foundation

enum S3Router: NetworkEndpoint {
    case presignedUrls(presignedUrlRequest: PresignedUrlRequest)
    
    var path: String {
        switch self {
        case .presignedUrls:
            return Path.api + Path.s3 + "/presigned-urls"
        }
    }
    
    var method: NetworkMethod {
        switch self {
        case .presignedUrls:
            return .post
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        default:
            return nil
        }
    }
    
    var header: [String : String]? {
        switch self {
        default:
            return [
                Header.Key.contentType: Header.Value.applicationJson,
                Header.Key.authorization: Header.Value.bearer + (UserDefaultsManager.shared.accessToken ?? "")
            ]
        }
    }
    
    var body: (any Encodable)? {
        switch self {
        case .presignedUrls(let presignedUrlRequest):
            return presignedUrlRequest
        }
    }
}
