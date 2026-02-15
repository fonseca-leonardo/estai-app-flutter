import SwiftUI

struct ContentView: View {
    @StateObject private var connectivityManager = WatchConnectivityManager.shared
    @StateObject private var runtimeManager = ExtendedRuntimeManager.shared
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        NormalModeView(
            connectivityManager: connectivityManager,
            runtimeManager: runtimeManager
        )
        .onChange(of: scenePhase) { newPhase in
            handleScenePhaseChange(newPhase)
        }
        .onChange(of: connectivityManager.isNavigating) { isNavigating in
            handleNavigationStateChange(isNavigating)
        }
    }
    
    private func handleScenePhaseChange(_ phase: ScenePhase) {
        switch phase {
        case .active:
            print("Scene became active")
            runtimeManager.restartSessionIfNeeded()
        case .inactive:
            print("Scene became inactive")
        case .background:
            print("Scene went to background")
        @unknown default:
            break
        }
    }
    
    private func handleNavigationStateChange(_ isNavigating: Bool) {
        if isNavigating {
            print("Navigation started - starting extended runtime session")
            runtimeManager.startSession()
        } else {
            print("Navigation stopped - stopping extended runtime session")
            runtimeManager.stopSession()
        }
    }
}

struct NormalModeView: View {
    @ObservedObject var connectivityManager: WatchConnectivityManager
    @ObservedObject var runtimeManager: ExtendedRuntimeManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    CompactDataView(
                        icon: "location.north.circle.fill",
                        value: connectivityManager.formattedHeading,
                        subtitle: connectivityManager.headingDirection,
                        color: .blue
                    )
                    
                    CompactDataView(
                        icon: "speedometer",
                        value: connectivityManager.formattedSpeed,
                        subtitle: "kts",
                        color: .green
                    )
                }
                .padding(.horizontal, 8)
                
                NavigationDataCard(
                    isNavigating: connectivityManager.isNavigating,
                    title: "Distância",
                    value: connectivityManager.formattedDistance,
                    subtitle: "",
                    icon: "arrow.triangle.turn.up.right.circle.fill",
                    color: .orange
                )
                .padding(.horizontal, 8)
            }
            .padding(.vertical, 8)
        }
    }
}

struct CompactDataView: View {
    let icon: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.caption)
                Text(value)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
            }
            
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
        .padding(.horizontal, 2)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}



struct NavigationDataCard: View {
    let isNavigating: Bool
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if isNavigating {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.title3)
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                }
                
                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    Text(value)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                }
            } else {
                HStack(spacing: 8) {
                    Image(systemName: "location.slash")
                        .foregroundColor(.gray)
                        .font(.title3)
                    Text("Você não está navegando")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(12)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    ContentView()
}
