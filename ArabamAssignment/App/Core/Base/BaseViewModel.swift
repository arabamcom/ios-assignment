//
//  BaseViewModel.swift
//  ArabamAssignment
//
//  Created by Muhammed Karakul on 11.01.2022.
//

import Foundation

class BaseViewModel {
    var networkService: NetworkService
    var imageClientService: ImageClientService
    
    init(networkService: NetworkService = BaseNetworkService(),
         imageClientService: ImageClientService = BaseImageClientService()) {
        self.networkService = networkService
        self.imageClientService = imageClientService
    }
}
