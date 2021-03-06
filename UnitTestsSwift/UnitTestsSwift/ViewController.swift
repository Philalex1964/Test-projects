//
//  ViewController.swift
//  UnitTestsSwift
//
//  Created by Aleksandar Filipov on 6/15/22.
//

import UIKit

class ViewController: UITableViewController {
    
    var playData = PlayData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        
//        updateNameSync()
//        updateName()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return playData.allWords.count
        return playData.filteredWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //        let word = playData.allWords[indexPath.row]
        let word = playData.filteredWords[indexPath.row]
        cell.textLabel!.text = word
        cell.detailTextLabel!.text = "\(playData.wordCounts.count(for: word))"
        return cell
    }
    
    @objc func searchTapped() {
        let ac = UIAlertController(title: "Filter...", message: nil, preferredStyle: .alert)
        
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Filter", style: .default) { [unowned self] _ in
            let userInput = ac.textFields?[0].text ?? "0"
            self.playData.applyUserFilter(userInput)
            self.tableView.reloadData()
        })
                     
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
// Data Race
//    private var name: String = ""
//
//    func updateName() {
//        DispatchQueue.global().async {
//            self.name.append("Alex Petrov")
//        }
//
//        print(self.name)
//    }
//
//    private let lockQueue = DispatchQueue(label: "name.lock.queue")
//    private var name: String = "Antoine van der Lee"
//
//    func updateNameSync() {
//        DispatchQueue.global().async {
//            self.lockQueue.async {
//                self.name.append("Antoine van der Lee")
//            }
//        }
//
//        // Executed on the Main Thread
//        lockQueue.async {
//            // Executed on the lock queue
//            print(self.name)
//        }
//    }
//
//    // Prints:
//    // Antoine van der Lee
//    // Antoine van der Lee
}
