//
//  HomeViewController.swift
//  ArabamAssignment
//
//  Created by Muhammed Karakul on 9.01.2022.
//

import UIKit

final class HomeViewController: BaseViewController {
    private let viewModel = HomeViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Araçlar"
        
        tableView.register(UINib(nibName: "VehicleTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "VehicleTableViewCell")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapGestureRecognized(_:)))
        tableView.addGestureRecognizer(tapGestureRecognizer)
        
        viewModel.fetchVehicleList()
        
        viewModel.onFetchVehicleListSucceed = {
            self.tableView.reloadData()
        }
        
        viewModel.onFetchVehicleListFailure = { error in
            self.showError(error)
        }
        
        viewModel.onDownloadVehiclePhotoFailure = { error in
            self.showError(error)
        }
    }
    
    @objc
    private func didTapGestureRecognized(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: tapLocation) {
            let detailViewModel = DetailViewModel(id: viewModel.vehicleId(for: indexPath))
            let detailViewController = DetailViewController(viewModel: detailViewModel)
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == viewModel.numberOfRows {
            viewModel.fetchVehicleList()
        }
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleTableViewCell", for: indexPath) as! VehicleTableViewCell
        viewModel.configureVehicleTableViewCell(cell, forIndexPath: indexPath)
        return cell
    }
}
