//
//  ForecastController.swift
//  GetTheWeather
//
//  Created by Phuong Ngo on 9/16/18.
//  Copyright © 2018 Phuong Ngo. All rights reserved.
//

import UIKit

class ForecastController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var forecast = [WeatherDataModel]()
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var city : String = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as! ForecastCell
        
        cell.icon1.image = UIImage(named: forecast[indexPath.row].weatherIconNames[1])
        cell.icon2.image = UIImage(named: forecast[indexPath.row].weatherIconNames[2])
        cell.icon3.image = UIImage(named: forecast[indexPath.row].weatherIconNames[3])
        cell.icon4.image = UIImage(named: forecast[indexPath.row].weatherIconNames[6])
        
        cell.temp1.text = String(forecast[indexPath.row].temperatures[1])
        cell.temp2.text = String(forecast[indexPath.row].temperatures[2])
        cell.temp3.text = String(forecast[indexPath.row].temperatures[3])
        cell.temp4.text = String(forecast[indexPath.row].temperatures[6])
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityLabel.text = city
        //print(forecast.count)
    }

}
