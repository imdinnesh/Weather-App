import UIKit
import CoreLocation

class WeatherViewController: UIViewController{

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBAction func LocationPressed(_ sender: UIButton) {
        
        locationManager.requestLocation()
        
        
    }
    var weatherManager=WeatherManager()
    let locationManager=CLLocationManager()

    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        locationManager.delegate=self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        searchTextField.delegate=self
        weatherManager.delegate=self
        
    }


}

//MARK: - UITextFieldDelegate

extension WeatherViewController:UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //Text should be used here ...
        
        if let city=searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
            
        }
        searchTextField.text=""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if(textField.text  !=  ""){
            return true
        }
        else{
            textField.placeholder="Type Something"
            return false
        }
    }
    @IBAction func searchPressed(_ sender: UIButton) {
        
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    
}

//MARK: - WeatherManagerDelegate


extension WeatherViewController:WeatherManagerDelegate{
    
    
    func didUpdateWeather( _ weatherManger:WeatherManager, weather:WeatherModel){
        //print(weather.temperature)
        DispatchQueue.main.async {
            self.temperatureLabel.text=weather.temperatureString
            self.conditionImageView.image=UIImage(systemName: weather.conditionName)
            self.cityLabel.text=weather.cityName
            
        }
    }
    
    func didFailWithFindError(error: Error) {
        print(error)
    }
    
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print("Got Location data")
        
        if let location=locations.last{
            locationManager.stopUpdatingLocation()
            let lat=location.coordinate.latitude
            let lon=location.coordinate.longitude
            weatherManager.fetchWeather(latitude:lat,longitude:lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

