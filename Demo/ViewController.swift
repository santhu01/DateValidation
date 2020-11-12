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
    
    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var endDateLbl: UILabel!
    @IBOutlet weak var dataTableView: UITableView!
    
    var senderTag = 0
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        entityDesc = NSEntityDescription.entity(forEntityName: "DateValidation", in: managedContext)
        
        dataTableView.delegate = self
        dataTableView.dataSource = self
        
        //Printing path of core data database file
        print(NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).last!)

    }
    
    //Func to show date picker
    func showDatePicker(){
        
        datePicker.isHidden = false
        datePicker.frame = CGRect(x: 0, y: Int(view.bounds.height)-200, width: Int(view.bounds.width), height: 200)
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .lightGray
        datePicker.addTarget(self, action: #selector(onDatePick), for: .valueChanged)
        view.addSubview(datePicker)
    }
    
    
//DatePicker Click
    @objc func onDatePick(){
        
        if senderTag == 1{
            
            print(formatDate())
            print("Get Today date: \(getTodayDate())")
            
            //Getting today's date
            let today = getTodayDate() as Date
            
            //picked date from date picker in date format
            let pickedDate = formatDate().0 as Date
            
                switch pickedDate.compare(today) {
                case .orderedSame :
                    print("Same day selected")
                    
                // createAlert(titleText: "Select Future Date!", msgTxt: "You have selected today's date!")
                    break // exact same
                    
                case .orderedAscending:
                     print("Past day selected")
                    
                    createAlert(titleText: "Select Future Date", msgTxt: "You have selected past date!")
                     
                    break
                
                case .orderedDescending:
                     print("Future day selected")
                     
                     let daysDiff = daysBetweenDates(startDate: today, endDate: pickedDate)
                     print(daysDiff)
                     
                     //if days are between 1 and 30
                     if daysDiff <= 30 {
                        startDateLbl.text = formatDate().1 //getting date in string format
                     }
                     else{
                        createAlert(titleText: "Days Exeeded!", msgTxt: "Choose no.of days between 1 & 30")
                     }
                    break
            }
            datePicker.isHidden = true
            
        }
        
        else if senderTag == 2{
            
            endDateLbl.text = "\(formatDate())"
        }
    }
    
    
    //Alert func for wrong date selection
    func createAlert(titleText: String, msgTxt: String?){
        
        let alertVC = UIAlertController(title: titleText, message: msgTxt, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel) { (action) in
           
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
    func getTodayDate()->NSDate{
        
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
        //let todayDate = formattedDate! as NSDate
        return formattedDate! as NSDate
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
    
    var dateList = [NSManagedObject]()
    
    @IBAction func saveBtnTap(_ sender: UIButton) {
    
    let managedObj = NSManagedObject(entity: entityDesc, insertInto: managedContext)
           
        managedObj.setValue(formatDate().0, forKey: "startDate")
           //managedObj.setValue(endDate, forKey: "endDate")
           
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
    
    
    @IBAction func fetchBtnTap(_ sender: UIButton) {
        
        let fetchData = NSFetchRequest<NSFetchRequestResult>(entityName: "DateValidation")
            
            do{
                
                dateList = try managedContext.fetch(fetchData) as! [NSManagedObject]
                
                if dateList.count == 0{
                    print("No records to show!")
                }
                else{
                    print("Fetching Success!")
                    dataTableView.reloadData()
                    print(type(of: dateList))
                    for i in 0..<dateList.count{
                    print(dateList[i].value(forKey: "startDate")! as Any)
                    }
                }
            }
            catch{
                print("Error fetching data!")
            }
        }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("students: ",studentList.count)
        return dateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = dataTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! dataTableViewCell
        
//        cell.idLabel.text = "\(studentList[indexPath.row].value(forKey: "id")!)"
//        cell.nameLabel.text = studentList[indexPath.row].value(forKey: "name") as? String
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        
        let formattedStartDate = "\(formatter.string(from: dateList[indexPath.row].value(forKey: "startDate") as! Date))"
        
        cell.startDateLbl.text = "\(formattedStartDate)"
        
        //let formattedEndDate = "\(formatter.string(from: dateList[indexPath.row].value(forKey: "endDate") as! Date))"
        
      //  cell.endDateLbl.text = "\(formattedEndDate)"
        
       // cell.endDateLbl.text = "\(studentList[indexPath.row].value(forKey: "endDate")!)"
        
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
