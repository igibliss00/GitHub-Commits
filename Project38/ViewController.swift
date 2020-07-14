//
//  ViewController.swift
//  Project38
//
//  Created by jc on 2020-07-14.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    var container: NSPersistentContainer!
    var commits = [Commit]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        container = NSPersistentContainer(name: "Project38")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                print("Unresovled error \(error)")
            }
        }
        
        saveContext()
        
        performSelector(inBackground: #selector(fetchCommits), with: nil)
        
        loadSavedData()
    }

    func saveContext() {
        // observes properties with the keyword @NSManaged and gets set to true automatically when you make changes to your objects
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occured while saving: \(error)")
            }
        }
    }
    
    func loadSavedData() {
        let request = Commit.createFetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            commits = try container.viewContext.fetch(request)
            print("Got \(commits.count) commits")
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    // MARK: - fetching and parsing from GitHub api
    
    @objc func fetchCommits() {
        if let data = try? String(contentsOf: URL(string: "https://api.github.com/repos/apple/swift/commits?per_page=100")!) {
            // give the data to SwiftyJSON to parse, which will convert the String object into an array of objects
            let jsonCommits = JSON(parseJSON: data)
            
            // read the commits back out
            let jsonCommitArray = jsonCommits.arrayValue
            
            print("Received \(jsonCommitArray.count) new commits")
            
            DispatchQueue.main.async { [unowned self] in
                for jsonCommit in jsonCommitArray {
                    // creates a Commit object (NSManagedObject subclass) inside the managed object context from NSPersistentContainer
                    let commit = Commit(context: self.container.viewContext)
                    
                    // Commit object along with the JSON data for the matching commit
                    self.configure(commit: commit, usingJSON: jsonCommit)
                }
                
                self.saveContext()
                self.loadSavedData()
            }
            
        }
    }
    
    func configure(commit: Commit, usingJSON json: JSON) {
        // using SwiftyJSON to parse JSON
        commit.sha = json["sha"].stringValue
        commit.message = json["commit"]["message"].stringValue
        commit.url = json["html_url"].stringValue
        
        let formatter = ISO8601DateFormatter()
        commit.date = formatter.date(from: json["commit"]["committer"]["date"].stringValue) ?? Date()
    }
    
    // MARK: - table data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Commit", for: indexPath)
        cell.textLabel!.text = commits[indexPath.row].message
        cell.detailTextLabel!.text = commits[indexPath.row].date.description
        
        return cell
    }
    
}

