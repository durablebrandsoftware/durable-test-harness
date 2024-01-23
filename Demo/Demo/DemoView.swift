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
    
    @State private var showWelcome = true
    
    /// The timer for keeping the welcome view visible.
    let welcomeWaitTimer = Timer.publish(every: 2.5, on: .current, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            if showWelcome && !AppTestSettings.get().skipWelcomeAtLaunch {
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
