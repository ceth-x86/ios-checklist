//
//  DataModel.swift
//  Checklists
//
//  Created by demas on 09/06/2019.
//  Copyright © 2019 demas. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    func registerDefaults() {
        let dictionary = [ "ChecklistIndex": -1,
                           "FirstTime": true ] as [String : Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
            UserDefaults.standard.synchronize()
        }
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
        }
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFileDir() -> URL {
        return documentsDirectory().appendingPathComponent("Data2.plist")
    }
    
    func saveChecklists() {
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: lists, requiringSecureCoding: false)
            try data.write(to: dataFileDir())
        } catch {
            print("couldn't write file")
        }
    }
    
    func loadChecklists() {
        
        let path = dataFileDir()
        if FileManager.default.fileExists(atPath: path.path) {
            let data = NSData.init(contentsOfFile: path.path)
            
            do {
                if let result = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data! as Data) as? [Checklist] {
                    lists = result
                    sortChecklists()
                }
            } catch {
                print("couldn't read file")
            }
        }
    }
    
    func sortChecklists() {
        lists.sort(by: {checklist1, checklist2 in return
            checklist1.name.localizedCompare(checklist2.name) == ComparisonResult.orderedAscending
        })
    }

}
