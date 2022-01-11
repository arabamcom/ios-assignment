//
//  VehicleListRequest.swift
//  ArabamAssignment
//
//  Created by Muhammed Karakul on 11.01.2022.
//

import Foundation

struct VehicleListRequest: DataRequest {
    private let pageLength: Int32 = 10
    private var currentPageLenght: Int32 = 10
    private var nextPageLenght: Int32 = 10
    
    var sort: Int32 = .zero
    var sortDirection: Int32 = .zero
    var currentPage: Int32 = .zero {
        didSet {
            currentPageLenght = nextPageLenght
            nextPageLenght += pageLength
        }
    }
    
    var baseURL: String {
        "http://sandbox.arabamd.com/api/v1"
    }
    
    var url: String {
        "/listing"
    }
    
    var queryItems: [String : String] {
        ["sort": String(sort),
         "sortDirection": String(sortDirection),
         "skip": String(currentPageLenght),
         "take": String(nextPageLenght)]
    }
    
    var method: HTTPMethod {
        .get
    }
    
    func decode(_ data: Data) throws -> VehicleResponse {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let response = try decoder.decode(VehicleResponse.self, from: data)
        return response
    }
}
