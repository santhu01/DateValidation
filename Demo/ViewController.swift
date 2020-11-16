//
//  ViewController.swift
//  Demo
//
//  Created by Santhosh on 03/11/20.
//  Copyright © 2020 CodeinSwift. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var appDelegate: AppDelegate!
    var managedContext: NSManagedObjectContext!
    var entityDesc: NSEntityDescription!
    var dateList = [NSManagedObject]()
    
    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var endDateLbl: UILabel!
    @IBOutlet weak var dataTableView: UITableView!
    @IBOutlet weak var startDateBtnObj: UIButton!
    @IBOutlet weak var endDateBtnObj: UIButton!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var endTimeLbl: UILabel!
    @IBOutlet weak var startTimeBtnObj: UIButton!
    @IBOutlet weak var endTimeBtnObj: UIButton!
    
    var senderTag = 0
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    var minHours: Date?
    var maxHours: Date?
    let date = Date()
    let calendar = Calendar.current
    
    var pickedStartTimeArr : NSArray = []
    var pickedStartTime: Date?
    var pickedEndTime: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        entityDesc = NSEntityDescription.entity(forEntityName: "DateValidation", in: managedContext)
        
        dataTableView.delegate = self
        dataTableView.dataSource = self
        
        //Printing path of core data database file
        print(NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).last!)
        
        endDateBtnObj.isEnabled = false

    }
    
    //Func to show date picker
    func showDatePicker(){
        
        datePicker.isHidden = false
        datePicker.frame = CGRect(x: 0, y: Int(view.bounds.height)-200, width: Int(view.bounds.width), height: 200)
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .lightGray
        datePicker.addTarget(self, action: #selector(onDatePick), for: .valueChanged)
        datePicker.minimumDate = .none
        datePicker.maximumDate = .none
        
        view.addSubview(datePicker)
    }
    
    //Func to show date picker for time
       func showTimePicker(){
           
        datePicker.isHidden = false
        datePicker.frame = CGRect(x: 0, y: Int(view.bounds.height)-200, width: Int(view.bounds.width), height: 200)
        datePicker.datePickerMode = .time
        datePicker.backgroundColor = .lightGray
        datePicker.addTarget(self, action: #selector(onDatePick), for: .valueChanged)
        view.addSubview(datePicker)
       }
    
//DatePicker Click
    var pickedStartDate: Date?
    var isPickedStartDateValid = false
    var isPickedEndDateValid = false
    var isPickedStartTimeValid = false
    var isPickedEndTimeValid = false
    var pickedEndDate: Date?
    
    @objc func onDatePick(){
        
        if senderTag == 1{
            
            print(formatDate())
            print("Get Today date: \(getTodayDate())")
            
            //Getting today's date
            let today = getTodayDate().0 as Date
            
            //picked date from date picker in date format
            pickedStartDate = formatDate().0 as Date
            
            switch pickedStartDate?.compare(today) {
            case .orderedSame :
                print("Same day selected")
                startDateLbl.text = formatDate().1 //getting date in string format
                isPickedStartDateValid = true
                datePicker.isHidden = true
                endDateBtnObj.isEnabled = true
                // createAlert(titleText: "Select Future Date!", msgTxt: "You have selected today's date!")
                break // exact same
                
            case .orderedAscending:
                print("Past day selected")
                
                createAlert(titleText: "Select Future Date", msgTxt: "You have selected past date!")
                
                break
                
            case .orderedDescending:
                print("Future day selected")
                
                let daysDiff = daysBetweenDates(startDate: today, endDate: pickedStartDate!)
                print(daysDiff)
                
                //if days are between 1 and 30
                if daysDiff <= 30 {
                    startDateLbl.text = formatDate().1 //getting date in string format
                    isPickedStartDateValid = true
                    datePicker.isHidden = true
                    endDateBtnObj.isEnabled = true
                }
                    
                else{
                    createAlert(titleText: "Days Exeeded!", msgTxt: "Choose no.of days between 1 & 30")
                    //isPickedStarDateValid = false
                }
                break
            case .none:
                print("Nothing")
            }
            
            
        }
        
        else if senderTag == 2{
            
            print("Get Picked Start date: \(pickedStartDate!)")
            
            //Getting today's date
            
            //picked date from date picker in date format
            pickedEndDate = formatDate().0 as Date
            
            switch pickedEndDate?.compare(pickedStartDate!) {
            case .orderedSame :
                print("Same day selected")
                
                endDateLbl.text = formatDate().1 //getting date in string format
                isPickedEndDateValid = true
                datePicker.isHidden = true
                // createAlert(titleText: "Select Future Date!", msgTxt: "You have selected today's date!")
                break // exact same
                
            case .orderedAscending:
                print("Past day selected")
                createAlert(titleText: "Select Future Date", msgTxt: "You have selected past date!")
                
                break
                
            case .orderedDescending:
                print("Future day selected")
                
                let daysDiff = daysBetweenDates(startDate: pickedStartDate!, endDate: pickedEndDate!)
                print(daysDiff)
                
                //if days are between 1 and 30
                
                    if daysDiff <= 30{
                        endDateLbl.text = formatDate().1 //getting date in string format
                        isPickedEndDateValid = true
                        datePicker.isHidden = true
                    }
                    
                else{
                    createAlert(titleText: "Days Exeeded!", msgTxt: "Choose no.of days between 1 & 30")
                }
                break
            case .none:
                print("Nothing!")
            }
            
        }
        
        
        
        else if senderTag == 3{
            
            
            
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)
            
            print("\(hour):\(minutes):\(seconds)")
            let todayCompo = calendar.dateComponents([.year, .month, .day], from: date)
            
            let pickedStartDateCompo = calendar.dateComponents([.year, .month, .day], from: pickedStartDate!)
            
           // var maxHours = date + 3600 * 5
            minHours = calendar.date(byAdding: .minute, value: 1, to: date)!
           // let minHours = date + 1
            //
            maxHours = calendar.date(byAdding: .hour, value: 5, to: date)!
            
            print(pickedStartDateCompo)
            print(todayCompo)
            print("minHours: \(type(of: minHours)) , maxHours: \(type(of: maxHours))")
//            let pickedDateFormat = DateFormatter()
//            pickedDateFormat.dateStyle = .medium
//
//
//
//            let dateFormat = DateFormatter()
//            dateFormat.dateStyle = .medium
//
            
            if todayCompo == pickedStartDateCompo{
               
                datePicker.maximumDate = maxHours
                datePicker.minimumDate = minHours
                
                print("Please pick future time!")
                
            }
            else if todayCompo != pickedStartDateCompo{
                datePicker.maximumDate = .none
            }
            pickedStartTimeArr = [formatTime().0, formatTime().1, formatTime().2,formatTime().3, formatTime().4]
            startTimeLbl.text = "\(formatTime().1)"
            pickedStartTime = formatTime().0 as Date
            isPickedStartTimeValid = true
        }
        
        else if senderTag == 4{
            
           // var pickedStartTime = formatTime().0
            pickedStartTime = calendar.date(bySettingHour: pickedStartTimeArr[2] as! Int, minute: pickedStartTimeArr[3] as! Int, second: pickedStartTimeArr[4] as! Int, of: datePicker.date)! as Date
            
            maxHours = calendar.date(byAdding: .hour, value: 5, to: pickedStartTime! as Date)
            minHours = pickedStartTime! as Date
            datePicker.maximumDate = maxHours
            datePicker.minimumDate = minHours
            //print(startTime!)
            print("Picked formatted Start time: ",pickedStartTimeArr[1])
            print("Picked Starttime: ",pickedStartTime!)
            pickedEndTime = formatTime().0 as Date
            
            endTimeLbl.text = "\(formatTime().1)"
            datePicker.isHidden = true
            isPickedEndTimeValid = true
        }
        
    }
        
    
    
    
    //Alert func for wrong date selection
    func createAlert(titleText: String, msgTxt: String?){
        
        let alertVC = UIAlertController(title: titleText, message: msgTxt, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel) { (action) in
            self.isPickedStartDateValid = false
            self.datePicker.isHidden = false
            self.endDateBtnObj.isEnabled = false
        }
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
        
    }
    
    
    //Calculating no.of days between current date and picked date
    func daysBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.day], from: startDate, to: endDate)
        return components.day!
    }
    
    
    //Getting today's date func
    func getTodayDate() -> (NSDate, String){
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let year =  components.year
        let month = components.month
        let day = components.day
        print("Today: \(day!)/\(month!)/\(year!)")
       
        // let today = "\(day!)/\(month!)/\(year!)"
       
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        let formattedDate = calendar.date(from: components)
        print("Formatted Date Comp: \(formattedDate!)")
        
        
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: date)
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "H:mm:ss"
        let formattedTime = calendar.date(from: timeComponents)
        let currentTime = timeFormatter.string(from: formattedTime!)
        
        print("formattedTime: \(currentTime)")
        //let todayDate = formattedDate! as NSDate
        return (formattedDate! as NSDate, currentTime)
    }
    
    
    //Formatting date in both ways: date format and string format
    func formatDate() -> (NSDate, String){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: datePicker.date)
        let formattedDate = calendar.date(from: components)
        //let formattedDate = Calendar.date(from: datePicker.date)
        //print("date from formatDate: ", formattedDate)
        
        let stringDate = formatter.string(from: datePicker.date)
        print("formatDate date picker value: \(formattedDate!)")
        print("stringDate: \(stringDate)")
        
        return (formattedDate! as NSDate, stringDate)
    }
    
    
    func formatTime() -> (NSDate, String, Int, Int, Int){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
       // formatter.timeStyle = .medium
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: datePicker.date)
        let formattedDate = calendar.date(from: components)
        let stringTime = formatter.string(from: formattedDate!)
        
        let pickedHour = components.hour
        let pickedMinutes = components.minute
        let pickedSeconds = components.second
        print("\(pickedHour!):\(pickedMinutes!):\(pickedSeconds!)")
        return (formattedDate! as NSDate, stringTime, pickedHour!, pickedMinutes!, pickedSeconds!)
    }
    
    //Start Date button click
    @IBAction func startDateTap(_ sender: UIButton) {
        senderTag = sender.tag
        showDatePicker()
    }
    
    //End Date button click
    @IBAction func endDateTap(_ sender: UIButton) {
        senderTag = sender.tag
        showDatePicker()
    }
    
    
    @IBAction func startTimeTap(_ sender: UIButton) {
        senderTag = sender.tag
        showTimePicker()
    }
    
    
    @IBAction func endTimeTap(_ sender: UIButton) {
        senderTag = sender.tag
        showTimePicker()
        
    }
    
    
    // Save button code
    @IBAction func saveBtnTap(_ sender: UIButton) {
    
    let managedObj = NSManagedObject(entity: entityDesc, insertInto: managedContext)
       
        if(isPickedStartDateValid && isPickedEndDateValid && isPickedStartTimeValid && isPickedEndTimeValid){
            
            if someEntityExists(startDate: pickedStartDate!, endDate: pickedEndDate!){
                print("date already!")
                fetchReq.predicate = .none
                
            }
            else{
                managedObj.setValue(pickedStartDate!, forKey: "startDate")
                managedObj.setValue(pickedEndDate!, forKey: "endDate")
                managedObj.setValue(pickedStartTime!, forKey: "startTime")
                managedObj.setValue(pickedEndTime!, forKey: "endTime")
                
                do{
                    try managedContext.save()
                    dateList.append(managedObj)
                    print("Data Saved!")
                    print(formatDate().0)
                    //dataTableView.reloadData()
                }
                catch{
                    print("Error Saving Data!")
                }

            }
           
        }
//            switch pickedStartDate?.compare(pickedEndDate!){
//            case .orderedAscending:
//                print("Past day")
//                managedObj.setValue(pickedStartDate!, forKey: "startDate")
//                       managedObj.setValue(pickedEndDate!, forKey: "endDate")
//
//                          do{
//                              try managedContext.save()
//                              dateList.append(managedObj)
//                              print("Data Saved!")
//                           print(formatDate().0)
//                              //dataTableView.reloadData()
//                          }
//                          catch{
//                              print("Error Saving Data!")
//                          }
//
//            case .orderedDescending:
//                print("future day")
//
//            case .some(.orderedSame):
//                print("same day")
//            case .none:
//                print("nothing")
//            }
//        }
       
        else{
            print("Select valid dates!")
        }
}
    
    
    var fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "DateValidation")
    
    //Fetch Button code
    @IBAction func fetchBtnTap(_ sender: UIButton) {
            
            do{
                
                dateList = try managedContext.fetch(fetchReq) as! [NSManagedObject]
                
                if dateList.count == 0{
                    print("No records to show!")
                    return
                   // fetchReq.predicate = nil
                }
                else{
                    print("Fetching Success!")
                   // fetchReq.predicate = .none
                   // fetchReq.predicate = nil
                    dataTableView.reloadData()
                    print("Date List from FetchBtnTap: \(dateList.count)")
                    
                    //Just for printing dates
                    for i in 0..<dateList.count{
                        if let startDate = dateList[i].value(forKey: "startDate"),
                            let endDate = dateList[i].value(forKey: "endDate"),
                            let startTime = dateList[i].value(forKey: "startTime"),
                            let endTime = dateList[i].value(forKey: "endTime") {
                            print(startDate)
                            print(endDate)
                            print(startTime)
                            print(endTime)
                        }
                        
                    }
                    
                    
                }
            }
            catch{
                print("Error fetching data!")
            }
        }
    
    
    
    func someEntityExists(startDate: Date, endDate: Date) -> Bool{
        
       //let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DateValidation")
       // fetchReq.includesSubentities = false
        fetchReq.predicate = NSPredicate(format: "startDate == %@ AND endDate == %@", startDate as NSDate, endDate as NSDate)
        
        
        var entitiesCount = 0
        do {
            entitiesCount = try managedContext.count(for: fetchReq)
            print("dateList:: ",dateList.count)
            print("ManagedContent Count: \(entitiesCount)")
            
           // dataTableView.reloadData()
        }catch{
            print("Error finding")
        }
        fetchReq.predicate = nil
        
        return entitiesCount > 0
    }
    
    
}


//Tableview extension
extension ViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = dataTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! dataTableViewCell
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        
        
        let formattedStartDate = "\(formatter.string(from: dateList[indexPath.row].value(forKey: "startDate") as! Date))"
        
        cell.startDateLbl.text = "\(formattedStartDate)"
        
        
        let formattedEndDate = "\(formatter.string(from: dateList[indexPath.row].value(forKey: "endDate") as! Date))"
        
       // cell.endDateLbl.text = "\(dateList[indexPath.row].value(forKey: "endDate")!)"
        cell.endDateLbl.text = "\(formattedEndDate)"
        
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        let formattedStartTime = "\(timeFormatter.string(from: dateList[indexPath.row].value(forKey: "startTime") as! Date))"
        cell.startTimeLbl.text = "\(formattedStartTime)"
        
        let formattedEndTime = "\(timeFormatter.string(from: dateList[indexPath.row].value(forKey: "endTime") as! Date))"
        cell.endTimeLbl.text = "\(formattedEndTime)"
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            //Row deletion goes here
        }
        
    }

    
}
