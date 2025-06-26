import SwiftUI
import ComposableArchitecture

@main
struct ZipSearchApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(initialState: ZipSearchFeature.State()) {
                    ZipSearchFeature()
                }
            )
        }
    }
}