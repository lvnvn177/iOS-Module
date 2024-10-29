//
//  File.swift
//  
//
//  Created by 이영호 on 10/27/24.
//

import Alamofire

public class ApiManager {
    public init() {}
    
    /// Generic API 호출 메서드
    /// - Parameters:
    ///   - url: API의 URL
    ///   - parameters: URL에 추가할 쿼리 파라미터들 (기본값: nil)
    ///   - method: HTTP 메서드, 기본값은 `.get`
    ///   - completion: 결과를 반환할 클로저
    public func request<T: Decodable>(
        url: String,
        parameters: [String: Any]? = nil,
        method: HTTPMethod = .get,
        headers: HTTPHeaders,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        AF.request(url, method: method, parameters: parameters, headers: headers)
            .validate() // 요청이 성공적으로 처리되었는지 확인
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data)) // 성공 결과를 전달
                case .failure(let error):
                    completion(.failure(error)) // 실패 결과를 전달
                }
            }
    }
}
