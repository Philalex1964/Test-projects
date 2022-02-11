//
//  ViewController.swift
//  StormViewer
//
//  Created by Alexander Filippov on 17.1.22..
//

import UIKit

struct Picture: Codable, Comparable {
    static func < (lhs: Picture, rhs: Picture) -> Bool {
        return lhs.pictureName < rhs.pictureName
    }
    
    var pictureName: String
    var viewsCount: Int
}

class ViewController: UITableViewController {
    
    var pictures = [Picture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        
        performSelector(inBackground: #selector(loadImages), with: nil)
        
        let defaults = UserDefaults.standard

        if let savedData  = defaults.object(forKey:  "pictures") as? Data {
            let jsonDecoder = JSONDecoder()

            do {
                pictures = try jsonDecoder.decode([Picture].self, from: savedData)
            } catch {
                print("Failed to load picture")
            }
            print(pictures)
        }
    }
    func saveViews() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            
            defaults.set(savedData, forKey: "pictures")
        } else {
            print("Failed to save pictures")
        }
        print(pictures)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row].pictureName
        cell.detailTextLabel?.text = "Views: \(pictures[indexPath.row].viewsCount)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pictures[indexPath.row].viewsCount += 1
        saveViews()
        tableView.reloadData()
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row].pictureName
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
                let picture = Picture(pictureName: item, viewsCount: 0)
                if !pictures.contains(picture) {
                    pictures.append(picture)
                }
            }
        }

        pictures.sort {
            $0.pictureName < $1.pictureName
        }
        
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    @objc func share() {
        let invite = "Please, check my application Storm Viewer!"
        let vc = UIActivityViewController(activityItems: [invite], applicationActivities:[])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
