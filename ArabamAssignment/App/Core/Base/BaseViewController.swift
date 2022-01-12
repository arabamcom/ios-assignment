//
//  BaseViewController.swift
//  ArabamAssignment
//
//  Created by Muhammed Karakul on 12.01.2022.
//

import UIKit

class BaseViewController: UIViewController {
    func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Hata",
                                                message: "Servis isteği sırasında bir hata oluştu.\n Hata: \(error.localizedDescription)",
                                                preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "TAMAM", style: .default)
        alertController.addAction(defaultAction)
        present(alertController, animated: true)
    }
}
