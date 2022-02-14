//
//  DetailViewController.swift
//  ShootAndSave
//
//  Created by Alexander Filippov on 13.2.22..
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var detailImageView: UIImageView!
    var selectedImage: String?
    var nameLabel: String?
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let photo = Photo(photoImageName: selectedImage ?? "", nameLabel: nameLabel ?? "None1")
        title = photo.nameLabel
        
        detailImageView.contentMode = .scaleAspectFit
        
        let path = getDocumentsDirectory().appendingPathComponent(photo.photoImageName)
        detailImageView.image = UIImage(contentsOfFile: path.path)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

}
