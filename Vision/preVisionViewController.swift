//
//  preVisionViewController.swift
//  Devreden
//
//  Created by Engin KUK on 28.07.2020.
//  Copyright © 2020 Silverback Inc. All rights reserved.
//

import Foundation
import UIKit


class preVisionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var pickerData: [String] = [String]()
    @IBOutlet weak var lotteryType: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var winnerNumbers: UILabel!
    let calendar = Calendar.current

    var components = DateComponents()
    var selectedValue = "Super Loto"
    
    
    override func viewDidLoad() {
    
        pickerData = ["Super Loto","Sayisal Loto"]
        
        selectedValue = pickerData[lotteryType.selectedRow(inComponent: 0)]

        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        components.day = calendar.component(.day, from: Super(weeksBefore: 0).dateS)
        components.month = calendar.component(.month, from: Super(weeksBefore: 0).dateS)
        components.year = calendar.component(.year, from: Super(weeksBefore: 0).dateS)
        datePicker.setDate(calendar.date(from: components)!, animated: false)
        
    }
 
    
     func numberOfComponents(in lotteryType: UIPickerView) -> Int {
         return 1
     }
         
     func pickerView(_ lotteryType: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         return 2
     }

    func pickerView(_ lotteryType: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
      
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        
        let weekday = calendar.component(.weekday, from: sender.date)
      
            if selectedValue == "Super Loto" && weekday != 5 {
                  let components = Calendar.current.dateComponents([.weekOfYear], from: Super(weeksBefore: 0).dateS, to: sender.date)
                let before:Int
                if sender.date < Super(weeksBefore: 0).dateS {
                before = abs(components.weekOfYear!-1)
                } else {
                before = abs(components.weekOfYear!)
                }
                
                datePicker.setDate(Super(weeksBefore: before).dateS, animated: true)
            }
    }
    
}
 

