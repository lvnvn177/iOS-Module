//
//  File.swift
//  
//
//  Created by 이영호 on 10/27/24.
//

import Alamofire
import Foundation

public class ApiManager {
    // Session을 클래스 프로퍼티로 유지
    private let session: Session
    
    public init() {
        let configuration = URLSessionConfiguration.default
        self.session = Session(configuration: configuration)
    }
    
    public func request<T: Decodable>(
        url: String,
        parameters: [String: Any]? = nil,
        method: HTTPMethod = .get,
        headers: HTTPHeaders,
        config: URLSessionConfiguration = .default,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        // 기존 session 대신 클래스의 session 프로퍼티 사용
        session.request(url,
                       method: method,
                       parameters: parameters,
                       headers: headers)
        .validate()
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
