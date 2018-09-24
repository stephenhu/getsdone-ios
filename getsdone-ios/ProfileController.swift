//
//  ProfileController.swift
//  getsdone-ios
//
//  Created by hu on 6/28/18.
//  Copyright © 2018 stephenhu. All rights reserved.
//

import UIKit

import Alamofire
import Charts
import Font_Awesome_Swift
import SwiftyJSON

class ProfileController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    var uid = String()
    
    var tasks       = [[String]]()
    var open        = [[String]]()
    var completed   = [[String]]()
    
    
    // MARK: Properties
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var since: UILabel!
    @IBOutlet weak var totalChart: LineChartView!
    @IBOutlet weak var ranking: UIProgressView!
    @IBOutlet weak var avgCompleteLbl: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        
        loadAllTasks()
        totalUpdate()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        icon.setFAIconWithName(icon: FAType.FAUserO, textColor: UIColor.black)
     
        ranking.layer.cornerRadius = 5
        
        self.view.bringSubview(toFront: progress)
        
        loadUserInfo()
        
        totalChart.drawGridBackgroundEnabled = false
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func totalUpdate() {
        
        let e1 = ChartDataEntry(x: 1, y: 20.0)
        let e2 = ChartDataEntry(x: 2, y: 4)
        let e3 = ChartDataEntry(x: 3, y: 30)
        let e4 = ChartDataEntry(x: 4, y: 8)
        let e5 = ChartDataEntry(x: 5, y: 6)
        let e6 = ChartDataEntry(x: 6, y: 3)
        let e7 = ChartDataEntry(x: 7, y: 1)
        
        let ds1 = LineChartDataSet(values: [e1, e2, e3, e4, e5, e6, e7], label: "Open")
        
        
        let f1 = ChartDataEntry(x: 1, y: 2.0)
        let f2 = ChartDataEntry(x: 2, y: 10.0)
        let f3 = ChartDataEntry(x: 3, y: 12.0)
        let f4 = ChartDataEntry(x: 4, y: 15.0)
        let f5 = ChartDataEntry(x: 5, y: 20.0)
        let f6 = ChartDataEntry(x: 6, y: 13.0)
        let f7 = ChartDataEntry(x: 7, y: 1.0)
        
        let ds2 = LineChartDataSet(values: [f1, f2, f3, f4, f5, f6, f7], label: "Closed")
        
        ds1.axisDependency = .left
        
        //let gradientColors = [Getsdone.TealColor.cgColor, UIColor.clear.cgColor] as CFArray
        //let colorLocations: [CGFloat] = [1.0, 0.0]
        
        //guard let gradient = CG
        
        ds1.colors = [Getsdone.TealColor]
        //dataSet.setCircleColor(UIColor.red)
        ds1.mode = .cubicBezier
        ds1.lineWidth = 1
        ds1.drawCircleHoleEnabled = false
        ds1.drawCirclesEnabled = false
        //dataSet.circleRadius = 4
        ds1.drawFilledEnabled = true
        ds1.fillColor = Getsdone.TealColor
        //dataSet.valueFont = UIFont(name: "Arial", size: 28.0)!
        ds1.fillAlpha = 0.1
        
        ds2.colors = [UIColor.red]
        ds2.mode = .cubicBezier
        ds2.lineWidth = 1
        ds2.drawCircleHoleEnabled = false
        ds2.drawCirclesEnabled = false
        //dataSet.circleRadius = 4
        ds2.drawFilledEnabled = true
        ds2.fillColor = UIColor.red
        ds2.fillAlpha = 0.1
        
        let days = ["", "Sep 10", "Sep 11", "Sep 12", "Sep 13", "Sep 14", "Sep 15", "Sep 16"]
        //let data = BarChartData(xVals: days, dataSets: [dataSet])
        let data = LineChartData(dataSets: [ds1, ds2])
        
        totalChart.data = data
        
        totalChart.chartDescription?.text = "Open vs Closed"
        //totalChart.chartDescription?.enabled = false
        totalChart.drawBordersEnabled = false
        
        
        //totalChart.gridBackgroundColor = .clear
        totalChart.leftAxis.drawGridLinesEnabled = false
        totalChart.leftAxis.drawZeroLineEnabled = false
        totalChart.leftAxis.drawTopYLabelEntryEnabled = false
        totalChart.leftAxis.drawBottomYLabelEntryEnabled = false
        totalChart.leftAxis.drawLabelsEnabled = false
        totalChart.leftAxis.drawAxisLineEnabled = false
        totalChart.leftAxis.granularity = 1
        totalChart.leftAxis.decimals = 0
        totalChart.leftAxis.granularityEnabled = true
        //totalChart.leftAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        
        totalChart.rightAxis.drawGridLinesEnabled = false
        totalChart.rightAxis.drawZeroLineEnabled = false
        totalChart.rightAxis.drawAxisLineEnabled = false
        totalChart.rightAxis.drawLabelsEnabled = false
        totalChart.rightAxis.drawTopYLabelEntryEnabled = false
        totalChart.rightAxis.drawZeroLineEnabled = false
        totalChart.rightAxis.decimals = 0
        totalChart.xAxis.labelTextColor = .clear
        
        totalChart.xAxis.drawGridLinesEnabled = false
        totalChart.xAxis.granularity = 1
        totalChart.xAxis.labelPosition = .bottom
        totalChart.xAxis.decimals = 0
        totalChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        //totalChart.drawValueAboveBarEnabled = false
        
        totalChart.xAxis.granularityEnabled = true
        //totalChart.xAxis.setLabelCount(days.count, force: true)
        totalChart.xAxis.labelRotationAngle = -45
        
        
        totalChart.legend.enabled = true
        totalChart.doubleTapToZoomEnabled = false
  
    
        //totalChart.notifyDataSetChanged()

        
    } // totalUpdate
    
    
    func loadUserInfo() {
        
        let url = "\(Getsdone.API_ENDPOINT)\(Getsdone.API_USERS)"
        
        self.progress.startAnimating()
        
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
                    
                    if let raw = response.result.value {
                        
                        let j = JSON(raw)
                        
                        //print(j)
                        
                        self.uid = j["id"].string!
                        self.name.text = "@\(j["name"].string!)"
                        self.status.text = j["rankName"].string!
                        self.since.text = Getsdone.toReadableDate(j["created"].string!)
                    
                        self.loadAllTasks()
                        
                    }
                    
                }
        }
        
    } // loadUserInfo
    
    
    func loadAllTasks() {
        
        let url = "\(Getsdone.API_ENDPOINT)\(Getsdone.API_USERS)/\(uid)\(Getsdone.API_TASKS)"
        
        print(url)
        
        progress.startAnimating()
        
        Alamofire.request(url, method: .get, parameters: ["view": "all"])
            .responseJSON{ response in
                
                self.progress.stopAnimating()
                
                switch response.result {
                case .failure(let error):
                    
                    let ac = UIAlertController(title: "Connection error",
                                               message: error.localizedDescription,
                                               preferredStyle: UIAlertControllerStyle.alert)
                    
                    let OK = UIAlertAction(title: "OK",
                                           style: UIAlertActionStyle.default,
                                           handler: nil)
                    
                    ac.addAction(OK)
                    
                    self.present(ac, animated: true, completion: nil)
                    
                    
                case .success:
                    
                    if let raw = response.result.value {
                        
                        let j = JSON(raw)
                        
                        var all = [[String]]()
                        
                        for (_, task) in j {
                            
                            var t = [String]()
                            
                            //print(task)
                            
                            if task["delegateId"]["Valid"].bool! {
                                
                                if task["delegateId"]["String"].string! != self.uid {
                                    continue
                                }
                                
                            }
                            
                            t.append(task["ownerName"].string!)
                            t.append(task["task"].string!)
                            t.append(task["created"].string!)
                            
                            if task["actual"]["Valid"].bool! {
                                t.append(task["actual"]["String"].string!)
                            } else {
                                t.append("")
                            }
                            
                            //let count = task["comments"].array!.count
                            
                            //t.append(String(count)) // comments
                            t.append(task["id"].string!)
                            
                            if task["delegateId"]["Valid"].bool! {
                                t.append(task["delegateId"]["String"].string!)
                            } else {
                                t.append("")
                            }
                            
                            all.append(t)
                            
                        }
                        
                        /*if self.ascending == 0 {
                            self.tasks = all.reversed()
                        } else {
                            self.tasks = all
                        }*/
                        
                        self.tasks = all
                        self.analyzeTasks()
                        //self.tasksTable.reloadData()
                        
                    }
                }
        }
        
    } // loadAllTasks
    
    func analyzeTasks() {

        var completedTmp = [[String]]()
        var openTmp = [[String]]()
        
        for task in tasks {
            
            if task[3] != "" {
                completedTmp.append(task)
            } else {
                openTmp.append(task)
            }
            
            
        }
        
        self.completed = completedTmp
        self.open = openTmp
        
        print(completedTmp.count)
        print(openTmp.count)
        
        last7d()
        
    } // analyzeTasks
    
    func last7d() -> [String] {

        var res = [String]()
        
        print(tasks.count)
        let d = Date()
        
        print(d)
        
        let c = Calendar.current
        
        print(c.dateComponents([.day, .month], from: d))
  
        for task in open {
        
            print(task[2])
            
            let f = DateFormatter()
            
            f.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            
            let created = f.date(from: task[2])
            
            if created! > d {
                
            }
            
            
            
        }
        
        averageComplete()
        return res
        
        
    } // last7d
    
    
    func averageComplete() {
        
        var total = 0
        
        let f = DateFormatter()
        
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        
        for task in completed {
        
            let created = f.date(from: task[2])
            let actual  = f.date(from: task[3])
            
            let delta = actual?.timeIntervalSince(created!)
            
            print(delta)
            
            total = total + Int(delta!)
            
        }
        
        let ti = TimeInterval(roundf(Float(total))/Float(completed.count))
        
        let f2 = DateComponentsFormatter()
        
        f2.allowedUnits = [.day, .hour, .minute, .second]
        f2.unitsStyle = .abbreviated
        f2.maximumUnitCount = 1
        
        let x = f2.string(from: ti)
        
        print(x)
        avgCompleteLbl.text = x!
        
    } // averageComplete
    
    
    // MARK: Actions
    
    
} // ProfileController
