//
//  Created by Shawn McKee on 10/27/23.
//  Provided by Durable Brand Software LLC.
//  http://durablebrand.software
//

import SwiftUI

/// A view used as a welcome view that can be bypassed at launch with the custom test setting
/// provided in this demo app. See `AppTestSettings.swift` and `DemoView.swift`
/// for more details on how that setting is implemented and used.
struct DemoWelcomeView: View {
    var body: some View {
        Text("Welcome\nTo the Test Harness Demo")
            .multilineTextAlignment(.center)
    }
}
