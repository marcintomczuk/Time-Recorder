//
//  SpecifiedTimeRecordsVC.swift
//  SimpleDB
//
//  Created by Marcin Tomczuk on 21/03/2019.
//  Copyright © 2019 Marcin Tomczuk. All rights reserved.
//

import UIKit

class SpecifiedTimeRecordsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBAction func infoButton(_ sender: Any) {
        let alert = UIAlertController(title: "Alert", message: "The date must be in format yyyy-MM-dd", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
        let when = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func infoButtonTwo(_ sender: Any) {
        
        
            let alert = UIAlertController(title: "Alert", message: "The date must be in format yyyy-MM-dd", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
            let when = DispatchTime.now() + 5
            DispatchQueue.main.asyncAfter(deadline: when){
                // your code with delay
                alert.dismiss(animated: true, completion: nil)
            }
            
        
    }
    
    
    
    
    var date1 = "2019-04-20"
    var date2 = "2019-04-23"
    
    var allPhrases: [TimeItem] = []
    @IBOutlet weak var dateTextFieldTwo: UITextField!
    
    @IBOutlet weak var dateTextField: UITextField!
   
    @IBAction func okButtonPressed(_ sender: Any) {
        
        
       date1 = dateTextField.text!
       date2 = dateTextFieldTwo.text!
        
        allPhrases = DBAccess.sharedInstance.readCatAndHoursSpecified(date1: date1, date2: date2)
        
        tableViewList.reloadData()
        dateTextField.text = ""
        dateTextFieldTwo.text = ""
    }
    
    
    @IBOutlet weak var tableViewList: UITableView!
    
    
    
    func dateOne() -> String {
        
        return date1
    }
    func dateTwo() -> String{
        
        return date2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPhrases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototype", for: indexPath) as! PrototypeCell
        
        let itemsInCell = allPhrases[indexPath.row]
        //   cell.textLabel?.text = allPhrases[indexPath.row].category
        //  cell.detailTextLabel?.text = String(allPhrases[indexPath.row].numOfHours)
        
        cell.categorySpecified.text = itemsInCell.category
        cell.hoursSpecified.text = String(itemsInCell.numOfHours)
        
        return cell
    }
    
    
    
    
   
    
    var myList = [ItemList]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        allPhrases = DBAccess.sharedInstance.readCatAndHoursSpecified(date1: date1, date2: date2)
        
        tableViewList.reloadData()
        
       
        
        
        // Do any additional setup after loading the view.
    }

}
struct holdInputs {
    static let inputOne = "2019-04-10"
    static let inputTwo = "2019-04-26"
}
