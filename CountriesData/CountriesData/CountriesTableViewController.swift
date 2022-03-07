//
//  CountriesTableViewController.swift
//  CountriesData
//
//  Created by Alexander Filippov on 2.3.22..
//

import UIKit

class CountriesTableViewController: UITableViewController {
    
    var countries = [Country]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Countries Data"
        
        fetchJSON()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        
        cell.heightAnchor.constraint(equalToConstant: 80)
        cell.imageView?.image = UIImage(named: countries[indexPath.row].name)
        cell.imageView?.layer.borderWidth = 2
        cell.imageView?.layer.borderColor = UIColor.lightGray.cgColor
        cell.textLabel?.text = "Name: \(countries[indexPath.row].name.uppercased())"
        cell.detailTextLabel?.text = "Capital: \(countries[indexPath.row].capital.capitalized)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailTableViewController else { return }
        
        vc.country = countries[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchJSON() {
        guard let path = Bundle.main.path(forResource: "Countries", ofType: "json") else { return }
        
        if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            let decoder = JSONDecoder()
            
            if let jsonCountries = try? decoder.decode(Countries.self, from: data) {
                countries = jsonCountries.countries
            } else {
                print("Error decoding json!")
            }
        }
    }
    
    
    
}
