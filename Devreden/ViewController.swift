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
 

// for json structure (array in array)

struct JSONTest: Codable {
    var data: Datam?
}

struct Datam: Codable {
    var haftayaDevredenTutar: Double
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
        print(sender.value)
        
  }
   
  
    
       
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        getResponse()
         
        self.view.backgroundColor =  UIColor.gray
        
      
         UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) {
            (granted, error) in
            if granted {
                print("yes")
            } else {
                print("No")
            }
        }
                
         }
         
    
            func getResponse()

        {
            
                let dateFormatter = DateFormatter()
                       dateFormatter.dateFormat = "yyyyMMdd"
                       
                       // superloto is only thursdays
                       let dateSuper = dateFormatter.string(from: Date.today().previous(.thursday))
                       
                     // print(dateSuper)
                    
                       let weekday = Calendar.current.component(.weekday, from: Date())
                       let dateSayisal: String
                       // calculate which day is the last sayisal loto
                       if weekday > 4  {
                             dateSayisal = dateFormatter.string(from: Date.today().previous(.wednesday))
                       } else {
                             dateSayisal = dateFormatter.string(from: Date.today().previous(.saturday))
                              }
                       
                     //   print(dateSayisal)
                   
                       var urlComponents_sayisal = URLComponents()
                       urlComponents_sayisal.scheme = "http"
                       urlComponents_sayisal.host = "millipiyango.gov.tr"
                       urlComponents_sayisal.path = "/sonuclar/cekilisler/sayisal/SAY_\(dateSayisal).json"
                
                       let url_sayisal = URL(string: urlComponents_sayisal.url!.absoluteString)!
                       
                       var urlComponents_super = URLComponents()
                       urlComponents_super.scheme = "http"
                       urlComponents_super.host = "mpi.gov.tr"
                       urlComponents_super.path = "/sonuclar/cekilisler/superloto/\(dateSuper).json"
                       
                       let url_super = URL(string: urlComponents_super.url!.absoluteString)!
                
                       let url_array = [url_super, url_sayisal]
                 
                URLSession.shared.dataTask(with: url_array[0]) { (data,
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

         URLSession.shared.dataTask(with: url_array[1]) { (data,
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

