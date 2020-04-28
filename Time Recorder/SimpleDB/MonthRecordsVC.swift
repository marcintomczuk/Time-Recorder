//
//  MonthRecordsVC.swift
//  SimpleDB
//
//  Created by Marcin Tomczuk on 21/03/2019.
//  Copyright © 2019 Marcin Tomczuk. All rights reserved.
//

import UIKit

class MonthRecordsVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var tableViewList: UITableView!
    

    var allPhrases: [TimeItem] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPhrases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototype", for: indexPath) as! PrototypeCell
        
        let itemsInCell = allPhrases[indexPath.row]
        //   cell.textLabel?.text = allPhrases[indexPath.row].category
        //  cell.detailTextLabel?.text = String(allPhrases[indexPath.row].numOfHours)
        
        cell.categoryMonth.text = itemsInCell.category
        cell.hoursMonth.text = String(itemsInCell.numOfHours)
        
        return cell
    }
    
    
    
    
   
    
    var myList = [ItemList]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allPhrases = DBAccess.sharedInstance.readCategoryAndNumOfHoursMonth()
        
        tableViewList.reloadData()
        // Do any additional setup after loading the view.
    }
    
    
    

}
