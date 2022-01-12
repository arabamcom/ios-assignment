//
//  DetailViewController.swift
//  ArabamAssignment
//
//  Created by Muhammed Karakul on 11.01.2022.
//

import UIKit

final class DetailViewController: BaseViewController {
    private var viewModel: DetailViewModel? {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet private weak var tableView: UITableView!

    convenience init(viewModel: DetailViewModel?) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "İlan Detayı"
        
        tableView.register(UINib(nibName: "VehicleDetailTitleTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "VehicleDetailTitleTableViewCell")
        
        tableView.register(UINib(nibName: "PropertyTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "PropertyTableViewCell")
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        viewModel?.fetchVehicleDetail()
        
        viewModel?.onFetchVehicleDetailSucceed = {
            self.tableView.reloadData()
        }
        
        viewModel?.onFetchVehicleDetailFailure = { error in
            self.showError(error)
        }
        
        viewModel?.onDownloadVehiclePhotoSucceed = {
            self.tableView.reloadRows(at: [IndexPath(row: .zero, section: .zero)], with: .automatic)
        }
        
        viewModel?.onDownloadVehiclePhotoFailure = { error in
            self.showError(error)
        }
    }
}

// MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .title:
            return 1
        case .property:
            return viewModel?.numberOfRows ?? .zero
        case .none:
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section) {
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleDetailTitleTableViewCell", for: indexPath) as! VehicleDetailTitleTableViewCell
            cell.setCollectionViewDelegate(self, andDataSource: self)
            cell.delegate = self
            viewModel?.configureVehicleDetailTitleTableViewCell(cell, forIndexPath: indexPath)
            return cell
        case .property:
            switch viewModel?.currentSegment {
            case .advertInfo:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyTableViewCell", for: indexPath) as! PropertyTableViewCell
                viewModel?.configurePropertyTableViewCell(cell, forIndexPath: indexPath)
                return cell
            case .description:
                let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
                cell.textLabel?.text = viewModel?.vehicleDetail?.text
                cell.textLabel?.numberOfLines = .zero
                return cell
            default:
                return UITableViewCell()
            }
        case .none:
            return UITableViewCell()
        }
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.frame.size
    }
}

// MARK: - UICollectionViewDataSource
extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.numberOfItemsInSection ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VehiclePhotoCollectionViewCell", for: indexPath) as! VehiclePhotoCollectionViewCell
        viewModel?.configureVehiclePhotoCollectionViewCell(cell, forIndexPath: indexPath)
        return cell
    }
}

// MARK: - Enums
extension DetailViewController {
    private enum Section: Int, CaseIterable {
        case title
        case property
    }
}

// MARK: - VehicleDetailTitleTableViewCellDelegate
extension DetailViewController: VehicleDetailTitleTableViewCellDelegate {
    func didChangeCurrentSegment(_ segment: VehicleDetailTitleTableViewCell.Segment) {
        viewModel?.currentSegment = segment
        tableView.reloadData()
    }
}
