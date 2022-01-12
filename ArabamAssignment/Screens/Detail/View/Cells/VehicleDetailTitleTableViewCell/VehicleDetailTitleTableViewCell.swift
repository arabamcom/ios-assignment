//
//  VehicleDetailTitleTableViewCell.swift
//  ArabamAssignment
//
//  Created by Muhammed Karakul on 11.01.2022.
//

import UIKit

protocol VehicleDetailTitleTableViewCellDelegate: AnyObject {
    func didChangeCurrentSegment(_ segment: VehicleDetailTitleTableViewCell.Segment)
}

final class VehicleDetailTitleTableViewCell: UITableViewCell {
    weak var delegate: VehicleDetailTitleTableViewCellDelegate?
    
    var username: String? {
        didSet {
            usernameLabel.text = username
        }
    }
    
    var category: Category? {
        didSet {
            categoryLabel.text = category?.name
        }
    }
    
    var location: Location? {
        didSet {
            locationLabel.text = "\(location?.cityName ?? "-"), \(location?.townName ?? "-")"
        }
    }
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.register(UINib(nibName: "VehiclePhotoCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "VehiclePhotoCollectionViewCell")
    }
    
    @IBAction private func didChangeSegment(_ sender: UISegmentedControl) {
        delegate?.didChangeCurrentSegment(Segment(rawValue: sender.selectedSegmentIndex) ?? .advertInfo)
    }
    
    func setCollectionViewDelegate(_ delegate: UICollectionViewDelegateFlowLayout, andDataSource dataSource: UICollectionViewDataSource) {
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}

// MARK: - Enums
extension VehicleDetailTitleTableViewCell {
    enum Segment: Int {
        case advertInfo
        case description
    }
}
