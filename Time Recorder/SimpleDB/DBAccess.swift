//
//  DBAccess.swift
//  
//
//  Created by Marcin Tomczuk on 14/09/2018.
//  Copyright © 2018 Marcin Tomczuk. All rights reserved.
//

import Foundation
import SQLite3

private let _hiddenSharedInstance = DBAccess()


class DBAccess{
    
    
    class var sharedInstance: DBAccess{
        return _hiddenSharedInstance;
    }
    
   var mySQLDB: OpaquePointer? = nil  // A pointer to the database
    
   let dbName = "timeDB"
   let dbExtension = "sqlite"
    
    init(){
        //Called when the singleton instance is first accessed
        openSQLDB()
        
    }
    
    func openSQLDB(){
        // Copy the empty database from the bundle to Documents if
        // it doesn't already exist.
        createEditableVersionOfDatabaseIfNeeded()
        
        // It will now exist so open database
        let filenameForDB = dbName + "." + dbExtension
        let DBInDocuments = urlToFileInDocuments(filenameForDB)
        guard sqlite3_open(DBInDocuments.path, &mySQLDB) == SQLITE_OK
            else {
                assertionFailure( "Couldn't open database")
                return
            }
    }

    func createEditableVersionOfDatabaseIfNeeded() {
        let filenameForDB = dbName + "." + dbExtension
        if !fileExistsInDocuments(filenameForDB) {
            let DBInBundle = Bundle.main.url(forResource: dbName, withExtension: dbExtension)!
            let DBInDocuments = urlToFileInDocuments(filenameForDB)
            let fileManager = FileManager.default
            do {
                try fileManager.copyItem(at: DBInBundle, to: DBInDocuments)
            } catch {
                assert( false)
            }
        }
    }
    
    func fileExistsInDocuments( _ fileName: String ) -> Bool {
        let fileManager = FileManager.default
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPaths[0]
        let filepathName = docsDir + "/\(fileName)"
        print( "path is \(filepathName)")
        return fileManager.fileExists(atPath: filepathName)
    }
    
    func urlToFileInDocuments( _ fileName: String ) -> URL {
        let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = docDirectory.appendingPathComponent(fileName)
        return fileURL
    }
    
 
    
    func writeNodeToDB(_ categoryDetails: TimeInsertItem ) {
         let query = "insert into Categories (category, date, numOfHours) values ( '\(categoryDetails.category)', '\(categoryDetails.date)',' \(categoryDetails.numOfHours)');"
        print(query)
        var statement: OpaquePointer? = nil  // Pointer for sql to track returns

        if sqlite3_prepare(mySQLDB, query, -1, &statement, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(mySQLDB)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //executing the query to insert values
        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(mySQLDB)!)
            print("failure inserting node: \(errmsg)")
            return
        }
        
