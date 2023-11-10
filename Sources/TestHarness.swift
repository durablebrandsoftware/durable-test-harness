//
//  Created by Shawn McKee on 10/27/23.
//  Provided by Durable Brand Software LLC.
//  http://durablebrand.software
//

import SwiftUI

/// The view you wrap your app's root view with to provide it test harness functionality. Be sure to pass `false`
/// for the `enabled:` parameter in your production builds so that the test harness isn't available in your
/// App Store release.
public struct TestHarness<AppView: View, SettingsView: View>: View {
    
    @State private var panelOpen = false
    
    private var appView: AppView
    private var settingsView: SettingsView


    public init(enabled: Bool, settings: TestSettings, @ViewBuilder views: () -> TupleView<(AppView, SettingsView)>) {
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
        .onLongPressGesture(minimumDuration: 1) {
            panelOpen = true
        }
        .sheet(isPresented: $panelOpen) {
            TestSettingsPanel {
                settingsView
            }
        }
        .environmentObject(screenLogState)
    }

}

/// An internal global variable for controlling whether or nat the test harness is enabled. This
/// will get set to the value passed in `enabled:` parameter of the `TestHarness` initializer.
var testHarnessEnabled: Bool = false
