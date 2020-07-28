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
    
    override func viewDidLoad() {
    
        pickerData = ["Super","Sayisal"]
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
  
}