        sqlite3_finalize(statement)
        
    }
    
    func writeNodeWithNumOfHours(_ categoryDetails: TimeItem ) {
        let query = "insert into Categories (id, category, date, numOfHours) values ('\(categoryDetails.id)', '\(categoryDetails.category)', '\(categoryDetails.date)',' \(categoryDetails.numOfHours)');"
        print(query)
        var statement: OpaquePointer? = nil  // Pointer for sql to track returns
        
        if sqlite3_prepare(mySQLDB, query, -1, &statement, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(mySQLDB)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //executing the query to insert values
        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(mySQLDB)!)
            print("failure inserting node: \(errmsg)")
            return
        }
        
        sqlite3_finalize(statement)
        
    }

    func stringAtField(_ statementPointer: OpaquePointer, fieldIndex: Int ) -> String {
        // This method returns the string that was the nth field asked for from the DB as a Swift String
        var answer = "Error - DBAccess failed"
        if let rawString = sqlite3_column_text(statementPointer, Int32(fieldIndex) ) {
            answer = String(cString: rawString)
        }
        return answer
    }
    
    
    
    
    func readAllPhrasesFromDB() ->   [TimeItem]{
        var resultArray: [TimeItem] = []
     
        
        //let query = "SELECT id, category, date, numOfHours FROM Categories ORDER BY category;"
        let query = "SELECT id, category, date, numOfHours FROM Categories WHERE numOfHours == \(0)  ORDER BY category;"
        var statement: OpaquePointer? = nil  // Pointer for sql to track returns
        
        if sqlite3_prepare_v2( mySQLDB, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let category = stringAtField(statement!, fieldIndex: 1)
                let date = stringAtField(statement!, fieldIndex: 2)
                let numOfHours = Int(sqlite3_column_int(statement, 3))
                
                let node = TimeItem(id: id, category: category, date: date, numOfHours: numOfHours)
                resultArray.append(node)
                
            }
        }
        
        sqlite3_finalize(statement)
        return resultArray
    }
    
    
    // ?????????????????????????? Need to be sorted by Date
    func readCategoryAndNumOfHours() ->   [TimeItem]{
        var resultArray: [TimeItem] = []
        
        
        //let query = "SELECT id, category, date, numOfHours FROM Categories ORDER BY category;"
        let query = "SELECT id, category, date, numOfHours FROM Categories WHERE date == '\(CategoryVC().keepActualDate())';"
        var statement: OpaquePointer? = nil  // Pointer for sql to track returns
        
        if sqlite3_prepare_v2( mySQLDB, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let category = stringAtField(statement!, fieldIndex: 1)
                let date = stringAtField(statement!, fieldIndex: 2)
                let numOfHours = Int(sqlite3_column_int(statement, 3))
                
                let node = TimeItem(id: id, category: category, date: date, numOfHours: numOfHours)
                resultArray.append(node)
                
            }
        }
        
        sqlite3_finalize(statement)
        return resultArray
    }
    
    func readCategoryAndNumOfHoursWeek() ->   [TimeItem]{
        var resultArray: [TimeItem] = []
        
        
        //let query = "SELECT id, category, date, numOfHours FROM Categories ORDER BY category;"
        let query = "SELECT id, category, date, numOfHours FROM Categories WHERE date >= '\(CategoryVC().weekAgoDay())' AND date <= '\(CategoryVC().keepActualDate())' AND numOfHours != \(0);"
        var statement: OpaquePointer? = nil  // Pointer for sql to track returns
        
        if sqlite3_prepare_v2( mySQLDB, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let category = stringAtField(statement!, fieldIndex: 1)
                let date = stringAtField(statement!, fieldIndex: 2)
                let numOfHours = Int(sqlite3_column_int(statement, 3))
                
                let node = TimeItem(id: id, category: category, date: date, numOfHours: numOfHours)
                resultArray.append(node)
                
            }
        }
        
        sqlite3_finalize(statement)
        return resultArray
    }
    func readCategoryAndNumOfHoursMonth() ->   [TimeItem]{
        var resultArray: [TimeItem] = []
        
        
        //let query = "SELECT id, category, date, numOfHours FROM Categories ORDER BY category;"
        let query = "SELECT id, category, date, numOfHours FROM Categories WHERE date >= '\(CategoryVC().monthAgoDay())' AND date <= '\(CategoryVC().keepActualDate())' AND numOfHours != \(0);"
        var statement: OpaquePointer? = nil  // Pointer for sql to track returns
        
        if sqlite3_prepare_v2( mySQLDB, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let category = stringAtField(statement!, fieldIndex: 1)
                let date = stringAtField(statement!, fieldIndex: 2)
                let numOfHours = Int(sqlite3_column_int(statement, 3))
                
                let node = TimeItem(id: id, category: category, date: date, numOfHours: numOfHours)
                resultArray.append(node)
                
            }
        }
        
        sqlite3_finalize(statement)
        return resultArray
    }
    // functions which will be used to drop down menu
    func readAllNumOfHoursFromDB() -> [String] {
        
        var resultArray: [String] = []
        let query = "SELECT category FROM Categories WHERE numOfHours == \(0) ORDER by category;"
        var statement: OpaquePointer? = nil  // Pointer for sql to track returns
        
        if sqlite3_prepare_v2( mySQLDB, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let category = stringAtField(statement!, fieldIndex: 0)
                
                resultArray.append(String(category))
                
            }
        }
        
        
        sqlite3_finalize(statement)
        return resultArray
    }
    
    
    // new function
    func readNumOfHoursFromDB() -> [TimeItem]{
        var resultArrayR: [TimeItem] = []
        
        let query = "SELECT category FROM Categories WHERE id = 1;"
        var statement: OpaquePointer? = nil  // Pointer for sql to track returns
        
        if sqlite3_prepare_v2( mySQLDB, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let category = stringAtField(statement!, fieldIndex: 1)
                let date = stringAtField(statement!, fieldIndex: 2)
                let numOfHours = Int(sqlite3_column_int(statement, 3))
                
                let node = TimeItem(id: id, category: category, date: date, numOfHours: numOfHours)
                print(query)
                resultArrayR.append(node)
                
            }
        }
        sqlite3_finalize(statement)
        
        return resultArrayR
    }
    
    func readCatAndHoursSpecified(date1: String, date2: String) -> [TimeItem]{
        var resultArrayR: [TimeItem] = []
        
        let query = "SELECT id, category, date, numOfHours FROM Categories WHERE date >= '\(date1)' AND date <= '\(date2)' AND numOfHours != \(0);"
        var statement: OpaquePointer? = nil  // Pointer for sql to track returns
        
        if sqlite3_prepare_v2( mySQLDB, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let category = stringAtField(statement!, fieldIndex: 1)
                let date = stringAtField(statement!, fieldIndex: 2)
                let numOfHours = Int(sqlite3_column_int(statement, 3))
                
                let node = TimeItem(id: id, category: category, date: date, numOfHours: numOfHours)
                print(query)
                resultArrayR.append(node)
                
            }
        }
        sqlite3_finalize(statement)
        
        return resultArrayR
    }

   func deleteRowFromDB() -> [TimeItem]{
    let resultArrayR: [TimeItem] = []
    
    let query = "DELETE FROM Categories;"
    var statement: OpaquePointer? = nil  // Pointer for sql to track returns
    
    if sqlite3_prepare_v2( mySQLDB, query, -1, &statement, nil) == SQLITE_OK {
        while sqlite3_step(statement) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(statement, 0))
            let category = stringAtField(statement!, fieldIndex: 1)
            let date = stringAtField(statement!, fieldIndex: 2)
            let numOfHours = Int(sqlite3_column_int(statement, 3))
            }
    }
    sqlite3_finalize(statement)
    
    return resultArrayR
        
    }
    
    func deleteSelectedRowFromDB(item: String) -> [TimeItem]{
        let resultArrayR: [TimeItem] = []
        
        let query = "DELETE FROM Categories WHERE category == '\(item)';"
        var statement: OpaquePointer? = nil  // Pointer for sql to track returns
        
        if sqlite3_prepare_v2( mySQLDB, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let category = stringAtField(statement!, fieldIndex: 1)
                let date = stringAtField(statement!, fieldIndex: 2)
                let numOfHours = Int(sqlite3_column_int(statement, 3))
            }
        }
        sqlite3_finalize(statement)
        
        return resultArrayR
        
    }

    
}


struct TimeItem {
    var id: Int
    var category: String
    var date: String
    var numOfHours: Int
    
    init(id: Int, category: String, date: String, numOfHours: Int) {
        self.id = id
        self.category = category
        self.date = date
        self.numOfHours = numOfHours
    }
}


struct TimeInsertItem {
    
    var category: String
    var date: String
    var numOfHours: Int
    
    init( category: String, date: String, numOfHours: Int) {
        
        self.category = category
        self.date = date
        self.numOfHours = numOfHours
    }
}
