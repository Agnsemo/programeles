//
//  SqlLite.swift
//  programele
//
//  Created by Agne on 2021-03-19.
//

import Foundation
import SQLite3

var db: DBHelper = DBHelper()

class DBHelper
{
    init()
    {
        db = openDatabase()
        createActivitiesTable()
        createLocationTable()
        createUsersTable()
    }
    
    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?
    
    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    //ACTIVITIES
    func createActivitiesTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS activities(id INTEGER PRIMARY KEY,title TEXT,description TEXT, image TEXT, time TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("activities table created.")
            } else {
                print("activities table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insertActivities(id: Int, title: String, description: String, image: String, time: String)
    {
        let activities = readActivities()
        for a in activities
        {
            if a.id == id
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO activities(id, title, description, image, time) VALUES (?, ?, ?, ?,?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 2, (title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (description as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (image as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (time as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func readActivities() -> [Activities] {
        let queryStatementString = "SELECT * FROM activities;"
        var queryStatement: OpaquePointer? = nil
        var psns : [Activities] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let title = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let description = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let image = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let time = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                psns.append(Activities(id: Int(id), title: title, description: description, image: image, time: time))
                print("Query Result:")
                print("\(id) | \(title) | \(description)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func deleteByID(id: Int) {
        let deleteStatementStirng = "DELETE FROM activities WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    
    //LOCATION
    
    func createLocationTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS location(id INTEGER PRIMARY KEY,name TEXT,city TEXT, workHours TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("location table created.")
            } else {
                print("location table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insertLocation(id: Int, name: String, city: String, workHours: String)
    {
        let location = readLocation()
        for l in location
        {
            if l.id == id
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO location(id, name, city, workHours) VALUES (?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (city as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (workHours as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func readLocation() -> [Location] {
        let queryStatementString = "SELECT * FROM location;"
        var queryStatement: OpaquePointer? = nil
        var psns : [Location] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let city = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let workHours = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                psns.append(Location(id: Int(id), name: name, city: city, workHours: workHours))
                print("Query Result:")
                print("\(id) | \(name) | \(city)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func deleteLocationByID(id: Int) {
        let deleteStatementStirng = "DELETE FROM location WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    //USER
    
    func createUsersTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS user(id INTEGER PRIMARY KEY, name TEXT,email TEXT, surname TEXT, password TEXT, username TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("user table created.")
            } else {
                print("user table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insertUser(id: Int, name: String, email: String, surname: String, password: String, username: String)
    {
        let user = readUser()
        for u in user
        {
            if u.id == id
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO user(id, name, email, surname, password, username) VALUES (?,?, ?, ?,?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (surname as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (password as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (username as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func readUser() -> [User] {
        let queryStatementString = "SELECT * FROM user;"
        var queryStatement: OpaquePointer? = nil
        var psns : [User] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let surname = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let password = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let username = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                psns.append(User(id: Int(id), name: name, email: email, surname: surname, password: password, secondPassword: "", userName: username))
                print("Query Result:")
                print("\(name) | \(email) | \(password)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func editUserByID(id: Int, user: User) {
        let updateStatementStirng = "UPDATE user SET name = '\(user.name)', surname = '\(user.surname)', username = '\(user.userName)' WHERE id = \(id);"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementStirng, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not updated row.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
}
