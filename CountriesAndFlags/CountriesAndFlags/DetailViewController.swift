//
//  DetailViewController.swift
//  CountriesAndFlags
//
//  Created by Alexander Filippov on 19.1.22..
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var flagImageView: UIImageView!
    var selectedCountry: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        flagImageView.layer.borderWidth = 1
        flagImageView.layer.borderColor = UIColor.darkGray.cgColor
        title = selectedCountry?.uppercased()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        view.backgroundColor = .lightGray
        
        if let imageToLoad = selectedCountry {
            flagImageView.image = UIImage(named: imageToLoad)
        }
    }
    
    @objc func shareTapped() {
        guard let image = flagImageView.image?.jpegData(compressionQuality: 0.8),
              let imageName = selectedCountry?.uppercased()
        else {
            print("No country found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image, imageName], applicationActivities:[])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)

    }

}
