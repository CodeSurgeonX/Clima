//
//  ViewController.swift
//  Clima
//
//  Created by Shashwat  on 14/02/19.
//  Copyright © 2019 Shashwat . All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import SwiftyJSON
//Import the Core Location

class ViewController: UIViewController, CLLocationManagerDelegate, cityViewControllerDelegate {
    func getCityWeather(_ city: String) {
        let params : [String:String] = ["q":city,"appid":APPID]
        doRequest(URL, params)
    }
    //Confirm the delegate
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var imageViewTemp: UIImageView!
    
    @IBAction func buttonTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToCity", sender: nil)
    }
    var location = CLLocationManager()                                              //Initialise the location manager
    var APPID = "1077534932c8bbb1c56e1d13a9b4900a"
    var URL = "http://api.openweathermap.org/data/2.5/weather"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocationManager()
    }
    
    //MARK: - Location
    func setupLocationManager(){
        location.delegate = self
        location.desiredAccuracy = kCLLocationAccuracyHundredMeters                     //Set delegate & Accuracy & permission
        location.requestWhenInUseAuthorization()                                        //When In Use request
                                                                                        //Change in Plist the part where you ask for location usage & when in usage
        location.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locus = locations[locations.count - 1]
//        print("Latitude : \(locus.coordinate.latitude) & Longitude \(locus.coordinate.longitude)")
        let latitude = locus.coordinate.latitude
        let longitude = locus.coordinate.longitude
        let params : [String:String] = ["lat":"\(latitude)","lon" : "\(longitude)", "appid" : APPID]
        doRequest(URL,params)
        //Last value most accurate
        if locus.horizontalAccuracy > 0 {
            location.stopUpdatingLocation()                                             //Save battery of the user
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityLabel.text = "Location Unavailable"
    }
    
    //MARK: - Alamofire
    func doRequest(_ url : String,_ params:[String:String]){
        
        weak var weakSelf : ViewController? = self
        
        Alamofire.request(url, method: .get, parameters: params).responseJSON { response in
            if response.result.isSuccess{
                let weatherData : JSON = JSON(response.result.value!)
                weakSelf!.parser(weatherData)
            }else{
                weakSelf!.cityLabel.text = "Check Internet"
            }
            
        }
    }
    
    
    //MARK :- Parse Data
    func parser(_ weatherData : JSON){
        let city = weatherData["name"].stringValue
        let temp = weatherData["main"]["temp"].doubleValue - 273.1
        let imageCode = weatherData["weather"][0]["id"].intValue
        tempLabel.text = String(round(temp*1000)/1000)
        cityLabel.text = city
        let imageName = getImageNameFromCode(imageCode)
        imageViewTemp.image = UIImage(named: imageName)
        
    }
    
    func getImageNameFromCode(_ code: Int) -> String{
        switch code {
        case 0...300:
            return "tstorm1"
        case 301...500:
            return "light_rain"
        case 501...600:
            return "shower3"
        case 601...700:
            return "snow4"
        case 701...771:
            return "fog"
        case 772...800:
            return "tstorm3"
        case 800:
            return "sunny"
        case 801...804:
            return "cloudy2"
        case 900...903, 905...1000:
            return "tstorm3"
        case 903:
            return "snow"
        case 904:
            return "sunny"
        default:
            return "dunno"
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCity" {
            let cityVC  = segue.destination as! cityViewController
            cityVC.delegate = self
        }
    }
    


}

