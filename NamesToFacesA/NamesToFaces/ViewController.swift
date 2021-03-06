//
//  ViewController.swift
//  NamesToFaces
//
//  Created by Alexander Filippov on 3.2.22..
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        let defaults = UserDefaults.standard
        
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople) as? [Person] {
                people = decodedPeople
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        save()
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        }
    }

    // Collection view
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac1 = UIAlertController(title: "What do you want?", message: nil, preferredStyle: .alert)
        
        ac1.addAction(UIAlertAction(title: "Rename picture", style: .default) { [weak self] _ in
            let ac = UIAlertController(title: "Rename picture", message: nil, preferredStyle: .alert)
            ac.addTextField()
            
            ac.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self, weak ac] action in
                guard let newName = ac?.textFields?[0].text else { return }
                person.name = newName
                self?.save()
            
                self?.collectionView.reloadData()
            })
            
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self?.present(ac, animated: true)
        })
        
        ac1.addAction(UIAlertAction(title: "Delete picture", style: .default) { [weak self] _ in
            guard let indexToRemove = self?.people.firstIndex(of: person) else { return }
            self?.people.remove(at: indexToRemove)
            
            self?.collectionView.reloadData()
        })
        
        ac1.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac1, animated: true)
    }
    
    // @objc methods
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
}
