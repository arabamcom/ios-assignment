//
//  ImageClient+ImageClientService.swift
//  ArabamAssignment
//
//  Created by Muhammed Karakul on 11.01.2022.
//

import UIKit

protocol ImageClientService {
    func downloadImage<Request: DataRequest>(request: Request, completion: @escaping (UIImage?, Error?) -> Void)
}

struct BaseImageClientService: ImageClientService {    
    func downloadImage<Request: DataRequest>(request: Request, completion: @escaping (UIImage?, Error?) -> Void) {
        
        let service: NetworkService = BaseNetworkService()
        
        service.request(request) { result in
            switch result {
            case .success(let response):
                guard let image: UIImage = response as? UIImage else {
                    return
                }
                completion(image, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
