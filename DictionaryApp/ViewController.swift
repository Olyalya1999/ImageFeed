//
//  ViewController.swift
//  DictionaryApp
//
//  Created by Olya on 30.04.2023.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        tableView.sectionHeaderHeight = 32
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var tableView: UITableView!
    
    let words = [ ["Apple", "Pear", "Watermelon"],
                  ["Carrot", "Pickle", "Potato", "Tomato"],
                  ["Strawberry", "Rasberry","Blackberry","Blueberry"]]
    
    let headers = ["Fruits", "Vegetables", "Berries"]
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return words.count
    }
    
    func tableView(_ tableView:UITableView, titleForHeaderInSection section:Int) -> String? {
        return headers[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let vegOrFruitArray = words[section]
        return vegOrFruitArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell                                                   // 1
        
        if let reusedCell = tableView.dequeueReusableCell(withIdentifier: "cell") { // 2
            cell = reusedCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")        // 3
        }
        
        var content = cell.defaultContentConfiguration()
        content.text = words[indexPath.section][indexPath.row]
        cell.contentConfiguration = content
        return cell                                                                 // 5
    }
}

extension ViewController: UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let alert = UIAlertController(title: nil,
                                      message: "Вы нажали на: \(words[indexPath.section][indexPath.row])",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
