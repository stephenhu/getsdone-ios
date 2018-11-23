//
//  ProfileController.swift
//  getsdone-ios
//
//  Created by hu on 6/28/18.
//  Copyright © 2018 stephenhu. All rights reserved.
//

//import Photos
import UIKit

import Alamofire
import Charts
import Font_Awesome_Swift
import Kingfisher
import SwiftyJSON

class ProfileController: UIViewController, UIImagePickerControllerDelegate,
  UINavigationControllerDelegate {
    
    let defaults = UserDefaults.standard
    let picker = UIImagePickerController()
    
    var uid = String()
    
    var ranks       = [[String]]()
    var tasks       = [[String]]()
    var open        = [[String]]()
    var completed   = [[String]]()
    
    
    // MARK: Properties
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var since: UILabel!
    @IBOutlet weak var totalChart: BarChartView!
    @IBOutlet weak var ranking: UIProgressView!
    @IBOutlet weak var avgCompleteLbl: UILabel!
    @IBOutlet weak var nextLevelLbl: UILabel!
    @IBOutlet weak var iconUpdateBtn: UIButton!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var currentLevelLbl: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        
        loadUserInfo()
        //totalUpdate()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        icon.setFAIconWithName(icon: FAType.FAUserO, textColor: UIColor.black)
     
        ranking.layer.cornerRadius = 5
        
        self.view.bringSubview(toFront: progress)
        
        picker.delegate = self
        
        totalChart.pinchZoomEnabled = false
        totalChart.legend.enabled = true
        totalChart.doubleTapToZoomEnabled = false
        totalChart.borderLineWidth = 1
        totalChart.borderColor = Getsdone.LightGrayColor
        totalChart.drawValueAboveBarEnabled = true
        totalChart.chartDescription?.enabled = false
        totalChart.drawBordersEnabled = false
        totalChart.drawGridBackgroundEnabled = false
        
        
        //totalChart.drawGridBackgroundEnabled = false
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as? String
        
        if mediaType! == Getsdone.MEDIA_TYPE_IMAGE {
        
            let imageURL = info[UIImagePickerControllerImageURL] as? URL
            
            let d = try! Data(contentsOf: imageURL!)
            
            let img = UIImage(data: d)!
            
            let thumb = img.kf.resize(to: CGSize(width: 128, height: 128))
            
            uploadIcon(thumb)
            
            
        }
        
        dismiss(animated: true, completion: nil)
        
    } // imagePickerController
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    } // imagePickerControllerDidCancel
    
    
    func uploadIcon(_ image: UIImage) {
        
        let url = "\(Getsdone.API_ENDPOINT)\(Getsdone.API_ICONS)"
        
        print(url)
        
       /*
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(image., withName: "icon")
        }, to: url, encodingCompletion: { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.response{ response in
                    // reload page
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
        */
        
        let d = UIImagePNGRepresentation(image)!
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(d, withName: "icon", fileName: "icon.png", mimeType: "image/png")
        }, to: url, encodingCompletion: { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.response{ response in
                    print(response)
                    self.loadAllTasks()
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
        
        
        /*
        print(d.count)
        Alamofire.upload(d, to: url).response {
            response in
            
            print(response)
        }
        */
    } // uploadIcon
    
    
    func totalUpdate(openData: [Int], closedData: [Int], days: [String]) {
        
        //let e = openData.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: Double(y))}
        //let e = openData.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: Double(y))}
        //let f = closedData.enumerated().map { x, y in return ChartDataEntry(x: Double(x), y: Double(y))}
        
        let e = openData.enumerated().map { x, y in return BarChartDataEntry(x: Double(x), y: Double(y))}
        let f = closedData.enumerated().map { x, y in return BarChartDataEntry(x: Double(x), y: Double(y))}
        
        //let ds1 = LineChartDataSet(values: e, label: "Open")
        let ds1 = BarChartDataSet(values: e, label: "Open")
        //let ds2 = LineChartDataSet(values: f, label: "Completed")
        let ds2 = BarChartDataSet(values: f, label: "Completed")
        
        //let dsx = BarChartDataSet(values: f, label: "")
        
        //dsx.colors = [Getsdone.TealColor, UIColor.red]
        //dsx.stackLabels = ["Open", "Closed"]
        //dsx.valueTextColor = .clear
        
        ds1.colors = [Getsdone.TealColor]
        //ds1.barBorderColor = Getsdone.BlueColor
        //ds1.barBorderWidth = 1
        //dataSet.setCircleColor(UIColor.red)
        //ds1.mode = .horizontalBezier
        
        //ds1.lineWidth = 3.5
        //ds1.drawCircleHoleEnabled = false
        //ds1.drawCirclesEnabled = false
        //dataSet.circleRadius = 4
        //ds1.drawFilledEnabled = true
        //let g1 = [Getsdone.LightTealColor.cgColor, Getsdone.TealColor.cgColor] as CFArray
        
        //let cl:[CGFloat] = [0.0, 1.0]
        
        //let gr = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(),
        //                         colors: g1, locations: cl)
        
        //ds1.fill = Fill.fillWithLinearGradient(gr!, angle: 90.0)
        //ds1.fillColor = Getsdone.TealColor
        //dataSet.valueFont = UIFont(name: "Arial", size: 28.0)!
        //ds1.fillAlpha = 0.1
        ds1.drawValuesEnabled = true
        
        //ds2.colors = [Getsdone.RedColor]
        ds2.colors = [UIColor.red]
        //ds2.barBorderColor = Getsdone.RedColor
        //ds2.barBorderWidth = 1
        //ds2.mode = .horizontalBezier
        //ds2.lineWidth = 3.5
        //ds2.drawCircleHoleEnabled = false
        //ds2.drawCirclesEnabled = false
        //dataSet.circleRadius = 4
        //ds2.drawFilledEnabled = true
        //ds2.fillColor = UIColor.red
        //ds2.fillAlpha = 0.1
        //ds2.drawValuesEnabled = false
        
        //let days = ["Sep 10", "Sep 11", "Sep 12", "Sep 13", "Sep 14", "Sep 15", "Sep 16"]
        //let data = BarChartData(xVals: days, dataSets: [dataSet])
        
        //let data = LineChartData(dataSets: [ds1, ds2])
        
        //let data = CombinedChartData()
        
        //data.lineData = LineChartData(dataSet: ds1)
        
        //data.barData = BarChartData(dataSet: ds2)
        // (bar width + bar space) * # bars + group space = 1.0
        // (0.3 + 0.05) * 2 + 0.3  = 1
        // (0.3 + 0.05) * 2 + 0.3 = 1.00
        //let data = LineChartData(dataSets: [ds1, ds2])
        
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3
        let groupCount = 5.0
        
        let data = BarChartData(dataSets: [ds1, ds2])
        
        data.barWidth = barWidth
        
        let format = NumberFormatter()
        
        format.generatesDecimalNumbers = false
        
        let formatter = DefaultValueFormatter(formatter: format)
        
        data.setValueFormatter(formatter)
        
        totalChart.data = data

        data.groupBars(fromX: Double(0),
                       groupSpace: groupSpace, barSpace: barSpace)
        
        //totalChart.chartDescription?.text = "Open vs Closed"

        
        //totalChart.gridBackgroundColor = .clear
        totalChart.leftAxis.drawGridLinesEnabled = false
        totalChart.leftAxis.drawZeroLineEnabled = false
        totalChart.leftAxis.drawTopYLabelEntryEnabled = true
        totalChart.leftAxis.drawBottomYLabelEntryEnabled = false
        totalChart.leftAxis.drawLabelsEnabled = false
        totalChart.leftAxis.drawAxisLineEnabled = false
        //totalChart.leftAxis.granularity = 1.0
        totalChart.leftAxis.decimals = 0
        totalChart.leftAxis.granularityEnabled = true
        totalChart.leftAxis.axisMinimum = 0
        //totalChart.leftAxis.axisMaximum = totalChart.leftAxis.axisMaximum + 1
        totalChart.leftAxis.labelTextColor = .black
        totalChart.leftAxis.drawTopYLabelEntryEnabled = true
        //totalChart.leftAxis.valueFormatter = nf as? IAxisValueFormatter

        //totalChart.leftAxis.valueFormatter.minimumFractionDigits = 0
        //totalChart.leftAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        
        totalChart.rightAxis.enabled = false
        /*
        totalChart.rightAxis.drawGridLinesEnabled = false
        totalChart.rightAxis.drawZeroLineEnabled = false
        totalChart.rightAxis.drawAxisLineEnabled = false
        totalChart.rightAxis.drawLabelsEnabled = false
        totalChart.rightAxis.drawTopYLabelEntryEnabled = false
        totalChart.rightAxis.drawZeroLineEnabled = false
        totalChart.rightAxis.decimals = 0
        totalChart.rightAxis.drawBottomYLabelEntryEnabled = false
        */
        
        totalChart.xAxis.drawGridLinesEnabled = false
        totalChart.xAxis.drawAxisLineEnabled = false
        totalChart.xAxis.granularity = 1
        totalChart.xAxis.labelPosition = .bottom
        totalChart.xAxis.labelTextColor = .black
        totalChart.xAxis.avoidFirstLastClippingEnabled = true
        totalChart.xAxis.axisMinimum = 0
        totalChart.xAxis.centerAxisLabelsEnabled = true

        
        
        totalChart.xAxis.axisMaximum = Double(0) + data.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * groupCount
        //totalChart.xAxis.axisMaximum = totalChart.xAxis.axisMaximum + 1
        
        
        
        let f1 = DateFormatter()
        f1.dateFormat = "MM-dd-yyyy"
        
        let f2 = DateFormatter()
        f2.dateFormat = "MMM dd"
        
        let daysf = days.map { x in return f2.string(from: f1.date(from: x)!) }
        totalChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: daysf)
        
        //totalChart.drawValueAboveBarEnabled = false
        
        //totalChart.xAxis.granularityEnabled = true
    
        totalChart.notifyDataSetChanged()

        
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
                        
                        print(j)
                        
                        self.uid = j["id"].string!
                        self.name.text = "@\(j["name"].string!)"
                        //self.status.text = "Level \(j["rankName"].string!)"
                        self.since.text = Getsdone.toReadableDate(j["created"].string!)
                    
                        if j["icon"]["Valid"].bool! {
                        
                            let ico = URL(string: "\(Getsdone.ROOT_ENDPOINT)/\(j["icon"]["String"].string!)")
                            
                            self.icon.kf.setImage(with: ico)
                            
                        } else {
                            self.icon.setFAIconWithName(icon: FAType.FAUser, textColor: .black)
                        }
                        
                        self.loadAllTasks()
                        
                    }
                    
                }
        }
        
    } // loadUserInfo
    
    
    func loadRanks() {
        
        let url = "\(Getsdone.API_ENDPOINT)\(Getsdone.API_RANKS)"
        print(url)
        
        progress.startAnimating()
        
        Alamofire.request(url, method: .get)
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
                        
                        for (_, rank) in j {
                            
                            var r = [String]()
                            
                            r.append(rank["id"].string!)
                            r.append(rank["name"].string!)
                            r.append(String(rank["count"].int!))
                            
                            all.append(r)
                            
                        }
                        
                        self.ranks = all
                        self.showRanking()
                        //self.tasksTable.reloadData()
                        
                    }
                }
        }
        
    } // loadRanks
    
    
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

                            if task["deferred"].bool! {
                                t.append("deferred")
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
        // TODO: don't count deferred
        for task in tasks {
            
            if task[3] != "" {
                completedTmp.append(task)
            } else {
                
                if task[6] != "deferred" {
                    openTmp.append(task)
                }
                
            }
            
            
        }
        
        self.completed = completedTmp
        self.open = openTmp
        
        let dp = lastd()
        
        totalUpdate(openData: dp.open, closedData: dp.closed, days: dp.days)
        
        loadRanks()
        
    } // analyzeTasks
    
    
    func getLastDays(_ count: Int) -> [String] {
        
        if count < 1 {
            print("days must be 0 or more error")
        }
        
        var last = [String]()
        
        let d = Date()
        
        var c = Calendar.current
        
        c.timeZone = TimeZone(abbreviation: "UTC")!
    
        
        let f = DateFormatter()
        
        f.dateFormat = "MM-dd-yyyy"
        
        let sd = f.string(from: d)
        
        //last.append(sd)
 
        var com = DateComponents()
        
        for i in (0..<count).reversed() {
            
            com.day = i * -1
            
            let d2 = f.date(from: sd)
            let n = c.date(byAdding: com, to: d2!)
            
            last.append(f.string(from: n!))
            
        }
        
        return last
        
    } // getLastDays
    
    
    func lastd() -> (open: [Int], closed: [Int], days: [String]) {

        var openRes = [Int]()
        var closedRes = [Int]()
        
        let dates = getLastDays(5)

        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let f2 = DateFormatter()
        f2.dateFormat = "MM-dd-yyyy"

        for day in dates {

            var openCount = 0
            var closedCount = 0
            
            for task in tasks {
                
                let created = f.date(from: task[2])
                let cstr = f2.string(from: created!)
                
                if task[3] != "" {

                    let actual  = f.date(from: task[3])
                    let astr = f2.string(from: actual!)
                    
                    if astr == day {
                        closedCount = closedCount + 1
                    }
                    
                    if cstr <= day && astr > day {
                        openCount = openCount + 1
                    }
                    
                } else {
                
                    if cstr <= day {
                        
                        if task[6] != "deferred" {
                          openCount = openCount + 1
                        }
                        
                    }
                }
                
                
                
            }
            
            openRes.append(openCount)
            closedRes.append(closedCount)

        }
        
        averageComplete()

        return (openRes, closedRes, dates)
        
        
    } // lastd
    
    
    func averageComplete() {
        
        var total = 0.0
        
        if completed.count == 0 {
                avgCompleteLbl.text = "N/A"
        } else {

            let f = DateFormatter()
            
            f.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            
            for task in completed {
                
                let created = f.date(from: task[2])
                let actual  = f.date(from: task[3])
                
                let delta = actual?.timeIntervalSince(created!)
                
                total = total + delta!
                
            }
            
            let ti = TimeInterval(total/Double(completed.count))
            
            print(ti)
            
            let f2 = DateComponentsFormatter()
            
            f2.allowedUnits = [.day, .hour, .minute, .second]
            f2.unitsStyle = .abbreviated
            f2.maximumUnitCount = 1
            
            let x = f2.string(from: ti)
            
            avgCompleteLbl.text = x!

        }
        
    } // averageComplete
    
    func showRanking() {
        
        var plevel = "1"
        
        for r in ranks {
        
            if completed.count < Int(r[2])! {
 
                let remain = Int(r[2])! - completed.count
                self.nextLevelLbl.text = "Tasks until next level"
                self.status.text = "\(remain)"
                self.currentLevelLbl.text = "Level \(plevel) "
                self.totalLbl.text = "\(completed.count)"
                
                let p = Float(completed.count)/Float(r[2])!
                
                self.ranking.setProgress(p, animated: true)
                break
                
            }
            
            plevel = r[1]
            

            
        }
        
    } // showRanking
    
    
    // MARK: Actions
    
    @IBAction func updateIcon(_ sender: Any) {
        
        // PhotoBrowser
        // Create thumbnail
        // Upload
        // refresh page
        
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        present(picker, animated: true, completion: nil)
        
    }
    
} // ProfileController
