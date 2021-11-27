//
//  RequestController.swift
//  getsdone-ios
//
//  Created by hu on 8/26/18.
//  Copyright © 2018 stephenhu. All rights reserved.
//

import UIKit

import Alamofire
import Font_Awesome_Swift
import Kingfisher
import SwiftyJSON

class RequestController: UIViewController, UITableViewDelegate,
  UITableViewDataSource {
    
    let cellIdentifier = "cell"
    
    let defaults = UserDefaults.standard
    
    var contacts = [[String]]()
    
    var uid = String()

    // MARK: Properties
    @IBOutlet weak var requestsTable: UITableView!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestsTable.delegate = self
        requestsTable.dataSource = self
        
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
        
        let cell = requestsTable.dequeueReusableCell(
            withIdentifier: cellIdentifier, for: indexPath) as! ContactViewCell
        
        if contacts[indexPath.item][4] != "" {
            
            let img = URL(string: "\(Getsdone.ROOT_ENDPOINT)/\(contacts[indexPath.item][4])")
            
            cell.icon.kf.setImage(with: img)
            
        } else {
            cell.icon.setFAIconWithName(icon: FAType.FAUser, textColor: .black)
        }
        
        cell.name.text = contacts[indexPath.item][0]
        cell.state.text = contacts[indexPath.item][1]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ac = UIAlertController(title: "Contact Request",
                                   message: "Allow this user to collaborate with me.",
                                   preferredStyle: UIAlertControllerStyle.alert)
        
        let Accept = UIAlertAction(title: "Accept",
                                   style: UIAlertActionStyle.default,
                                   handler: {action in self.acceptRequest(indexPath.item)})
        
        let Decline = UIAlertAction(title: "Decline",
                                    style: UIAlertActionStyle.default,
                                    handler: {action in self.declineRequest(indexPath.item)})
        
        let Cancel = UIAlertAction(title: "Cancel",
                                    style: UIAlertActionStyle.default,
                                    handler: nil)
        
        
        ac.addAction(Accept)
        ac.addAction(Decline)
        ac.addAction(Cancel)
        
        self.present(ac, animated: true, completion: nil)
        
    }
    

    func acceptRequest(_ index: Int) {
        sendRequest(index, action: Getsdone.CONTACT_ACCEPTED)
    } // acceptRequest
    
    func declineRequest(_ index: Int) {
        sendRequest(index, action: Getsdone.CONTACT_DECLINED)
    } // declineRequest

    
    func sendRequest(_ index: Int, action: String) {
        
        let url = "\(Getsdone.API_ENDPOINT)\(Getsdone.API_USERS)/\(uid)\(Getsdone.API_CONTACTS)/\(contacts[index][3])"

        print(url)
        
        progress.startAnimating()

        Alamofire.request(url, method: .put, parameters: ["action": action])
            .response{ response in
                
                self.progress.stopAnimating()
                
                if response.error != nil {
                    
                    let ac = UIAlertController(title: "Connection error",
                                               message: response.error?.localizedDescription,
                                               preferredStyle: UIAlertControllerStyle.alert)
                    
                    let OK = UIAlertAction(title: "OK",
                                           style: UIAlertActionStyle.default,
                                           handler: nil)
                    
                    ac.addAction(OK)
                    
                    self.present(ac, animated: true, completion: nil)
                    
                    
                } else if let status = response.response?.statusCode {
                    
                    print(status)
                    if status == 200 {
                        self.loadRequests()
                    } else {
                        
                        let ac = UIAlertController(title: "Request error",
                                                   message: response.error?.localizedDescription,
                                                   preferredStyle: UIAlertControllerStyle.alert)
                        
                        let OK = UIAlertAction(title: "OK",
                                               style: UIAlertActionStyle.default,
                                               handler: nil)
                        
                        ac.addAction(OK)
                        
                        self.present(ac, animated: true, completion: nil)
                        
                    }
                    
                }
                
        }
        
    } // sendRequest
    
    
    func loadRequests() {
        
        let url = "\(Getsdone.API_ENDPOINT)\(Getsdone.API_USERS)/\(uid)\(Getsdone.API_NOTIFICATIONS)"
        
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
                                
                                print(j)
                                var all = [[String]]()
                                
                                for (_, contact) in j {
                                    
                                    var c = [String]()
                                    
                                    c.append(contact["contactName"].string!)
                                    c.append(contact["state"].string!)
                                    c.append(contact["contactId"].string!)
                                    c.append(contact["userId"].string!)
                                    
                                    if contact["contactIcon"]["Valid"].bool! {
                                        c.append(contact["contactIcon"]["String"].string!)
                                    } else {
                                        c.append("")
                                    }
                                    
                                    all.append(c)
                                    
                                }
                                
                                self.contacts = all
                                
                                self.requestsTable.reloadData()
                                
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
        
    } // loadRequests
    
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
                                
                                print(j)
                                self.uid    = j["id"].string!
                                
                                self.loadRequests()
                                
                            } else {
                                print(status)
                                print(response.result)
                            }
                            
                        } else {
                            self.performSegue(withIdentifier: "startSegue", sender: nil)
                        }
                        
                    } else {
                        print(response.response)
                    }
                    
                    
                }
                
        }
        
    } // loadUserInfo
    
    // MARK: Actions

} // RequestController
