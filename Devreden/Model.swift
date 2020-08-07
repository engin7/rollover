//
//  Modal.swift
//  Devreden
//
//  Created by Engin KUK on 1.05.2020.
//  Copyright © 2020 Silverback Inc. All rights reserved.
//

import Foundation
import UIKit

let dateFormatter = DateFormatter()


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



struct Super {
         
    var url_super: URL
    let weeksBefore: Int
   var dateS =  Date.today().previous(.thursday)

    init(weeksBefore: Int) {
        
        self.weeksBefore = weeksBefore

        dateFormatter.dateFormat = "yyyyMMdd"
     
        // superloto is only thursdays
        for _ in 0..<weeksBefore {
            
         dateS  =  dateS.previous(.thursday)
            
        }
         
       let dateSuper = dateFormatter.string(from: dateS)
        
        var urlComponents_super = URLComponents()
       urlComponents_super.scheme = "http"
       urlComponents_super.host = "mpi.gov.tr"
       urlComponents_super.path = "/sonuclar/cekilisler/superloto/\(dateSuper).json"
      
       url_super = URL(string: urlComponents_super.url!.absoluteString)!
    
     }
}
                            
 struct Sayisal {
          
     var url_sayisal: URL
     let drawBefore: Int
     let weekday = Calendar.current.component(.weekday, from: Date())

     init(drawBefore: Int) {
         
        var dateSayisal : Date
        
         self.drawBefore = drawBefore
        
         if weekday > 4  {
             dateSayisal =  Date.today().previous(.wednesday)
       } else {
             dateSayisal = Date.today().previous(.saturday)
              }

         dateFormatter.dateFormat = "yyyyMMdd"
 
        
        for _ in 0..<drawBefore {
          
            let weekdayDraw = Calendar.current.component(.weekday, from: dateSayisal)

             if weekdayDraw > 4  {
                   dateSayisal =  dateSayisal.previous(.wednesday)
             } else {
                   dateSayisal = dateSayisal.previous(.saturday)
                    }
         }
          
        let dateSay = dateFormatter.string(from: dateSayisal)
         
         var urlComponents_super = URLComponents()
        urlComponents_super.scheme = "http"
        urlComponents_super.host = "mpi.gov.tr"
        urlComponents_super.path = "/sonuclar/cekilisler/sayisal/SAY_\(dateSay).json"
       
        url_sayisal = URL(string: urlComponents_super.url!.absoluteString)!
     
      }
 }


 
