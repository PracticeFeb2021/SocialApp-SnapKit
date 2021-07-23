//
//  NetworkManager.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import Foundation


public enum NetServiceError: Error {
    
    case network(Error)
    
    case decoding(Error)

    case unexpectedStatus(Int)
    
    /// contains optional error message
    case unknown(String?)
}

protocol NetworkingService {
    
    func loadPosts(_ completion: @escaping (Result<[Post], NetServiceError>) -> ())
    
    func loadUsers(_ completion: @escaping (Result<[User], NetServiceError>) -> ())
    
    func loadComments(_ completion: @escaping (Result<[Comment], NetServiceError>) -> ())
}

class NetworkManager: NetworkingService {
    static let shared = NetworkManager()
    
    func loadPosts(_ completion: @escaping (Result<[Post], NetServiceError>) -> ()) {
        load(.posts, completion)
    }
    
    func loadUsers(_ completion: @escaping (Result<[User], NetServiceError>) -> ()) {
        load(.users, completion)
    }
    
    func loadComments(_ completion: @escaping (Result<[Comment], NetServiceError>) -> ()) {
        load(.comments, completion)
    }
    
    
    //MARK: - private
    
    private func load<T: Decodable>(_ endPoint: EndPoint,
                                    _ completion: @escaping (Result<T, NetServiceError>) -> ()) {
        
        let request = endPoint.makeURLRequest()
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(.network(error)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  let data = data else {
                let message = "Fetch failed: \(error?.localizedDescription ?? "Unknown error")"
                completion(.failure(.unknown(message)))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.unexpectedStatus(httpResponse.statusCode)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch  {
                completion(.failure(.decoding(error)))
            }
        }.resume()
    }
}

