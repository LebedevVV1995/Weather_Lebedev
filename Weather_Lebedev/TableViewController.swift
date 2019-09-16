//
//  TableViewController.swift
//  Weather_Lebedev
//
//  Created by Владимир on 30/06/2019.
//  Copyright © 2019 Владимир. All rights reserved.
//

import UIKit
import Alamofire

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var townArray = [AnyObject]()

    @IBOutlet weak var mTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request("https://mydoc.ru/api/ios/medical_providers/docdoc/cities.json").responseJSON {
            response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject>{
                if let innerDict = dict["collection"]{
                    self.townArray = innerDict as! [AnyObject]
                    self.mTableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return townArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mCell", for: indexPath) as? MyTableViewCell
        let title = townArray[indexPath.row]["name"]
        cell?.myLabel.text = title as? String
        return cell!
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
}
