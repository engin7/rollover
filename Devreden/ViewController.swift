//
//  ViewController.swift
//  Devreden
//
//  Created by Engin KUK on 5.06.2019.
//  Copyright © 2019 Silverback Inc. All rights reserved.
//

import UIKit
import Foundation
import UserNotifications


extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension BinaryInteger {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}

// for json structure (array in array)

struct JSONTest: Codable {
    var data: Datam?
}

struct Datam: Codable {
    var haftayaDevredenTutar: Double
    var devirSayisi: Int
}

class ViewController:  UIViewController  {
    // MARK: - View Life Cycle
 

    @IBOutlet weak var superLoto: UILabel!
    @IBOutlet weak var sayisal: UILabel!
     
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor =  UIColor.gray
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) {
            (granted, error) in
            if granted {
                print("yes")
            } else {
                print("No")
            }
        }
        
        getResponse()
        
         }
         
        func sendNotification( ) {
                  
                  let content = UNMutableNotificationContent()
                  content.title = "Devreden:"
                  content.body = "  ;) devretti"
                  
                var date = DateComponents()
                    date.hour = 09
                    date.minute = 30
            
                  let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
            
                  let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
                  
                  UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
              }
              

            func getResponse()

        {
            
                let dateFormatter = DateFormatter()
                       dateFormatter.dateFormat = "yyyyMMdd"
                       
                       // superloto is only thursdays
                       let dateSuper = dateFormatter.string(from: Date.today().previous(.thursday))
                       
                      print(dateSuper)
                    
                       let weekday = Calendar.current.component(.weekday, from: Date())
                       let dateSayisal: String
                       // calculate which day is the last sayisal loto
                       if weekday > 4  {
                             dateSayisal = dateFormatter.string(from: Date.today().previous(.wednesday))
                       } else {
                             dateSayisal = dateFormatter.string(from: Date.today().previous(.saturday))
                              }
                       
                        print(dateSayisal)
                   
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
                   let devir = JSONDict.data?.haftayaDevredenTutar
                   
                   let currencyFormatter = NumberFormatter()
                   currencyFormatter.usesGroupingSeparator = true
                   currencyFormatter.numberStyle = .currency
                   // localize to your grouping and decimal separator
                   currencyFormatter.locale = Locale(identifier: "tr_TR")
                   
                   // We'll force unwrap with the !, if you've got defined data you may need more error checking
                   let devreden = currencyFormatter.string(from: devir! as NSNumber)!
                   print(devreden)

                   //Get back to the main queue
                   DispatchQueue.main.async {
                       if    JSONDict.data?.devirSayisi == 0   {
                        self.superLoto.text = "Devretmedi"
                       } else {
                        self.superLoto.text = "Devreden : \(devreden) "
                   }
                   }
                   print(Int(devir!))
                   if Int(devir!)  >  10000000 {
                    self.sendNotification()
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
            let devir = JSONDict.data?.haftayaDevredenTutar
            
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = .currency
            // localize to your grouping and decimal separator
            currencyFormatter.locale = Locale(identifier: "tr_TR")
            
            // We'll force unwrap with the !, if you've got defined data you may need more error checking
            let devreden = currencyFormatter.string(from: devir! as NSNumber)!
            print(devreden)

            //Get back to the main queue
            DispatchQueue.main.async {
                if    JSONDict.data?.devirSayisi == 0   {
                    self.sayisal.text = "Devretmedi"
                } else {
                    self.sayisal.text = "Devreden : \(devreden) "
            }
            }
            print(Int(devir!))
            if Int(devir!)  >  2000000 {
                self.sendNotification()
            }
            
        } catch let jsonError {
            print(jsonError)
        }
        }

          .resume()

        }

 
     
}

