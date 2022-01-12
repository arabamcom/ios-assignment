//
//  DetailViewModel.swift
//  ArabamAssignment
//
//  Created by Muhammed Karakul on 11.01.2022.
//

import UIKit

protocol DetailViewModelProtocol {
    var vehicleDetail: VehicleDetail? { set get }
    var numberOfRows: Int { get }
    var numberOfItemsInSection: Int { get }
    var onFetchVehicleDetailSucceed: (() -> Void)? { set get }
    var onFetchVehicleDetailFailure: ((Error) -> Void)? { set get }
    var onDownloadVehiclePhotoSucceed: (() -> Void)? { set get }
    var onDownloadVehiclePhotoFailure: ((Error) -> Void)? { set get }
    func fetchVehicleDetail()
    func configureVehicleDetailTitleTableViewCell(_ cell: VehicleDetailTitleTableViewCell, forIndexPath indexPath: IndexPath)
    func configureVehiclePhotoCollectionViewCell(_ cell: VehiclePhotoCollectionViewCell, forIndexPath indexPath: IndexPath)
    func configurePropertyTableViewCell(_ cell: PropertyTableViewCell, forIndexPath indexPath: IndexPath)
    
}

final class DetailViewModel: BaseViewModel, DetailViewModelProtocol {
    
    var vehicleDetail: VehicleDetail?
    
    var currentSegment: VehicleDetailTitleTableViewCell.Segment = .advertInfo
    
    var numberOfRows: Int {
        switch currentSegment {
        case .advertInfo:
            guard let properties = vehicleDetail?.properties else {
                return .zero
            }
            return properties.count
        case .description:
            return 1
        }
    }
    
    var numberOfItemsInSection: Int {
        guard let photos = vehicleDetail?.photos else {
            return .zero
        }
        return photos.count
    }
    
    var onFetchVehicleDetailSucceed: (() -> Void)?
    
    var onFetchVehicleDetailFailure: ((Error) -> Void)?
    
    var onDownloadVehiclePhotoSucceed: (() -> Void)?
    
    var onDownloadVehiclePhotoFailure: ((Error) -> Void)?
    
    var request: VehicleDetailRequest { VehicleDetailRequest(id: id) }
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    private let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    func fetchVehicleDetail() {
        networkService.request(request) { result in
            switch result {
            case .success(let vehicleDetail):
                self.vehicleDetail = vehicleDetail
                DispatchQueue.main.async {
                    self.onFetchVehicleDetailSucceed?()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.onFetchVehicleDetailFailure?(error)
                }
            }
        }
    }
    
    func configureVehicleDetailTitleTableViewCell(_ cell: VehicleDetailTitleTableViewCell, forIndexPath indexPath: IndexPath) {
        cell.username = vehicleDetail?.userInfo.nameSurname
        cell.category = vehicleDetail?.category
        cell.location = vehicleDetail?.location
        cell.reloadData()
    }
    
    func configureVehiclePhotoCollectionViewCell(_ cell: VehiclePhotoCollectionViewCell, forIndexPath indexPath: IndexPath) {
        guard let photo = vehicleDetail?.photos[indexPath.row] else { return }
        
        let imageRequest = ImageRequest(url: photo.replacingOccurrences(of: "{0}", with: "580x435"))
        
        cell.image = nil
        
        if let imageFromCache = imageCache.object(forKey: imageRequest.url as AnyObject) as? UIImage {
            cell.image = imageFromCache
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
                cell.image = image
                self.imageCache.setObject(image, forKey: imageRequest.url as AnyObject)
                self.onDownloadVehiclePhotoSucceed?()
            }
        })
    }
    
    func configurePropertyTableViewCell(_ cell: PropertyTableViewCell, forIndexPath indexPath: IndexPath) {
        guard let properties = vehicleDetail?.properties else { return }
        cell.key = properties[indexPath.row].name
        cell.value = properties[indexPath.row].value
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = .white
        } else {
            cell.backgroundColor = .init(white: 0.9, alpha: 1.0)
        }
    }
}
