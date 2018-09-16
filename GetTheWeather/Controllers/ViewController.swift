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
    
    var city : String = ""
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var weatherForecastButton: UIButton!
    @IBOutlet var findByCityButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up the button's appearance
        findByCityButton.layer.cornerRadius = 5
        
        findByCityButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        findByCityButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        findByCityButton.layer.shadowOpacity = 1.0
        findByCityButton.layer.shadowRadius = 5
        
        weatherForecastButton.layer.cornerRadius = 5
        
        weatherForecastButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        weatherForecastButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        weatherForecastButton.layer.shadowOpacity = 1.0
        weatherForecastButton.layer.shadowRadius = 5
    }
    
    // get the locations on the map and request the data
    func getWeatherData(url : String, parameters : [String : String]) {
        
        // get the city and country from the map
        if self.city == "" {
            let pinPosition = CGPoint(x: UIScreen.main.bounds.size.width*0.5,y: UIScreen.main.bounds.size.height*0.5-50)
            let mapCoordinate = self.mapView.convert(pinPosition, toCoordinateFrom: self.mapView)
            
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: mapCoordinate.latitude, longitude: mapCoordinate.longitude)
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                if placeMark != nil {
                    if let cityValue = placeMark.subAdministrativeArea {
                        self.city = cityValue
                    }
                    
                    if let countryValue = placeMark.country {
                        self.city += ", \(countryValue)"
                    }
                }
                
            })
        }
        
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
                let alert = UIAlertController(title: "Connection Issues", message: "Please check your internet connection and try again", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    // update data in the forecast view controller
    func updateWeatherData(json : JSON) {
        for i in stride(from: 0, to: json.count-1, by: 8) {
            let weather = WeatherDataModel()
            for n in 0...7 {
                if let tempResult = json[i+n]["main"]["temp"].double {
                    //print(json[i+n])
                    weather.temperatures.append(Int(tempResult - 273.15))
                    weather.conditions.append(json[i+n]["weather"][0]["id"].intValue)
                    weather.weatherIconNames.append(weather.updateWeatherIcon(condition: weather.conditions[n]))
                    //updateUIWeatherData()
                }
            }
            weatherForecast.append(weather)
        }
        
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let destinationVC = segue.destination as! ForecastController
            
            if city != "" {
                destinationVC.city = "\(city)"
            } else { destinationVC.city = "Your chosen area" }
            
            if weatherForecast.count == 0 {
                destinationVC.city = "No data"
            }
            destinationVC.forecast = weatherForecast
        }
    }
    
    
    @IBAction func weatherForecastPressed(_ sender: Any) {
        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.weatherForecast.removeAll()
            self.city = ""
            let pinPosition = CGPoint(x: UIScreen.main.bounds.size.width*0.5,y: UIScreen.main.bounds.size.height*0.5)
            let mapCoordinate = self.self.mapView.convert(pinPosition, toCoordinateFrom: self.self.mapView)
            let latitude = String(mapCoordinate.latitude)
            let longitude = String(mapCoordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon": longitude, "appid" : self.APP_ID]
            self.getWeatherData(url : self.WEATHER_URL, parameters : params)
            SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func findByCityPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Enter the city name", message: "", preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = "Find the city"
        }
        
        alert.addAction(UIAlertAction(title: "Find", style: .default, handler: { (action: UIAlertAction) in
            if let locationField = alert.textFields?[0] {
                let location = locationField.text!
                SVProgressHUD.show()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.weatherForecast.removeAll()
                    self.city = location
                    let params : [String : String] = ["q" : location, "appid" : self.APP_ID]
                    self.getWeatherData(url: self.WEATHER_URL, parameters: params)
                    SVProgressHUD.dismiss()
                }
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
