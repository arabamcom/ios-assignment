//
//  VehicleDetail.swift
//  ArabamAssignment
//
//  Created by Muhammed Karakul on 11.01.2022.
//

import Foundation

// MARK: - VehicleDetail
struct VehicleDetail: Codable {
    let id: Int
    let title: String
    let location: Location
    let category: Category
    let modelName: String
    let price: Int
    let priceFormatted, date, dateFormatted: String
    let photos: [String]
    let properties: [Property]
    let text: String
    let userInfo: UserInfo
}

// MARK: - UserInfo
struct UserInfo: Codable {
    let id: Int
    let nameSurname, phone, phoneFormatted: String
}
