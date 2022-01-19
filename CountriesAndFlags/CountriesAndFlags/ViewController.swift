//
//  ViewController.swift
//  CountriesAndFlags
//
//  Created by Alexander Filippov on 19.1.22..
//

import UIKit

class ViewController: UITableViewController {

    var flags = [String]()
    var countryNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Country Flags"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasSuffix("png") {
                flags.append(item)
            }
        }
        print(flags)
        
        for flag in flags {
            let countryName = String(flag.dropLast(7))
            print(countryName)
            if !countryNames.contains(countryName) {
                countryNames.append(countryName)
            }
        }

        countryNames.sort()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return countryNames.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        let fontName = cell.textLabel?.font.fontName
        let country = countryNames[indexPath.row]
        
        cell.imageView?.layer.borderWidth = 1
        cell.imageView?.layer.borderColor = UIColor.darkGray.cgColor
        cell.imageView?.image = UIImage(named: country)
        cell.textLabel?.text = country.uppercased()
        cell.textLabel?.font = UIFont(name: fontName!, size: 16)
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            
            vc.selectedCountry = countryNames[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
