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
    
//    コールバックによる非同期
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
    
    func thumbnailURLRequest(for id: String) -> URLRequest {
        return URLRequest.self as! URLRequest
    }

//    Concurrencyを使った非同期
    func asyncFetchThumbnail(for id: String) async throws -> UIImage {
        let request = thumbnailURLRequest(for: id)
        let (data, response) = try await URLSession.shared.data(for: request)
        validateResponse(response)
        guard let image = await UIImage(data: data)?.byPreparingThumbnail(ofSize: CGSize()) else {
            throw ThumbnailFailedError()
        }
        return image
    }
    
    func validateResponse(_ response: URLResponse) {
    }
    
//    既存のコールバックベースの非同期APIを変換する時
    func fetchMyData() async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            fetchDataAsync { result in
                switch result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func fetchDataAsync(completion: @escaping (Result<Data, Error>) -> Void) {
    }
}
