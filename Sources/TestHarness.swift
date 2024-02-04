//
//  Created by Shawn McKee on 10/27/23.
//  Provided by Durable Brand Software LLC.
//  http://durablebrand.software
//

import SwiftUI

/// An internal global variable for controlling whether or not the test harness is enabled. This
/// will get set to the value passed in `enabled:` parameter of the `TestHarness` initializer.
var testHarnessEnabled: Bool = false


/// The internal observable state object for managing and updating test harness state .
class TestHarnessState: ObservableObject {
    
    @Published var testSettingsPanelVisible = false
    @Published var screenLogMessages = [ScreenLogMessage]()
    @Published var hideScreenLogs = TestSettings.load().hideScreenLogs

    func showTestSettingsPanel() {
        testSettingsPanelVisible = true
    }
    
    func addScreenLogMessage(_ text: String, details: String? = nil) {
        screenLogMessages.insert(ScreenLogMessage(text: text, details: details), at: 0)
    }
}
var testHarnessState = TestHarnessState()


/// The view you wrap your app's root view with to provide it test harness functionality. Be sure to pass `false`
/// for the `enabled:` parameter in your production builds so that the test harness isn't available in your
/// App Store release.
struct TestHarness<AppView: View, SettingsView: View>: View {

    @EnvironmentObject private var testHarnessEnvironmentState: TestHarnessState
    private var appView: AppView
    private var settingsView: SettingsView

    fileprivate init(enabled: Bool, settings: TestSettings, @ViewBuilder views: () -> TupleView<(AppView, SettingsView)>) {
        testHarnessEnabled = enabled
        currentTestSettings = settings
        let views = views().value
        appView = views.0
        settingsView = views.1
    }

    
    public var body: some View {
        return ZStack {
            appView
            ScreenLogView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
        .sheet(isPresented: $testHarnessEnvironmentState.testSettingsPanelVisible) {
            TestSettingsPanel {
                settingsView
            }
        }
    }
}


struct TestSettingsPanelAccessView<Content: View>: View {
//    @EnvironmentObject private var testHarnessState: TestHarnessState
    @ViewBuilder let content: Content
    
    var body: some View {
        ZStack {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.white.opacity(0.00001))
                .simultaneousGesture(LongPressGesture(minimumDuration: 1).onEnded { _ in
                    testHarnessState.showTestSettingsPanel()
                })
        }
    }
}

/// An extension to SwiftUI's `View` that provides a view modifier for enabling the test harness on your app's root view
/// and to apply a long-tap gesture to views to give them access to the `Test Settings` panel.
public extension View {
    
    @ViewBuilder
    public func withTestHarness(settings: TestSettings, settingsView: some View, enabled: Bool = true) -> some View {
        if enabled {
            TestHarness(enabled: enabled, settings: settings) {
                self
                settingsView
            }
            .environmentObject(testHarnessState)
        } else { self }
    }

    @ViewBuilder
    public func withTestSettingsPanelAccess() -> some View {
        if testHarnessEnabled {
            TestSettingsPanelAccessView() {
                self
            }
        } else { self }
    }
}
