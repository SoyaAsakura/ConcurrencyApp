//
//  ConcurrencyRepository.swift
//  ConcurrencyApp
//
//  Created by s.asakura on 2023/11/29.
//

import Foundation
import UIKit

class ThumbnailFailedError: Error {
}

class ConcurrencyRepository {
    
    func callbackFetchThumbnail(for id: String, completion: @escaping (UIImage?, Error?) -> Void) {
        let request = thumbnailURLRequest(for: id)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(nil, error)
            } else {
                guard let image = UIImage(data: data!) else { completion(nil, Error.self as? Error); return }
                
                
            }
            
        }
        dataTask.resume()
    }
    
    

    func asyncFetchThumbnail(for id: String) async throws -> UIImage {
        let request = thumbnailURLRequest(for: id)
        let (data, response) = try await URLSession.shared.data(for: request)
        validateResponse(response)
        guard let image = await UIImage(data: data)?.byPreparingThumbnail(ofSize: CGSize()) else {
            throw ThumbnailFailedError()
        }
        return image
    }
    
    func thumbnailURLRequest(for id: String) -> URLRequest {
        return URLRequest.self as! URLRequest
    }
    func validateResponse(_ response: URLResponse) {
    }
}
