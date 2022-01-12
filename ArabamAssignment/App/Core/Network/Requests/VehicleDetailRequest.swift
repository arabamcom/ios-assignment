//
//  VehicleDetailRequest.swift
//  ArabamAssignment
//
//  Created by Muhammed Karakul on 12.01.2022.
//

import Foundation

struct VehicleDetailRequest: DataRequest {
    var id: Int
    
    var baseURL: String {
        "http://sandbox.arabamd.com/api/v1"
    }
    
    var url: String {
        "/detail"
    }
    
    var queryItems: [String : String] {
        ["id": String(id)]
    }
    
    var method: HTTPMethod {
        .get
    }
    
    func decode(_ data: Data) throws -> VehicleDetail {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let response = try decoder.decode(VehicleDetail.self, from: data)
        return response
    }
}
