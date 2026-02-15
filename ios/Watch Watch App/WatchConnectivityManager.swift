import Foundation
import WatchConnectivity
import Combine
import WidgetKit

class WatchConnectivityManager: NSObject, ObservableObject {
    static let shared = WatchConnectivityManager()
    
    @Published var heading: Double = 0.0
    @Published var speed: Double = 0.0
    @Published var distanceNauticalMiles: Double = 0.0
    @Published var isNavigating: Bool = false
    @Published var lastUpdate: Date?
    
    private let session: WCSession
    private let sharedData = SharedDataManager.shared
    private let runtimeManager = ExtendedRuntimeManager.shared
    
    override init() {
        self.session = WCSession.default
        super.init()
        
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
        
        loadFromSharedContainer()
    }
    
    private func loadFromSharedContainer() {
        heading = sharedData.getHeading()
        speed = sharedData.getSpeed()
        distanceNauticalMiles = sharedData.getDistance()
        isNavigating = sharedData.getIsNavigating()
        lastUpdate = sharedData.getLastUpdate()
        
        if isNavigating {
            print("Loading navigation state from shared container - starting runtime session")
            runtimeManager.startSession()
        }
    }
    
    private func updateNavigationData(_ data: [String: Any]) {
        DispatchQueue.main.async {
            if let heading = data["heading"] as? Double {
                self.heading = heading
            }
            
            if let speed = data["speed"] as? Double {
                self.speed = speed
            }
            
            if let distance = data["distance"] as? Double {
                self.distanceNauticalMiles = distance
            }
            
            if let isNavigating = data["isNavigating"] as? Bool {
                let wasNavigating = self.isNavigating
                self.isNavigating = isNavigating
                
                if isNavigating && !wasNavigating {
                    print("Navigation started via connectivity - starting runtime session")
                    self.runtimeManager.startSession()
                } else if !isNavigating && wasNavigating {
                    print("Navigation stopped via connectivity - stopping runtime session")
                    self.runtimeManager.stopSession()
                }
            }
            
            self.lastUpdate = Date()
            
            self.saveToSharedContainer()
        }
    }
    
    private func saveToSharedContainer() {
        sharedData.saveNavigationData(
            heading: heading,
            speed: speed,
            distance: distanceNauticalMiles,
            isNavigating: isNavigating
        )
    }
    
    
    var speedInKnots: Double {
        return speed * 1.94384
    }
    
    var isHeadingValid: Bool {
        return heading >= 0 && heading <= 360
    }
    
    var formattedHeading: String {
        guard isHeadingValid else { return "--" }
        let degrees = Int(heading)
        return "\(degrees)°"
    }
    
    var formattedSpeed: String {
        return String(format: "%.1f", speedInKnots)
    }
    
    var formattedDistance: String {
        return String(format: "%.2f NM", distanceNauticalMiles)
    }
    
    var headingDirection: String {
        guard isHeadingValid else { return "" }
        let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        let index = Int((heading + 22.5) / 45.0) % 8
        return directions[index]
    }
}

extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed: \(error.localizedDescription)")
        } else {
            print("WCSession activated with state: \(activationState.rawValue)")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("Received message: \(message)")
        updateNavigationData(message)
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("Received application context: \(applicationContext)")
        updateNavigationData(applicationContext)
    }
}
