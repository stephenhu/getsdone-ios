//
//  ContactController.swift
//  getsdone-ios
//
//  Created by hu on 8/21/18.
//  Copyright © 2018 stephenhu. All rights reserved.
//

import UIKit

import Alamofire
import Font_Awesome_Swift
import Kingfisher
import SwiftyJSON

class ContactController: UIViewController, UITableViewDelegate,
  UITableViewDataSource {
    
    let cellIdentifier = "cell"
    
    let defaults = UserDefaults.standard
    
    var contacts = [[String]]()
    
    var uid = String()
    
    // MARK: Properties
    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var addContactBtn: UIBarButtonItem!
    @IBOutlet weak var contactTable: UITableView!
    @IBOutlet weak var inbox: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inbox.setFAIcon(icon: FAType.FAInbox, iconSize: 24)
        addContactBtn.setFAIcon(icon: FAType.FAUserPlus, iconSize: 24)
        
        contactTable.delegate = self
        contactTable.dataSource = self
        
        loadUserInfo()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = contactTable.dequeueReusableCell(
            withIdentifier: cellIdentifier, for: indexPath) as! ContactViewCell

        if contacts[indexPath.item][4] != "" {
            
            let img = URL(string: "\(Getsdone.ROOT_ENDPOINT)/\(contacts[indexPath.item][4])")
            
            //print(img)
            cell.icon.kf.setImage(with: img)
            
        } else {
          cell.icon.setFAIconWithName(icon: FAType.FAUser, textColor: Getsdone.BlueColor)
        }
        
        cell.name.text = contacts[indexPath.item][0]
        
        if contacts[indexPath.item][1] == "requested" {
          cell.state.text = contacts[indexPath.item][1]
        } else {
          cell.state.text = ""
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    
    func loadUserInfo() {
        
        let url = "\(Getsdone.API_ENDPOINT)\(Getsdone.API_USERS)"
        
        print(url)
        progress.startAnimating()
        
        Alamofire.request(url, method: .get)
            .responseJSON{ response in
                
                self.progress.stopAnimating()
                
                switch response.result {
                case .failure(let error):
                    
                    if response.response?.statusCode == 401 {
                        
                        self.defaults.removeObject(forKey: Getsdone.COOKIE)
                        
                        self.performSegue(withIdentifier: "startSegue", sender: nil)
                        
                    } else {
                        
                        let ac = UIAlertController(title: "Connection error",
                                                   message: error.localizedDescription,
                                                   preferredStyle: UIAlertControllerStyle.alert)
                        
                        let OK = UIAlertAction(title: "OK",
                                               style: UIAlertActionStyle.default,
                                               handler: nil)
                        
                        ac.addAction(OK)
                        
                        self.present(ac, animated: true, completion: nil)
                        
                    }
                    
                    
                case .success:
                    
                    if let status = response.response?.statusCode {
                        
                        print(status)
                        
                        // TODO: revert to get started page if token invalid
                        
                        if status == 200 {
                            
                            if let raw = response.result.value {
                                
                                let j = JSON(raw)
                                
                                self.uid = j["id"].string!
                                //self.
                                self.loadContacts()
                                
                            } else {
                                print(status)
                                print(response.result)
                            }
                            
                        } else {
                            //self.performSegue(withIdentifier: "startSegue", sender: nil)
                        }
                        
                    } else {
                        print(response.response)
                    }
                    
                    
                }
                
        }
        
    } // loadUserInfo
    
    
    func loadContacts() {
    
        let url = "\(Getsdone.API_ENDPOINT)\(Getsdone.API_USERS)/\(uid)\(Getsdone.API_CONTACTS)"
        
        progress.startAnimating()
        
        Alamofire.request(url, method: .get)
            .responseJSON{ response in
                
                self.progress.stopAnimating()
                
                switch response.result {
                case .failure(let error):
                    
                    if response.response?.statusCode == 401 {
                        
                        self.defaults.removeObject(forKey: Getsdone.COOKIE)
                        
                        self.performSegue(withIdentifier: "startSegue", sender: nil)
                        
                    } else {
                        
                        let ac = UIAlertController(title: "Connection error",
                                                   message: error.localizedDescription,
                                                   preferredStyle: UIAlertControllerStyle.alert)
                        
                        let OK = UIAlertAction(title: "OK",
                                               style: UIAlertActionStyle.default,
                                               handler: nil)
                        
                        ac.addAction(OK)
                        
                        self.present(ac, animated: true, completion: nil)
                        
                    }
                    
                    
                case .success:
                    
                    if let status = response.response?.statusCode {
                        
                        print(status)
                        
                        // TODO: revert to get started page if token invalid
                        
                        if status == 200 {
                            
                            if let raw = response.result.value {
                                
                                let j = JSON(raw)
                                
                                var all = [[String]]()
                                
                                for (_, contact) in j {
                                    
                                    if contact["state"].string! == "accepted" || contact["state"].string! == "requested" {

                                        var c = [String]()
                                        
                                        print(contact)
                                        c.append(contact["contactName"].string!)
                                        c.append(contact["state"].string!)
                                        c.append(contact["contactId"].string!)
                                        c.append(contact["id"].string!)
                                        
                                        if contact["contactIcon"]["Valid"].bool! {
                                            c.append(contact["contactIcon"]["String"].string!)
                                        } else {
                                            c.append("")
                                        }
                                        
                                        all.append(c)

                                    }
                                    
                                }
                                
                                self.contacts = all
                                
                                self.contactTable.reloadData()
                                
                            } else {
                                print(status)
                                print(response.result)
                            }
                            
                        } else {
                            //self.performSegue(withIdentifier: "startSegue", sender: nil)
                        }
                        
                    } else {
                        print(response.response)
                    }
                    
                    
                }
                
        }
        
    } // loadContacts
    
    
    // MARK: Actions
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
    
    }
    
    
} // ContactController
