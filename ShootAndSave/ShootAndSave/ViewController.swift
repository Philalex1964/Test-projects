//
//  ViewController.swift
//  ShootAndSave
//
//  Created by Alexander Filippov on 13.2.22..
//

import UIKit

struct Photo: Codable, Equatable {
    var photoImageName: String
    var nameLabel: String
}

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shoot-n-Save"
        
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
        cell.photoName.text = photo.nameLabel
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var photo = photos[indexPath.row]
        
        let fullPhoto = UIAlertAction(title: "See full photo", style: .default) { [weak self] _ in
            if let vc = self?.storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
                vc.selectedImage = self?.photos[indexPath.row].photoImageName
                vc.photos = self!.photos
                vc.nameLabel = self?.photos[indexPath.row].nameLabel
                
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        let rename = UIAlertAction(title: "Rename photo", style: .default) { [weak self] _ in
            let ac = UIAlertController(title: "Rename", message: nil, preferredStyle: .alert)
            ac.addTextField()
            
            ac.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
                guard let newName = ac.textFields?[0].text else { return }
//                photo.nameLabel = newName
                
                if photo.photoImageName.contains(photo.photoImageName) {
                    guard let indexToRemove = self?.photos.firstIndex(of: photo)
                    else { return }
                    
                    self?.photos.remove(at: indexToRemove)
                    
                    guard let newName = ac.textFields?[0].text else { return }
                    
                    photo.nameLabel = newName
                    
                    self?.photos.insert(photo, at: indexToRemove)
                    self?.save()
                    
                    self?.tableView.reloadData()
                }

//                guard let indexToRemove = self?.photos.firstIndex(of: photoToRemove)
//                else { return }
//
//                self?.photos.remove(at: indexToRemove)
//                self?.photos.insert(photo, at: indexToRemove)
//                self?.save()
//
//                self?.tableView.reloadData()
                
            })
            
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self?.present(ac, animated: true)
        }
        
        let delete = UIAlertAction(title: "Delete photo", style: .default) { [weak self] _ in
            guard let indexToRemove = self?.photos.firstIndex(of: photo) else { return }
            self?.photos.remove(at: indexToRemove)
            self?.save()
            
            self?.tableView.reloadData()
            
        }
        
        let ac = UIAlertController(title: "Choose action", message: nil, preferredStyle: .alert)
        
        ac.addAction(fullPhoto)
        ac.addAction(rename)
        ac.addAction(delete)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
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
