//
//  WeekRecordsVC.swift
//  SimpleDB
//
//  Created by Marcin Tomczuk on 21/03/2019.
//  Copyright © 2019 Marcin Tomczuk. All rights reserved.
//

import UIKit

class WeekRecordsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var allPhrases: [TimeItem] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPhrases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototype", for: indexPath) as! PrototypeCell
        
        let itemsInCell = allPhrases[indexPath.row]
     //   cell.textLabel?.text = allPhrases[indexPath.row].category
      //  cell.detailTextLabel?.text = String(allPhrases[indexPath.row].numOfHours)
        
        cell.category.text = itemsInCell.category
        cell.hours.text = String(itemsInCell.numOfHours)
        
        return cell
    }
    
    
    
    
    @IBOutlet weak var tableViewList: UITableView!
    
    var myList = [ItemList]()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        allPhrases = DBAccess.sharedInstance.readCategoryAndNumOfHoursWeek()
        
        tableViewList.reloadData()
        // Do any additional setup after loading the view.
    }
    

    

}

class PrototypeCell: UITableViewCell{
    
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var hours: UILabel!
    
    @IBOutlet weak var categoryMonth: UILabel!
    @IBOutlet weak var hoursMonth: UILabel!
    
    
    @IBOutlet weak var categorySpecified: UILabel!
    @IBOutlet weak var hoursSpecified: UILabel!
    
    
}

struct ItemList {
    var hours: Int
    var category: String
}
