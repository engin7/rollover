//
//  SuperTableViewController.swift
//  Devreden
//
//  Created by Engin KUK on 26.04.2020.
//  Copyright © 2020 Silverback Inc. All rights reserved.
//

import UIKit


class SuperTableViewCell: UITableViewCell  {

    @IBOutlet weak var date: UILabel!
 
    @IBOutlet weak var numbers: UILabel!
    
}
 


class SuperTableViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

 
        self.tableView.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
          switch section {
          case 0: return 1
          case 1: return 20
          default: return 0
            }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    switch section {

    case 0:
    let title: UILabel = UILabel()
    title.text = "Son Çekiliş"
    title.font = UIFont(name: "Arial", size: 24)

    title.textAlignment = NSTextAlignment.center
    return title
 
    case 1:
    let title: UILabel = UILabel()
    title.text = "Eski Çekilişler"
    title.font = UIFont(name: "Arial", size: 24)
    title.backgroundColor = .gray

    title.textAlignment = NSTextAlignment.center
    return title
    default: return nil
      }
    }
    
    
    
     
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    if (indexPath.section == 0) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuperTableViewCell", for: indexPath) as! SuperTableViewCell
        
        URLSession.shared.dataTask(with: Super(weeksBefore: 0).url_super) { (data,
                                                    response, error) in

                    guard let data = data else { return }
                 DispatchQueue.main.async {

                    do {

                  //Decode data
                  let JSONDict = try JSONDecoder().decode(JSONTest.self, from: data)

                 cell.date.text = JSONDict.data!.cekilisTarihi
                 cell.numbers.text =  JSONDict.data!.rakamlarNumaraSirasi
                 cell.textLabel?.adjustsFontSizeToFitWidth = true
                 cell.textLabel?.textColor = .systemBlue
                 cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
                     
                  }   catch let jsonError {
                      print(jsonError)
                     }}}
                  .resume()
        
          return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "superOld", for: indexPath)

        

        URLSession.shared.dataTask(with: Super(weeksBefore: indexPath.row+1).url_super) { (data,
                                               response, error) in

               guard let data = data else { return }
            DispatchQueue.main.async {

               do {

             //Decode data
             let JSONDict = try JSONDecoder().decode(JSONTest.self, from: data)

            cell.textLabel?.text = JSONDict.data!.cekilisTarihi
            cell.detailTextLabel?.text =  JSONDict.data!.rakamlarNumaraSirasi
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            cell.textLabel?.textColor = .systemBlue
            cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
                
             }   catch let jsonError {
                 print(jsonError)
                }}}
             .resume()
 
           return cell
          
        }
   
    }
 
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         if (indexPath.section == 0) {
        return 80
         } else {
        return 40
        }
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
