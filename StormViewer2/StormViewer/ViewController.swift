//
//  ViewController.swift
//  StormViewer
//
//  Created by Alexander Filippov on 17.1.22..
//

import UIKit

class ViewController: UICollectionViewController {
    
    var pictures = [String]()
//    var pictureNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        
        performSelector(inBackground: #selector(loadImages), with: nil)
    }

    // MARK: - Collection view data source

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return pictures.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? PictureCell else {
            fatalError("Unable to dequeue PictureCell.")
        }

        cell.layer.borderColor = UIColor(white: 0, alpha: 1).cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 7
        cell.imageView.layer.cornerRadius = 4
        cell.imageView.contentMode = .scaleAspectFill
        cell.backgroundColor = .cyan
        cell.imageView.image = UIImage(named: pictures[indexPath.row])
        cell.name.text = pictures[indexPath.row]

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {

            vc.selectedImage = pictures[indexPath.row]
            vc.pictures = self.pictures
            
            navigationController?.pushViewController(vc,  animated: true)
        }
    }
    
    @objc func loadImages() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
                
        pictures.sort()
        collectionView.performSelector(onMainThread: #selector(UICollectionView.reloadData), with: nil, waitUntilDone: false)
    }
    
    @objc func share() {
        let invite = "Please, check my application Storm Viewer!"
        let vc = UIActivityViewController(activityItems: [invite], applicationActivities:[])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
