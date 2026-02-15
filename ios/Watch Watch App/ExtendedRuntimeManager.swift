import Foundation
import WatchKit
import Combine

class ExtendedRuntimeManager: NSObject, ObservableObject {
    static let shared = ExtendedRuntimeManager()
    
    @Published var isSessionActive: Bool = false
    @Published var sessionState: String = "Inativo"
    
    private var runtimeSession: WKExtendedRuntimeSession?
    private var shouldBeActive: Bool = false
    
    override init() {
        super.init()
        print("ExtendedRuntimeManager initialized")
    }
    
    func startSession() {
        guard !isSessionActive else {
            print("Session already active")
            return
        }
        
        shouldBeActive = true
        createAndStartNewSession()
    }
    
    private func createAndStartNewSession() {
        runtimeSession = WKExtendedRuntimeSession()
        runtimeSession?.delegate = self
        
        print("Starting new extended runtime session...")
        runtimeSession?.start()
    }
    
    func stopSession() {
        shouldBeActive = false
        
        guard let session = runtimeSession else {
            print("No session to stop")
            return
        }
        
        print("Stopping extended runtime session...")
        session.invalidate()
        runtimeSession = nil
        
        DispatchQueue.main.async {
            self.isSessionActive = false
            self.sessionState = "Inativo"
        }
    }
    
    func restartSessionIfNeeded() {
        guard shouldBeActive && !isSessionActive else {
            print("No need to restart session. shouldBeActive: \(shouldBeActive), isActive: \(isSessionActive)")
            return
        }
        
        print("Restarting session as it should be active...")
        runtimeSession = nil
        createAndStartNewSession()
    }
}

extension ExtendedRuntimeManager: WKExtendedRuntimeSessionDelegate {
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("✅ Extended runtime session did start")
        DispatchQueue.main.async {
            self.isSessionActive = true
            self.sessionState = "Ativo"
        }
    }
    
    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("⚠️ Extended runtime session will expire soon")
        DispatchQueue.main.async {
            self.sessionState = "Expirando"
        }
        
        if shouldBeActive {
            print("Session expiring but navigation still active. Will restart...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.runtimeSession = nil
                self.createAndStartNewSession()
            }
        }
    }
    
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        let reasonString = "Reason: \(reason.rawValue)"
        
        if let error = error {
            print("❌ Extended runtime session invalidated: \(reasonString) - Error: \(error.localizedDescription)")
        } else {
            print("⚠️ Extended runtime session invalidated: \(reasonString)")
        }
        
        DispatchQueue.main.async {
            self.isSessionActive = false
            self.sessionState = "Inativo"
        }
        
        if shouldBeActive {
            print("Session invalidated but should be active. Will attempt restart...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.restartSessionIfNeeded()
            }
        }
    }
}
