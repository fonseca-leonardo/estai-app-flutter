import SwiftUI
import WatchKit

@main
struct Watch_Watch_AppApp: App {
    @WKApplicationDelegateAdaptor(WatchAppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class WatchAppDelegate: NSObject, WKApplicationDelegate {
    func applicationDidFinishLaunching() {
        print("Watch app did finish launching")
    }
    
    func applicationDidBecomeActive() {
        print("Watch app did become active")
        ExtendedRuntimeManager.shared.restartSessionIfNeeded()
    }
    
    func applicationWillResignActive() {
        print("Watch app will resign active")
    }
    
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        for task in backgroundTasks {
            print("Handling background task: \(task)")
            
            switch task {
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                snapshotTask.setTaskCompleted(
                    restoredDefaultState: true,
                    estimatedSnapshotExpiration: Date.distantFuture,
                    userInfo: nil
                )
            default:
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
}

