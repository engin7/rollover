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
    var selectedValue = "Süper Loto"
    
    
    override func viewDidLoad() {
    
        pickerData = ["Süper Loto","Sayısal Loto"]
      
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        components.day = calendar.component(.day, from: Super(weeksBefore: 0).dateS)
        components.month = calendar.component(.month, from: Super(weeksBefore: 0).dateS)
        components.year = calendar.component(.year, from: Super(weeksBefore: 0).dateS)
        datePicker.setDate(calendar.date(from: components)!, animated: false)
        datePicker.maximumDate = Super(weeksBefore: 0).dateS
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -2, to: Date())
        
        datePickerValueChanged(datePicker)
    }
 
    
      func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
      inComponent component: Int) {
          datePickerValueChanged(datePicker)
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
        
        selectedValue = pickerData[lotteryType.selectedRow(inComponent: 0)]
         var before = 0
        
            if selectedValue == "Süper Loto"  {
                
                datePicker.isHidden = false

                  let components = Calendar.current.dateComponents([.weekOfYear], from: Super(weeksBefore: 0).dateS, to: sender.date)
                if sender.date >= Super(weeksBefore: 0).dateS {
                    before = abs(components.weekOfYear!)
                } else {
                    before = abs(components.weekOfYear!-1)
                }
                
                datePicker.setDate(Super(weeksBefore: before).dateS, animated: true)
           
    URLSession.shared.dataTask(with: Super(weeksBefore: before).url_super) { (data,
                  response, error) in
              
              guard let data = data else { return }

              do {
                  
                  //Decode data
                  let JSONDict = try JSONDecoder().decode(JSONTest.self, from: data)
                
                  //Get back to the main queue
                  DispatchQueue.main.async {
                       
                self.winnerNumbers.text = "Talihli sayılar: \(JSONDict.data!.rakamlarNumaraSirasi) "
                
                mockWinner = JSONDict.data!.rakamlarNumaraSirasi
                
                    let allowedChars = "0123456789"
                    var even = 0
                    var flag = false
                        mockResults  = []
                    var resultDummy = ""

                    for char in mockWinner {
                          
                        if allowedChars.contains(char) {
                        if even%2 == 0 && flag {
                            mockResults.append(String(resultDummy))
                            
                            resultDummy = ""
                        }
                        even += 1
                        flag = true
                       
                         resultDummy.append(char)
                        }
                    }
                    mockResults.append(String(resultDummy))
                    
                    
               }

              } catch let jsonError {
                  print(jsonError)
              }
              }
           
           .resume()
        }
      
        if selectedValue == "Sayısal Loto" {
             
             winnerNumbers.text = "Çok yakında..."
             datePicker.isHidden = true
        }
     }
    
}
 
