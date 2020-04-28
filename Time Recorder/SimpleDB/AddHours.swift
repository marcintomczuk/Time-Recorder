//
//  RecordsVC.swift
//  SimpleDB
//
//  Created by Marcin Tomczuk on 27/03/2019.
//  Copyright © 2019 Marcin Tomczuk. All rights reserved.
//

import UIKit
import Foundation


class AddHours: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    var newArray: [TimeItem] = []
    var allPhrases: [TimeItem] = []
    var newItem: TimeItem?
    
    var displayedDate = Date()
    var keepDate: String = ""
    
    
    
    @IBAction func printTitle(_ sender: Any) {
        print(title!)
    }
    
    @IBOutlet weak var tableViewList: UITableView!
    
    var button = DropDownBtn()
    
    
    @IBOutlet weak var labelActualDate: UILabel!
    
    @IBAction func dayAgoPressed(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        displayedDate = displayedDate - 86400
        formatter.dateFormat = "yyyy-MM-dd"
        let myString = formatter.string(from: displayedDate)
        labelActualDate.text = myString
        
    }
    
    @IBAction func dayAfterPressed(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        displayedDate = displayedDate + 86400
        formatter.dateFormat = "yyyy-MM-dd"
        let myString = formatter.string(from: displayedDate)
        labelActualDate.text = myString
    }
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var numOfHoursTF: UITextField!
    
    
    func enteredDate() -> String{
        let dateTextField = CategoryVC().keepActualDate()
        
        
        // If applyButtonPressed {
        //    dateTextField = Int(textField.text!)!             *****************************************

        return dateTextField
    }
    
   
    
    
    
    
        
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPhrases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "RecordsCell")
        cell.textLabel?.text = allPhrases[indexPath.row].category
        cell.detailTextLabel?.text = String(allPhrases[indexPath.row].numOfHours)
        return cell
    }
    
    
    
    
    
    
    
    @IBAction func applyButtonPressed(_ sender: Any) {
        //newItem = allPhrases[0]
        var highestIndex = 100
        for tt in allPhrases {
            if tt.id > highestIndex { highestIndex = tt.id }
        }
    
        var total = 0
        for item in allPhrases{
            if item.category == newItem?.category {
                newArray.append(item)
                
                total = total + Int(item.numOfHours)
                print(total)
              
            }
        }
        if  numOfHoursTF.text == "" || Int(numOfHoursTF.text!)! >= 25 {
            
            let alert = UIAlertController(title: "Alert", message: "Please enter minimum 1 hours and maximum 24", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
            
            let when = DispatchTime.now() + 4
            DispatchQueue.main.asyncAfter(deadline: when){
                // your code with delay
                alert.dismiss(animated: true, completion: nil)
            }
        }
            
        
        else{
            
  
            
            let itemToAdd = TimeInsertItem(category: button.returnChoice(), date: labelActualDate.text!, numOfHours: Int(numOfHoursTF.text!)!  )
        
            DBAccess.sharedInstance.writeNodeToDB(itemToAdd)
            allPhrases = DBAccess.sharedInstance.readAllPhrasesFromDB()
            
            let alert = UIAlertController(title: "Great!", message: " \(numOfHoursTF.text!) hours has been successfully added to \(button.returnChoice()) category! ", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
            
            let when = DispatchTime.now() + 4
            DispatchQueue.main.asyncAfter(deadline: when){
                // your code with delay
                alert.dismiss(animated: true, completion: nil)
            }
            numOfHoursTF.text = ""
            
        
            
        }
    }
    
    @IBOutlet weak var dateTextField: UITextField!
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
override func viewDidLoad() {
        super.viewDidLoad()
    
    self.numOfHoursTF.delegate = self
    
    
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let myString = formatter.string(from: displayedDate)
    let yourDate = formatter.date(from: myString)
    
    formatter.dateFormat = "yyyy-MM-dd"
    keepDate = formatter.string(from: yourDate!)
    labelActualDate.text = keepDate
    
    
    
    
    
    
    
    
        self.numOfHoursTF.delegate = self;
    
        
        
        
        button = DropDownBtn.init(frame: CGRect(x: 10, y: 10, width: 10, height: 10))
        button.setTitle("Categories", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(button)
            
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        button.widthAnchor.constraint(equalToConstant: 225).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        button.dropView.dropDownOptions = DBAccess().readAllNumOfHoursFromDB()
        
        title = "Records"
      //  allPhrases = DBAccess.sharedInstance.readCategoryAndNumOfHoursWeek(category: cat)
        
    
    
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }

   
}


    

    



protocol dropDownProtocol {
    func dropDownPressed(string: String)
    
}

class DropDownBtn: UIButton,dropDownProtocol {
    
    func dropDownPressed(string: String) {
        self.setTitle(string, for: .normal)
        self.dismissDropDown()
        
         
    }
    
    func returnChoice() -> String{
        return (self.titleLabel?.text)!
    }
   
    
    
    var dropView = DropDownView()
    
    var height = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 40/255.0, green: 51/255, blue: 142/255, alpha: 1.0)   
        
        dropView = DropDownView.init(frame: CGRect.init(x: 10, y: 10, width: 10, height: 10))
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
        
        
        }
    override func didMoveToSuperview() {
        self.addSubview(dropView)
        self.superview?.addSubview(dropView)
        self.superview?.bringSubviewToFront(dropView)
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    
    var isOpen = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            
            isOpen = true
            
            NSLayoutConstraint.deactivate([self.height])
            
            if self.dropView.tableView.contentSize.height > 300 {
                self.height.constant = 300}
            else {
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
            
            
            
        }else{
            isOpen = false
            
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {self.dropView.center.y += self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
                
            }, completion: nil)
            
        }
        
        
    }
    func dismissDropDown(){
        isOpen = false
        
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var dropDownOptions = [String]()
    
    var tableView = UITableView()
    
    var delegate : dropDownProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.backgroundColor = UIColor.gray
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.backgroundColor = UIColor(red: 155/255.0, green: 176/255, blue: 219/255, alpha: 1.0) 
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.dropDownPressed(string: dropDownOptions[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}


