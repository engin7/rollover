//
//  ViewController.swift
//  Devreden
//
//  Created by Engin on 5.06.2019.
//  Copyright © 2019 Silverback Inc. All rights reserved.
//

import UIKit
import Foundation
import UserNotifications
 
// TODO: stripe support, Userdefaults for slider,



// for json structure (array in array)
struct JSONTest: Codable {
    var data: Datam?
}

struct Datam: Codable {
    var haftayaDevredenTutar: Double
    var cekilisTarihi: String
    var rakamlarNumaraSirasi: String
    var devirSayisi: Int
}

func currencyFormatter(amount:Double) -> String  {
let currencyFormatter = NumberFormatter()
   currencyFormatter.usesGroupingSeparator = true
   currencyFormatter.numberStyle = .currency
   currencyFormatter.maximumFractionDigits = 0
      // localize to your grouping and decimal separator
   currencyFormatter.locale = Locale(identifier: "tr_TR")
    return currencyFormatter.string(from: NSNumber(value: amount))!
}


class ViewController:  UIViewController  {
    // MARK: - View Life Cycle
 
   var devir_sayisal = 0.00
   var devir_super = 0.00
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var superLoto: UILabel!
    @IBOutlet weak var sayisal: UILabel!
    @IBOutlet weak var sliderValue: UILabel!
    @IBAction func slider (_ sender: UISlider) {        
        let roundedValue = round(sender.value / 1000000) * 1000000        
        sender.value = roundedValue
            self.sliderValue.text =  currencyFormatter(amount: Double(sender.value))
 
  }
   
  
    @IBAction func ocr(_ sender: Any) {
        func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
               if (segue.identifier == "ocr") { // sabit kullan
                if segue.destination is VisionViewController {
                      // Prepare attributes you have to prepare
                   }
               }
           }
    }
     
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        getResponse()
          
      
         UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) {
            (granted, error) in
            if let error = error {
                print(error)
            }
        }
                
         }
          
            func getResponse()

        {
            
                URLSession.shared.dataTask(with: Super(weeksBefore: 0).url_super) { (data,
                   response, error) in
               
               guard let data = data else { return }

               do {
                   
                   //Decode data
                   let JSONDict = try JSONDecoder().decode(JSONTest.self, from: data)
                 self.devir_super = JSONDict.data!.haftayaDevredenTutar
                   
                   // We'll force unwrap with the !, if you've got defined data you may need more error checking
                let devreden = currencyFormatter(amount: self.devir_super)
                   

                   //Get back to the main queue
                   DispatchQueue.main.async {
                       if    JSONDict.data?.devirSayisi == 0   {
                        self.superLoto.text = "Devretmedi"
                       } else {
                        self.superLoto.text = "Devreden : \(devreden) "
                   }
                                        
                   }
 
               } catch let jsonError {
                   print(jsonError)
               }
               }
            
            .resume()

            URLSession.shared.dataTask(with: Sayisal(drawBefore: 0).url_sayisal) { (data,
            response, error) in
             
        guard let data = data else { return }

        do {
            
            //Decode data
            let JSONDict = try JSONDecoder().decode(JSONTest.self, from: data)
            self.devir_sayisal = JSONDict.data!.haftayaDevredenTutar
            
            
            // We'll force unwrap with the !, if you've got defined data you may need more error checking
            
            let devreden = currencyFormatter(amount: self.devir_sayisal)
 
            //Get back to the main queue
            DispatchQueue.main.async {
                if    JSONDict.data?.devirSayisi == 0   {
                    self.sayisal.text = "Devretmedi"
                } else {
                    self.sayisal.text = "Devreden : \(devreden) "
            }
 
            }
            
 
        } catch let jsonError {
            print(jsonError)
        }
        }

          .resume()

        }

 
     
}

