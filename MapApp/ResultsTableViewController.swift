//
//  ResultsTableViewController.swift
//  MapApp
//
//  Created by Carey, Brady on 11/15/16.
//  Copyright © 2016 Carey, Brady. All rights reserved.
//

import UIKit
import MapKit

class ResultsTableViewController: UITableViewController {
    
    var mapItems: [MKMapItem]!
    
    override func viewDidLoad() { //Shows nav bar when this view loads
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mapItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! ResultsTableCell
        
        // Configure the cell...
        let row = indexPath.row
        let item = mapItems[row]
        cell.nameLabel.text = item.name
        cell.phoneLabel.text = item.phoneNumber
        if item.url != nil {
            cell.urlLabel.text = item.url?.absoluteString
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //Send destination to route controller
        let routeViewController = segue.destination
            as! RouteViewController
        
        let indexPath = self.tableView.indexPathForSelectedRow!
        
        let row = indexPath.row
        
        routeViewController.destination = mapItems![row]
    }

}
