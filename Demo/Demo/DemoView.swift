//
//  Created by Shawn McKee on 10/27/23.
//  Provided by Durable Brand Software LLC.
//  http://durablebrand.software
//

import SwiftUI
import DurableTestHarness

/// The startup SwiftUI view for the demo, with logic to determine if the welcome view should be displayed
/// before the main demo view.
struct DemoView: View {
    
    /// The internal state that determines if the welcome view should be displayed. Notice that it
    /// is initially set to the custom test setting provided in the `AppTestSettings` object. It's safe to do
    /// this even for your App Store release, as long as `skipWelcomeAtLaunch` as a default value set
    /// to how that App Store release should behave.
    @State private var showWelcome = !AppTestSettings.get().skipWelcomeAtLaunch
    
    /// The timer for keeping the welcome view visible.
    let welcomeWaitTimer = Timer.publish(every: 2.5, on: .current, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            if showWelcome {
                DemoWelcomeView()
            } else {
                DemoMainView()
            }
        }
        .onReceive(welcomeWaitTimer) { _ in
            welcomeWaitTimer.upstream.connect().cancel()
            withAnimation {
                showWelcome = false
            }
        }
#if os(OSX)
        .frame(minWidth: 800, minHeight: 700) // Make sure the Mac window has a default, minimum size when displayed on the desktop.
#endif
    }
}
