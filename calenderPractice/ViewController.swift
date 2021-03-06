//
//  ViewController.swift
//  calenderPractice
//
//  Created by Paige Walters on 11/20/17.
//  Copyright © 2017 Paige Walters. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController {
   
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!

    
    let outsideMonthColor = UIColor(colorWithHexValue: 0x584A66)
    let monthColor = UIColor.white
    let selectedMonthColor = UIColor(colorWithHexValue: 0x3A294B)
    let currentDateSelectedViewColor = UIColor(colorWithHexValue: 0x4E3F5D)
    
    
    let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.scrollToDate(Date())
        calendarView.selectDates([Date()])
        
        
        setUpCalendar()
    }
    
    func setUpCalendar() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        calendarView.visibleDates { (visibleDates) in
            self.setUpViewsOfCalendar(from: visibleDates)
            
        }
    }
    
    func handleCellTextColor(view:JTAppleCell?, cellState: CellState){
 
            
        guard let validCell = view as? CustomCell else { return }
        
        if cellState.isSelected {
            validCell.dateLabel.textColor = selectedMonthColor
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
            } else {
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
        
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        let todaysDate = Date()
        
        formatter.dateFormat = "yyyy MM dd"
        
        let todaysDateString = formatter.string(from: todaysDate)
        let monthDateString = formatter.string(from: cellState.date)
        
        guard let validCell = view as? CustomCell else { return }
        
        if todaysDateString <= monthDateString {
           validCell.isUserInteractionEnabled = true
        } else {
            validCell.isUserInteractionEnabled = false
        }
        
        if validCell.isSelected {
            
            let firstShiftSelection = UIAlertAction(title: "1st Shift", style: .default, handler: { (action) in
                print("You selected 1st shift!")
                
                //present a new view with a list of available employees for date selected
                //mark shift as filled with blank number of employees
                //Change Color of date when employees are scheduled for that date vs need to schedule
            
            })
            let secondShiftSelection = UIAlertAction(title: "2nd Shift", style: .default, handler: { (alert) in
                print("You selected 2nd shift!")
                //present a new view with a list of available employees for date selected
                //mark shift as filled with blank number of employees
                //Change Color of date when employees are scheduled for that date vs need to schedule

            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                print("You canceled this action")
            })
            
            let alert = UIAlertController(title: monthLabel.text! + " " + validCell.dateLabel.text!, message: "Are both shifts filled?", preferredStyle: .alert)
            alert.addAction(firstShiftSelection)
            alert.addAction(secondShiftSelection)
            alert.addAction(cancel)
            
            present(alert, animated: true, completion: nil)
        
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }
    
    func setUpViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        self.formatter.dateFormat = "yyyy"
        self.yearLabel.text = self.formatter.string(from: date)
        
        
        self.formatter.dateFormat = "MMMM"
        self.monthLabel.text = self.formatter.string(from: date)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: JTAppleCalendarViewDataSource {
    public func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 10 01")!
        let endDate = formatter.date(from: "2018 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
}

extension ViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        // This function should have the same code as the cellForItemAt function
        let myCustomCell = cell as! CustomCell
        
        sharedFunctionToConfigureCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let myCustomCell = calendar.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        sharedFunctionToConfigureCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
        return myCustomCell
    }
    
    func sharedFunctionToConfigureCell(myCustomCell: CustomCell, cellState: CellState, date: Date) {
        myCustomCell.dateLabel.text = cellState.text
        handleCellSelected(view: myCustomCell, cellState: cellState)
        handleCellTextColor(view: myCustomCell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setUpViewsOfCalendar(from: visibleDates)
    }
  
}

extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha: CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
            )
    }
}
