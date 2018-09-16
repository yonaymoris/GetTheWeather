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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityLabel.text = city
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as! ForecastCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        cell.day.text = formatter.string(from: nDaysfromNow(n: indexPath.row) as Date)
        
        cell.icon1.image = UIImage(named: forecast[indexPath.row].weatherIconNames[2])
        cell.icon2.image = UIImage(named: forecast[indexPath.row].weatherIconNames[4])
        cell.icon3.image = UIImage(named: forecast[indexPath.row].weatherIconNames[6])
        cell.icon4.image = UIImage(named: forecast[indexPath.row].weatherIconNames[7])
        
        cell.temp1.text = String(forecast[indexPath.row].temperatures[2])
        cell.temp2.text = String(forecast[indexPath.row].temperatures[4])
        cell.temp3.text = String(forecast[indexPath.row].temperatures[6])
        cell.temp4.text = String(forecast[indexPath.row].temperatures[7])
        
        
        
        return cell
    }
    
    func nDaysfromNow(n : Int) -> NSDate {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let day = calendar.date(byAdding: .day, value: n, to: NSDate() as Date, options: [])!
        return day as NSDate
    }

}
