//
//  ItemsTableViewController.swift
//  TestChatApp
//
//  Created by 小林裕 on 2020/03/28.
//  Copyright © 2020 KobayashiYu. All rights reserved.
//
import UIKit
import Firebase

class ItemsTableViewController: UITableViewController{
    
    var user: User!
    
    var items = [Item]()
    
    var ref: DatabaseReference!
    
    private var databaseHandle: DatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = Auth.auth().currentUser
        
        ref = Database.database().reference()
        
        startObservingDatabase()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath)-> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        return cell
    }
    
    /*------------------------------------------------------スワイプでtableviewのセル削除コードここから--------------------------------------------------------------------------------*/
    
    override func tableView(_ tableView:UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        
        if editingStyle == .delete{
            let item = items[indexPath.row]
            item.ref?.removeValue()
        }
    }
    
    
    
    
    /*---------------------------------------------------------------ここまで-----------------------------------------------------------------------------------------------------*/
    
    
    
    @IBAction func didTapSignOut(_ sender: UIBarButtonItem) {
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "SignOut", sender: nil)
        } catch let error{
            assertionFailure("Error signing out:\(error)")
        }
    }
    /*@IBAction func SignOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            //performSegue(withIdentifier: "SignOut", sender: nil)
            print ("ログアウトしたよ。")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            
        }
    }
    
    */
    
    @IBAction func didTapAddItem(_ sender: UIBarButtonItem) {
        let prompt = UIAlertController(title:"To Do App",message: "To Do Item",preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",style: .default){
            (action) in
            let userInput = prompt.textFields![0].text
            
            if (userInput!.isEmpty){
                return
            }
            self.ref.child("users").child(self.user.uid).child("items").childByAutoId().child("title").setValue(userInput)
            
        }
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(okAction)
        present(prompt,animated: true,completion: nil);
    }
 
    
    func startObservingDatabase(){
        databaseHandle = ref.child("users/\(self.user.uid)/items").observe(.value,with:{(snapshot)in
            
            var newItems = [Item]()
            
            for itemSnapShot in snapshot.children{
                let item = Item(snapshot:itemSnapShot as! DataSnapshot)
                newItems.append(item)
            }
            
            self.items = newItems
            self.tableView.reloadData()
            
        })
    }
    
    deinit {
        ref.child("users/\(self.user.uid)/items").removeObserver(withHandle: databaseHandle)
    }
    
    
}
