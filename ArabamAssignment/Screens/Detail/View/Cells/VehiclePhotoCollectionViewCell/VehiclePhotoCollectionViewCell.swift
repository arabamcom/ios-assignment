//
//  VehiclePhotoCollectionViewCell.swift
//  ArabamAssignment
//
//  Created by Muhammed Karakul on 12.01.2022.
//

import UIKit

final class VehiclePhotoCollectionViewCell: UICollectionViewCell {
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    @IBOutlet private weak var imageView: UIImageView!
}
