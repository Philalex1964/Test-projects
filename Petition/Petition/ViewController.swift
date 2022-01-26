//
//  ViewController.swift
//  Petition
//
//  Created by Alexander Filippov on 25.1.22..
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString: String
        var rightButtons = [UIBarButtonItem.self]
        
        title = "White House Petitions"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filter))
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
                
        navigationItem.setRightBarButtonItems([refresh, search], animated: true)
        
        if navigationController?.tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        showError()
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            tableView.reloadData()
        }
    }
    
    // MARK: - Objc methods
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "The data comes from the We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    @objc func filter() {
        let ac = UIAlertController(title: "Filter", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let searchPetitions = UIAlertAction(title: "Search", style: .default) { [weak self, weak ac] _ in
            guard let searchText = ac?.textFields?[0].text?.lowercased() else { return }
            for petition in self!.filteredPetitions {
                if !petition.title.lowercased().contains(searchText) && !petition.body.lowercased().contains(searchText) {
                    let petitionToRemove = petition
                    if let petitionToRemoveIndex = self?.filteredPetitions.firstIndex(of: petitionToRemove) {
                        self?.filteredPetitions.remove(at: petitionToRemoveIndex)
                    }
                }
            }
            self?.tableView.reloadData()
        }
        ac.addAction(searchPetitions)
        self.present(ac, animated: true)
    }
    
    @objc func refresh() {
        filteredPetitions = petitions
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let petition = filteredPetitions[indexPath.row]
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
