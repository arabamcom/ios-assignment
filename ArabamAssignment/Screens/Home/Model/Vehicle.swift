//
//  Vehicle.swift
//  ArabamAssignment
//
//  Created by Muhammed Karakul on 11.01.2022.
//

import Foundation

// MARK: - WelcomeElement
struct Vehicle: Codable {
    let id: Int
    let title: String
    let location: Location
    let category: Category
    let modelName: String
    let price: Int
    let priceFormatted, date, dateFormatted, photo: String
    let properties: [Property]
}

// MARK: - Category
struct Category: Codable {
    let id: Int
    let name: String
}

// MARK: - Location
struct Location: Codable {
    let cityName, townName: String
}

// MARK: - Property
struct Property: Codable {
    let name, value: String
}

typealias VehicleResponse = [Vehicle]
