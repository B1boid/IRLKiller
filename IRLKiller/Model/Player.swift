import CoreLocation

struct Player: Decodable {
    let login:    String
    let position: CLLocationCoordinate2D
    let isOnline: Bool
    let health:   Int
    let rating:   Int
}

extension CLLocationCoordinate2D: Decodable {
    
     enum CodingKeys: String, CodingKey {
       case latitude, longitude
     }
    
    public init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
    }
}
