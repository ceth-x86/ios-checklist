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
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFileDir() -> URL {
        return documentsDirectory().appendingPathComponent("Data.plist")
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
                }
            } catch {
                print("couldn't read file")
            }
        }
    }

}
