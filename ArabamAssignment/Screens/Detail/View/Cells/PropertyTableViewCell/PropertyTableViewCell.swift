//
//  PropertyTableViewCell.swift
//  ArabamAssignment
//
//  Created by Muhammed Karakul on 12.01.2022.
//

import UIKit

final class PropertyTableViewCell: UITableViewCell {
    var key: String? {
        didSet {
            keyLabel.text = key
        }
    }
    
    var value: String? {
        didSet {
            valueLabel.text = value
        }
    }
    
    @IBOutlet private weak var keyLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
}
