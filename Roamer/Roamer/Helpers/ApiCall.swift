//
//  ApiCall.swift
//  Roamer
//
//  Created by Ivona Perko on 07.05.2024..
//

import Alamofire
import Combine

class APICall {
    static func requestObservable<T: Codable> (url: String,
                                               method: HTTPMethod,
                                               params: Parameters?,
                                               headers: HTTPHeaders? = nil,
                                               encoding: ParameterEncoding = URLEncoding.default) -> AnyPublisher<T, AFError> {
        Deferred {
            Future { promise in
                APICall.request(url: url,
                                method: method,
                                params: params) { (result: Result<T, AFError>) in
                    print(result)
                    switch result {
                    case let .success(decodedObject):
                        promise(.success(decodedObject))
                    case let .failure(error):
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    @discardableResult
            static func request<T: Codable> (url: String,
                                             method: HTTPMethod,
                                             params: Parameters?,
                                             headers: HTTPHeaders? = nil,
                                             encoding: ParameterEncoding = URLEncoding.default,
                                             using completion: @escaping ((Result<T, AFError>) -> Void)) -> DataRequest? {
                AF.request(url,
                           method: method,
                           parameters: params,
                           encoding: encoding,
                           headers: headers)
                .validate()
                .responseDecodable(of: T.self, completionHandler: { response in
                    completion(response.result)
                })
            }
}
