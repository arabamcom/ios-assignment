//
//  VehicleTableViewCell.swift
//  ArabamAssignment
//
//  Created by Muhammed Karakul on 10.01.2022.
//

import UIKit

final class VehicleTableViewCell: UITableViewCell {
    var vehicleImage: UIImage? {
        didSet {
            vehicleImageView.image = vehicleImage
        }
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var location: Location? {
        didSet {
            locationLabel.text = "\(location?.cityName ?? "-"), \(location?.townName ?? "-")"
        }
    }
    
    var price: NSNumber? {
        didSet {
            guard let price = price else { return }
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: "tr_TR")
            priceLabel.text = formatter.string(from: price)
        }
    }
    
    @IBOutlet private weak var vehicleImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
}
