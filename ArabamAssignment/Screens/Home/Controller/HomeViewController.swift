//
//  HomeViewController.swift
//  ArabamAssignment
//
//  Created by Muhammed Karakul on 9.01.2022.
//

import UIKit

final class HomeViewController: UIViewController {
    private let viewModel = HomeViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        tableView.register(UINib(nibName: "VehicleTableViewCell", bundle: nil), forCellReuseIdentifier: "VehicleTableViewCell")
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
    
    private func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Hata",
                                                message: "Servis isteği sırasında bir hata oluştu.\n Hata: \(error.localizedDescription)",
                                                preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "TAMAM", style: .default)
        alertController.addAction(defaultAction)
        present(alertController, animated: true)
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
