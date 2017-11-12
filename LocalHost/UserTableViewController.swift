//
//  UserTableViewController.swift
//  LocalHost
//
//  Created by Mari Husain on 11/11/17.
//  Copyright © 2017 Mari Husain. All rights reserved.
//

import UIKit
import Foundation

class UserTableViewController: UITableViewController {

    // MARK: Properties
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // load in the sample data
        loadSampleUsers()
        
        // load in users from the localhost server
        loadUsersFromLocalhost()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "UserTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UserTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell")
        }

        // fetch the appropriate user as per the data source layout
        let user = users[indexPath.row]
        
        // cet the corresponding fields in the cell to the data extracted from the user.
        cell.nameLabel.text = user.name
        cell.locationLabel.text = user.location

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Private Methods
    
    private func loadSampleUsers() {
        guard let user1 = User(name: "Mari", location: "Denver") else {
            fatalError("Unable to create user1")
        }
        
        guard let user2 = User(name: "Eric", location: "Los Angeles") else {
            fatalError("Unable to create user2")
        }
        
        guard let user3 = User(name: "Andrew", location: "Palo Alto") else {
            fatalError("Unable to create user3")
        }
        
        users += [user1, user2, user3]
    }
    
    private func loadUsersFromLocalhost() {
        
        // get the data from the following URL
        let urlString = "http://localhost:5000/localhost/api/v0.1/users"
        
        let url = URL(string: urlString)!
        let jsonData = try! Data(contentsOf: url)
        
        if let root = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] {
            //print(root)
            
            if let usersList = root?["users"] as? [[String: Any]] {
                for rawUser in usersList {
                    if let name = rawUser["name"] as? String, let location = rawUser["location"] as? String {
                        if let user = User(name: name, location: location) {
                            self.users.append(user)
                        }
                    }
                }
            }
        }
    }
    
    private func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

}
