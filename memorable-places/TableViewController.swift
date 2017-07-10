//
//  TableViewController.swift
//  memorable-places
//
//  Created by Chanse Campbell on 10/07/2017.
//  Copyright © 2017 Chanse Campbell. All rights reserved.
//

import UIKit
import MapKit

var places = [Dictionary<String, String>()]
var activePlace = -1

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // needs to be added in order to reload data on the fly
    override func viewDidAppear(_ animated: Bool) {
        
        if let tempPlaces = UserDefaults.standard.object(forKey: "places") as? [Dictionary<String, String>] {
            places = tempPlaces
        }
        
        if places.count == 1 && places[0].count == 0 {
            places.remove(at: 0)
            places.append(["name": "Taj Mahal", "lat": "27.175277", "lng": "78.042128"])
            
            UserDefaults.standard.set(places, forKey: "places")
        }
        
        activePlace = -1
        table.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let protoCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "ProtoCell")
        
        if  places[indexPath.row]["name"] != nil {
            protoCell.textLabel?.text = places[indexPath.row]["name"]
        }
        
        return protoCell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // allows user to edit the rows
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            places.remove(at: indexPath.row)
            
            UserDefaults.standard.setValue(places, forKey: "places")

            table.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activePlace = indexPath.row
        
        performSegue(withIdentifier: "toMap", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
