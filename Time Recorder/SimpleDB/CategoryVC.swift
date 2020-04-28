//
//  ShowListVC.swift
//  SimpleDB
//
//  Created by Marcin Tomczuk on 22/02/2019.
//  Copyright © 2019 Marcin Tomczuk. All rights reserved.
//

import UIKit

class CategoryVC: UITableViewController {
    var allPhrases: [TimeItem] = []
    
    
    
   
    
    @IBAction func binPressed(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Alert", message: "Do you want to remove all the categories or only one?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "All the Categories", style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            
            DBAccess().deleteRowFromDB()
            self.allPhrases = DBAccess.sharedInstance.readAllPhrasesFromDB()
            
            self.tableViewList.reloadData()
            
        }))
       
            alert.addAction(UIAlertAction(title: "Only One Category", style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
                let alert = UIAlertController(title: "Delete Category", message: "Enter a category", preferredStyle: .alert)
                
                //2. Add the text field. You can configure it however you need.
                alert.addTextField { (textField) in
                    textField.text = ""
                }
                
                // 3. Grab the value from the text field, and print it when the user clicks OK.
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                    let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                    
                    
                    DBAccess().deleteSelectedRowFromDB(item: (textField?.text!)!.capitalized)
                    self.allPhrases = DBAccess.sharedInstance.readAllPhrasesFromDB()
                    
                    self.tableViewList.reloadData()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
                    
                }))
                
                // 4. Present the alert.
                self.present(alert, animated: true, completion: nil)
        }))
        self.present(alert,animated: true, completion: nil)
    }
    
    @IBOutlet var tableViewList: UITableView!
    
    @IBOutlet weak var date: UILabel!
    
    var keepDate: String = ""
    
    @IBOutlet weak var input: UITextField!
    
    
    

    func keepActualDate() -> String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date())
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "yyyy-MM-dd"
        keepDate = formatter.string(from: yourDate!)
        
        return keepDate
    }
    
    
    func weekAgoDay() -> String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date())
        let yourDate = formatter.date(from: myString)
        let weekAgo = yourDate! - 432000
        formatter.dateFormat = "yyyy-MM-dd"
        keepDate = formatter.string(from: weekAgo)
        print(keepDate)
        return keepDate
    }
    func monthAgoDay() -> String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date())
        let yourDate = formatter.date(from: myString)
        let monthAgo = yourDate! - 2628000
        formatter.dateFormat = "yyyy-MM-dd"
        keepDate = formatter.string(from: monthAgo)
        print(keepDate)
        return keepDate
    }
    func dayAgo() -> String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date())
        let yourDate = formatter.date(from: myString)
        let weekAgo = yourDate! - 86400
        formatter.dateFormat = "yyyy-MM-dd"
        keepDate = formatter.string(from: weekAgo)
        print(keepDate)
        return keepDate
    }
    func dayAfter() -> String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date())
        let yourDate = formatter.date(from: myString)
        let weekAgo = yourDate! + 86400
        formatter.dateFormat = "yyyy-MM-dd"
        keepDate = formatter.string(from: weekAgo)
        print(keepDate)
        return keepDate
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
            
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date())
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "yyyy-MM-dd"
        keepDate = formatter.string(from: yourDate!)
       
            
        
        

        allPhrases = DBAccess.sharedInstance.readAllPhrasesFromDB()
    }

   

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
   
    
    
    
   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPhrases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesCell", for: indexPath)

        
        cell.textLabel?.text = allPhrases[indexPath.row].category
        cell.detailTextLabel?.text = allPhrases[indexPath.row].date
        return cell
    }
    
    @IBAction func unwindToList(_ unwindSegue: UIStoryboardSegue) {
        let sourceVC = unwindSegue.source as! AddCategoryVC
        
        if let newItem = sourceVC.newItem {
            
            var highestIndex = 0
            for phras in allPhrases {
                if phras.id > highestIndex { highestIndex = phras.id }
            }
            let itemToAdd = TimeInsertItem(category: newItem.category, date: keepDate, numOfHours: newItem.numOfHours  )
            DBAccess.sharedInstance.writeNodeToDB(itemToAdd)
            
            // Reload the list of phrases - could just have added it to allPhrases
            allPhrases = DBAccess.sharedInstance.readAllPhrasesFromDB()
            
            // Redisplay the list
            self.tableView.reloadData()
        }
    }
    
}
