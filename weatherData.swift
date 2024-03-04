import Foundation

struct weather_Data:Codable{
    //decodable is required for ext data source
    let name:String
    let main:Main
    let weather:[Weather]
    
}

struct Main:Codable{
    let temp:Double
}

struct Weather:Codable {
    let description:String
    let id:Int
}
