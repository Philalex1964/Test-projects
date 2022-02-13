//
//  ViewController.swift
//  ShootAndSave
//
//  Created by Alexander Filippov on 13.2.22..
//

import UIKit

struct Photo: Codable {
    var photoImageName: String
    var nameLabel: String
}

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(addPhoto))
        
        loadSavedPhotos()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let photo = Photo(photoImageName: imageName, nameLabel: "None")
        photos.append(photo)
        save()
        
        tableView.reloadData()
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(photos) {
            let defaults = UserDefaults.standard
            
            defaults.set(savedData, forKey: "photos")
        } else {
            print("Failed to save photo")
        }
    }
    
    func loadSavedPhotos() {
        let defaults = UserDefaults.standard
        
        if let savedPhotos = defaults.object(forKey: "photos") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                photos = try jsonDecoder.decode([Photo].self, from: savedPhotos)
            } catch {
                print("Failed to load photos")
            }
        }
        
    }
    
    func pickerChoice(_ picker: UIImagePickerController, hasCamera: Bool) {
        if hasCamera {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Photo", for: indexPath) as? PhotoCell else {
            fatalError("Unable to dequeue PhotoCell.")
        }
        
        let photo = photos[indexPath.row]
        
        cell.photoName.text = photo.nameLabel
        
        let path = getDocumentsDirectory().appendingPathComponent(photo.photoImageName)
        cell.photoImageView.image = UIImage(contentsOfFile: path.path)
        
        return cell
    }
    
    // MARK: - @objc Methods
    
    @objc func addPhoto() {
        let hasCamera = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        let ac = UIAlertController(title: "Add photo", message: nil, preferredStyle: .alert)
        let picker = UIImagePickerController()
        
        if hasCamera {
            let camera = UIAlertAction(title: "Take new photo", style: .default) { [weak self] _ in
                self?.pickerChoice(picker, hasCamera: true)
            }
            
            let photo = UIAlertAction(title: "Choose from library", style: .default) { [weak self] _ in
                self?.pickerChoice(picker, hasCamera: false)
            }
            
            ac.addAction(camera)
            ac.addAction(photo)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(ac, animated: true)
        } else {
            pickerChoice(picker, hasCamera: false)
        }
    }
}
