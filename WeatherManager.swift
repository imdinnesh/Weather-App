import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManger:WeatherManager, weather:WeatherModel)
    func didFailWithFindError(error:Error)
        
}

struct WeatherManager {
    let weatherUrl="https://api.openweathermap.org/data/2.5/weather?appid=e884bdebff9d69efffa51441c01c0bde&units=metric"
    
    var delegate:WeatherManagerDelegate?
    
    
    func fetchWeather(cityName:String){
        let urlString="\(weatherUrl)&q=\(cityName)"
        
        performRequest(with: urlString)
        
    }
    
    func fetchWeather(latitude:CLLocationDegrees,longitude:CLLocationDegrees){
        let urlString="\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
        
        
    }
    
    func performRequest(with urlString:String){
        //URL ...
        
        if let url=URL(string: urlString){
            //URL session...
            
            let session=URLSession(configuration: .default)
            
            //Data Task...
            
            let task=session.dataTask(with: url) { data, response, error in
                if(error != nil){
                    delegate?.didFailWithFindError(error: error!)
                    return
                }
                
                if let safeData=data{
                    //let dataString=String(data: safeData, encoding: .utf8)
                    if let weather=self.parseJSON(safeData){
                        delegate?.didUpdateWeather(self, weather: weather)
                        
                    }
                }
                
            }
            
            //Start the task
            
            task.resume()
        }
        
        
    }
    
    func parseJSON( _ weatherData:Data)->WeatherModel?{
        let decoder=JSONDecoder()
        do{
            let decodedData=try decoder.decode(weather_Data.self, from: weatherData)
            let id=decodedData.weather[0].id
            let temp=decodedData.main.temp
            let name=decodedData.name
            
            let weather=WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        }
        catch{
            delegate?.didFailWithFindError(error: error)
            return nil
        }
    }
    
    
    
}
