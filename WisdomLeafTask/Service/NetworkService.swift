//
//  NetworkService.swift
//  WisdomLeafTask
//
//  Created by Sai Balaji on 25/06/24.
//

import Foundation

struct Constants{
    static let BASE_URL = "https://picsum.photos/v2/list"
}

//MARK: - CUSTOM ERROR ENUM 
enum NetworkServiceError: Error{
    case invalidURL
    case invalidResponse
    case invalidStatusCode(code: Int)
    case decodingError(error: DecodingError)
}


//MARK: - CUSTOM ERROR MESSAGES
extension NetworkServiceError: LocalizedError{
    var errorDescription: String?{
        switch self {
        case .invalidURL:
            return "The Given URL is invalid"
        case .invalidResponse:
            return "Invalid response from the server"
        case .invalidStatusCode(let code):
            return "Invalid Status Code \(code)"
        case .decodingError(error: let error):
            return "Decoding Error: \(error)"
        }
    }
}


class NetworkService{
    //MARK: - PROPERTIES
    private init(){}
    static let shared = NetworkService()
    private var session = URLSession(configuration: .default)
    
    //MARK: - SEND GET REQUEST TO THE SERVER
    func sendGETRequest<T: Codable>(url: String,responseType: T.Type)async -> Result<T,Error>{
        guard let url = URL(string: url)else{return .failure(NetworkServiceError.invalidURL)}
        var request  = URLRequest(url: url)
        request.httpMethod = "GET"
        do{
            let (data,response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else{return .failure(NetworkServiceError.invalidResponse)}
            if (200...299).contains(httpResponse.statusCode) == false{return .failure(NetworkServiceError.invalidStatusCode(code: httpResponse.statusCode))}
            do{
                let decodedData =  try JSONDecoder().decode(responseType.self, from: data)
                return .success(decodedData)
            }
            catch let error as DecodingError{
                return .failure(NetworkServiceError.decodingError(error: error))
            }
         
        }
        catch{
           
            return .failure(error)
        }
       
        
    }
}
