//
//  DetailTableViewController.swift
//  CountriesData
//
//  Created by Alexander Filippov on 7.3.22..
//

import UIKit

class DetailTableViewController: UITableViewController {
    @IBOutlet var flagImage: UIImageView!
    @IBOutlet var countryNameLabel: UILabel!
    @IBOutlet var capitalNameLabel: UILabel!
    @IBOutlet var populationLabel: UILabel!
    @IBOutlet var areaLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
        
    var country: Country!

    override func viewDidLoad() {
        super.viewDidLoad()

        flagImage.image = UIImage(named: country.name)
        flagImage.layer.borderWidth = 2
        flagImage.layer.borderColor = UIColor.lightGray.cgColor
        countryNameLabel.text = country.name.uppercased()
        capitalNameLabel.text = country.capital.capitalized
        populationLabel.text = String(country.population.formattedWithSeparator)
        areaLabel.text = "\(country.area.formattedWithSeparator) sq.km"
        currencyLabel.text = country.currency
    }
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Int {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}
