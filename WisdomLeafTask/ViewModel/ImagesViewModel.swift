//
//  ImagesViewModel.swift
//  WisdomLeafTask
//
//  Created by Sai Balaji on 25/06/24.
//

import Foundation
import Combine



class ImagesViewModel: ObservableObject{
    //MARK: - PROPERTIES
    @Published var images = [Image]()
    @Published var error: Error?
    var isLoading = false
    var currentPage = 1
    
    //MARK: - GET THE IMAGES FROM API FOR GIVEN PAGE COUNT
    func getImages(pageCount: Int){
        
        if isLoading{
            return
        }
        self.isLoading = true
        var urlComponets = URLComponents(string: "\(Constants.BASE_URL)")
        urlComponets?.queryItems = [URLQueryItem(name: "page", value: "\(pageCount)"),
                                    URLQueryItem(name: "limit", value: "20")]
        //print("URL IS \(urlComponets?.url?.absoluteString)")
        if let finalURL = urlComponets?.url?.absoluteString{
            Task{
                let result = await NetworkService.shared.sendGETRequest(url: finalURL, responseType: [Image].self)
                switch result{
                    case .success(let response):
                  //  if let images = response{
                            self.images += response
                            self.isLoading = false
                     //   }
                        break
                    case .failure(let error):
                        self.error = error
                        self.isLoading = false
                        break
                }
            }
        }
        
    }
    
}
