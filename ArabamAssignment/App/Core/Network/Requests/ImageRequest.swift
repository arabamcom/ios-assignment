//
//  ImageRequest.swift
//  ArabamAssignment
//
//  Created by Muhammed Karakul on 11.01.2022.
//

import UIKit

struct ImageRequest: DataRequest {
    var baseURL: String {
        ""
    }
    
    let url: String
    
    var method: HTTPMethod {
        .get
    }
    
    func decode(_ data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw NSError(
                domain: ErrorResponse.invalidResponse.rawValue,
                code: 13,
                userInfo: nil
            )
        }
        
        return image
    }
}
