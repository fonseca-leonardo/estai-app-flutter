import Foundation

class SharedDataManager {
    static let shared = SharedDataManager()
    
    private let appGroupIdentifier = "group.com.br.estai"
    private let userDefaults: UserDefaults?
    
    private enum Keys {
        static let heading = "shared_heading"
        static let speed = "shared_speed"
        static let distance = "shared_distance"
        static let isNavigating = "shared_isNavigating"
        static let lastUpdate = "shared_lastUpdate"
    }
    
    init() {
        self.userDefaults = UserDefaults(suiteName: appGroupIdentifier)
    }
    
    func saveNavigationData(heading: Double, speed: Double, distance: Double, isNavigating: Bool) {
        guard let userDefaults = userDefaults else {
            print("Error: Unable to access shared UserDefaults")
            return
        }
        
        userDefaults.set(heading, forKey: Keys.heading)
        userDefaults.set(speed, forKey: Keys.speed)
        userDefaults.set(distance, forKey: Keys.distance)
        userDefaults.set(isNavigating, forKey: Keys.isNavigating)
        userDefaults.set(Date(), forKey: Keys.lastUpdate)
        
        userDefaults.synchronize()
        
        print("Saved navigation data to shared container")
    }
    
    func getHeading() -> Double {
        return userDefaults?.double(forKey: Keys.heading) ?? -1.0
    }
    
    func getSpeed() -> Double {
        return userDefaults?.double(forKey: Keys.speed) ?? 0.0
    }
    
    func getDistance() -> Double {
        return userDefaults?.double(forKey: Keys.distance) ?? 0.0
    }
    
    func getIsNavigating() -> Bool {
        return userDefaults?.bool(forKey: Keys.isNavigating) ?? false
    }
    
    func getLastUpdate() -> Date? {
        return userDefaults?.object(forKey: Keys.lastUpdate) as? Date
    }
    
    var isHeadingValid: Bool {
        let heading = getHeading()
        return heading >= 0 && heading <= 360
    }
    
    var speedInKnots: Double {
        return getSpeed() * 1.94384
    }
    
    var formattedHeading: String {
        guard isHeadingValid else { return "--" }
        let degrees = Int(getHeading())
        return "\(degrees)°"
    }
    
    var formattedSpeed: String {
        return String(format: "%.1f kn", speedInKnots)
    }
    
    var formattedDistance: String {
        return String(format: "%.2f NM", getDistance())
    }
    
    var headingDirection: String {
        guard isHeadingValid else { return "" }
        let heading = getHeading()
        let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        let index = Int((heading + 22.5) / 45.0) % 8
        return directions[index]
    }
}
