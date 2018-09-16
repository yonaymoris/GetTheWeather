//
//  ViewController.swift
//  GetTheWeather
//
//  Created by Phuong Ngo on 9/16/18.
//  Copyright © 2018 Phuong Ngo. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ViewController: UIViewController {
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/forecast"
    let APP_ID = "89779c4b7ec52f4203fbb1da32f95630"
    var weatherForecast = [WeatherDataModel]()
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var weatherForecastButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherForecastButton.layer.cornerRadius = 20
        
        weatherForecastButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        weatherForecastButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        weatherForecastButton.layer.shadowOpacity = 1.0
        weatherForecastButton.layer.shadowRadius = 20
        weatherForecastButton.layer.masksToBounds = false
    }
    
    func getWeatherData(url : String, parameters : [String : String]) {
        Alamofire.request(url, method : .get, parameters : parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! Got the weather data")
                
                let weatherJSON : JSON = JSON(response.result.value!)
                //print(weatherJSON)
                self.updateWeatherData(json: weatherJSON["list"])
            }
            else {
                print("Error \(response.result.error)")
                //self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    func updateWeatherData(json : JSON) {
        //print(json)
        var n = 1
        for i in stride(from: 0, to: json.count-1, by: 8) {
            let weather = WeatherDataModel()
            for n in 0...7 {
                if let tempResult = json[i+n]["main"]["temp"].double {
                    weather.temperatures.append(Int(tempResult - 273.15))
                    weather.cities.append(json[i+n]["name"].stringValue)
                    weather.conditions.append(json[i+n]["weather"][0]["id"].intValue)
                    weather.weatherIconNames.append(weather.updateWeatherIcon(condition: weather.conditions[n]))
                    //updateUIWeatherData()
                }
            }
            weatherForecast.append(weather)
        }

        //        for i in weatherForecast {
        //            print(i.weatherIconNames)
        //        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "segue" {
//            let destinationVC = segue.destination as! WeatherForecastController
//            
//            destinationVC.forecast = weatherForecast
//        }
//    }
    
    @IBAction func weatherForecastPressed(_ sender: Any) {
        SVProgressHUD.show()
        let pinPosition = CGPoint(x: UIScreen.main.bounds.size.width*0.5,y: UIScreen.main.bounds.size.height*0.5)
        let mapCoordinate = mapView.convert(pinPosition, toCoordinateFrom: mapView)
        let latitude = String(mapCoordinate.latitude)
        let longitude = String(mapCoordinate.longitude)
        
        let params : [String : String] = ["lat" : latitude, "lon": longitude, "appid" : APP_ID]
        getWeatherData(url : WEATHER_URL, parameters : params)
        SVProgressHUD.dismiss()
    }
    
}
