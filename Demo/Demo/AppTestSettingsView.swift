//
//  Created by Shawn McKee on 10/27/23.
//  Provided by Durable Brand Software LLC.
//  http://durablebrand.software
//

import SwiftUI
import DurableTestHarness


/// The custom SwiftUI view you provide to the test harness for controlling your custom app
/// test settings.
///
/// You embed an instance of this view in the `TestHarness` as the second view,
/// and it will get added to the "**Test Settings**" panel along with the other test harness settings.
/// See `DemoApp.swift` for an example of how it's passed to `TestHarness`.
///
/// Notice how the setting is getting updated in the SwiftUI `Toggle` switch below. You
/// can simply set the value in your custom `TestSettings` class as long as the property
/// has a `didSet` that saves it for you. See `AppTestSettings` for more details.
struct AppTestSettingsView: View {
    
    @State private var skipWelcomeAtLaunch = false
    
    var body: some View {
        VStack {
            Toggle("Skip Welcome View at Launch", isOn: $skipWelcomeAtLaunch)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onChange(of: skipWelcomeAtLaunch) { _, value in
                    AppTestSettings.get().skipWelcomeAtLaunch = value
                }
        }
        .onAppear {
            skipWelcomeAtLaunch = AppTestSettings.get().skipWelcomeAtLaunch
        }
    }
}
