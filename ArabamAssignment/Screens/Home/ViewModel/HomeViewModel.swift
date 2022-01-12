//
//  HomeViewModel.swift
//  ArabamAssignment
//
//  Created by Muhammed Karakul on 11.01.2022.
//

import UIKit

protocol HomeViewModelProtocol {
    var vehicleList: VehicleResponse { set get }
    var numberOfRows: Int { get }
    var onFetchVehicleListSucceed: (() -> Void)? { set get }
    var onFetchVehicleListFailure: ((Error) -> Void)? { set get }
    var onDownloadVehiclePhotoSucceed: ((IndexPath) -> Void)? { set get }
    var onDownloadVehiclePhotoFailure: ((Error) -> Void)? { set get }
    func fetchVehicleList()
    func configureVehicleTableViewCell(_ cell: VehicleTableViewCell, forIndexPath indexPath: IndexPath)
    func vehicleId(for indexPath: IndexPath) -> Int
}

final class HomeViewModel: BaseViewModel, HomeViewModelProtocol {
    
    var vehicleList: VehicleResponse = []
    
    var numberOfRows: Int {
        vehicleList.count
    }
    
    var request = VehicleListRequest()
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    var onFetchVehicleListSucceed: (() -> Void)?
    
    var onFetchVehicleListFailure: ((Error) -> Void)?
    
    var onDownloadVehiclePhotoSucceed: ((IndexPath) -> Void)?
    
    var onDownloadVehiclePhotoFailure: ((Error) -> Void)?
    
    func fetchVehicleList() {
        networkService.request(request) { result in
            switch result {
            case .success(let vehicleList):
                self.vehicleList = vehicleList
                DispatchQueue.main.async {
                    self.onFetchVehicleListSucceed?()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.onFetchVehicleListFailure?(error)
                }
            }
        }
        request.currentPage += 1
    }
    
    func configureVehicleTableViewCell(_ cell: VehicleTableViewCell, forIndexPath indexPath: IndexPath) {
        let vehicle = vehicleList[indexPath.row]
        cell.title = vehicle.title
        cell.location = vehicle.location
        cell.price = vehicle.price as NSNumber
        
        let imageRequest = ImageRequest(url: vehicle.photo.replacingOccurrences(of: "{0}", with: "240x180"))
        
        cell.vehicleImage = nil
        
        if let imageFromCache = imageCache.object(forKey: imageRequest.url as AnyObject) as? UIImage {
            cell.vehicleImage = imageFromCache
            return
        }
        
        imageClientService.downloadImage(request: imageRequest, completion: { image, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.onDownloadVehiclePhotoFailure?(error)
                }
                return
            }
            guard let image = image else { return }
            DispatchQueue.main.sync {
                cell.vehicleImage = image
                self.imageCache.setObject(image, forKey: imageRequest.url as AnyObject)
                self.onDownloadVehiclePhotoSucceed?(indexPath)
            }
        })
    }
    
    func vehicleId(for indexPath: IndexPath) -> Int {
        vehicleList[indexPath.row].id
    }
}
