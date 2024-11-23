//
//  File.swift
//  
//
//  Created by 이영호 on 10/27/24.
//

import Alamofire
import Foundation

public class ApiManager {
    public init() {}
    
    /// Generic API 호출 메서드
    /// - Parameters:
    ///   - url: API의 URL
    ///   - parameters: URL에 추가할 쿼리 파라미터들 (기본값: nil)
    ///   - method: HTTP 메서드, 기본값은 `.get`
    ///   - headers: HTTP 헤더
    ///   - config: URLSessionConfiguration
    ///   - completion: 결과를 반환할 클로저
    public func request<T: Decodable>(
        url: String,
        parameters: [String: Any]? = nil,
        method: HTTPMethod = .get,
        headers: HTTPHeaders,
        config: URLSessionConfiguration = .default,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        // Alamofire 세션 매니저 생성
        let session = Session(configuration: config)
        
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
