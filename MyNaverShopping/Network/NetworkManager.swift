//
//  NetworkManager.swift
//  MyNaverShopping
//
//  Created by 이은서 on 2023/09/15.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() { }
    
        
    func callRequest(query: String, startPoint: Int = 1, sort: Sort = .sim, completionHandler: @escaping (Items) -> Void) {
        guard let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("텍스트 인코딩 실패")
            return }
        let baseURL = "https://openapi.naver.com/v1/search/shop.json?display=30&query=\(text)&sort=\(sort)"
        guard let url = URL(string: baseURL) else { return }
        
        let headers: HTTPHeaders = ["X-Naver-Client-Id": APIKey.naverID, "X-Naver-Client-Secret": APIKey.naverSecret]
        print(url)
        AF.request(url, method: .get, headers: headers).validate(statusCode: 200...600).responseDecodable(of: Items.self) { response in
            
            if let status = response.response?.statusCode {
                switch status {
                case 200..<300:
                    if let value = response.value {
                        completionHandler(value)
                    } else {
                        print(response.error)
                    }
                case 400..<500:
                    print("요청 에러: ", response.error ?? "")
                case 500..<600:
                    print("서버 에러: ", response.error ?? "")
                default:
                    print("기타 에러 발생: ", response.error ?? "")
                }
            }
        }
        
    }
}
