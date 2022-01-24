//
//  ShoppingListViewController.swift
//  ShoppingList
//
//  Created by Alexander Filippov on 24.1.22..
//

import UIKit

class ShoppingListViewController: UITableViewController {
    var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Shopping List"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptToAdd))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New list", style: .plain, target: self, action: #selector(startNewList))
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "..."
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return shoppingList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Product", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]

        return cell
    }

    // MARK: - @objc Functions
    
    @objc func promptToAdd() {
        let ac = UIAlertController(title: "Add item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Add to list", style: .default) { [weak ac] action in
            guard let item = ac?.textFields?[0].text else { return }
            self.add(item)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @objc func startNewList() {
        shoppingList.removeAll()
        
        tableView.reloadData()
    }
    
    // MARK: -Actions
    
    func add(_ item: String) {
        
        shoppingList.insert(item, at: 0)
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
}
