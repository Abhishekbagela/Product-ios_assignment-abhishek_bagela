//
//  ApiManager.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 29/01/25.
//

import Foundation
import UIKit

final class APIManager {
    static let shared = APIManager()
    private let session = URLSession.shared
    private let imageCache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    // MARK: - Fetch Data (GET Request)
    func fetchData<T: Codable>(from url: URL?, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = url else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.requestFailed(nil)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }
    
    // MARK: - FORM DATA - Send Data (POST Request)
    func sendFormData<T: Codable>(to url: URL?, data: T, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Convert Encodable Model to Dictionary
        guard let dictionaryData = try? data.asDictionary() else {
            completion(.failure(.encodingError(NSError(domain: "Encoding Error", code: -1, userInfo: nil))))
            return
        }
        
        var body = Data()
        
        for (key, value) in dictionaryData {
            if let stringValue = value as? String {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(stringValue)\r\n".data(using: .utf8)!)
            } else if let numberValue = value as? NSNumber {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(numberValue)\r\n".data(using: .utf8)!)
            }
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.requestFailed(nil)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                completion(.failure(.decodingError(error)))
            }

        }
        
        task.resume()
    }
    
    // MARK: - JSON Send Data (PUT Request)
    func sendJsonData<T: Encodable>(to urlString: String, data: T, completion: @escaping (Result<Void, APIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("form-data", forHTTPHeaderField: "Content-Type")
        request.setValue("form-data", forHTTPHeaderField: "Accept")
        
        do {
            let jsonData = try JSONEncoder().encode(data)
            
            //MARK: Debug
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("JSON Request Body: \(jsonString)")
            }
            request.httpBody = jsonData
        } catch {
            completion(.failure(.encodingError(error)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                print("Server Error: \(httpResponse.statusCode)") // Debugging
                completion(.failure(.serverError(httpResponse.statusCode)))
                return
            }
            
            completion(.success(()))
        }
        
        task.resume()
    }
    
    // MARK: - Download Image
    func downloadImage(from urlString: String, completion: @escaping (Result<UIImage, APIError>) -> Void) {
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            DispatchQueue.main.async {
                completion(.success(cachedImage))
            }
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode),
                  let data = data, let image = UIImage(data: data) else {
                completion(.failure(.imageDownloadFailed))
                return
            }
            
            self.imageCache.setObject(image, forKey: NSString(string: urlString))
            
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }
        
        task.resume()
    }
}

enum APIError: Error {
    case invalidURL
    case requestFailed(Error?)
    case decodingError(Error)
    case invalidResponse
    case imageDownloadFailed
    case encodingError(Error)
    case serverError(Int)
}
