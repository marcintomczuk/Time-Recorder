//
//  AddWordVC.swift
//  SimpleDB
//
//  Created by Marcin Tomczuk on 22/02/2019.
//  Copyright © 2019 Marcin Tomczuk. All rights reserved.
//

import UIKit
import Foundation
class AddCategoryVC: UIViewController,UITextFieldDelegate {
    
    var allPhrases: [TimeItem] = []
    var newItem: TimeItem?
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    @IBOutlet weak var category: UITextField!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.category.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "AddSegue" {
            
            
            
            let categoryCapital = category.text!.capitalized
            if category.text!.count >= 3 && category.text!.count <= 15 {
                newItem = TimeItem(id: 0, category: categoryCapital, date: "", numOfHours: 0)
               
            }
            else {
                
                    let alert = UIAlertController(title: "Alert", message: "You can enter minimimum 3 characters and maximum 15", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(alert, animated: true)
                let when = DispatchTime.now() + 5
                DispatchQueue.main.asyncAfter(deadline: when){
                    // your code with delay
                    alert.dismiss(animated: true, completion: nil)
                }
                }
            }
        }
        
    }


