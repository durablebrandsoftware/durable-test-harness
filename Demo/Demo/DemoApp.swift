//
//  Created by Shawn McKee on 10/27/23.
//  Provided by Durable Brand Software LLC.
//  http://durablebrand.software
//

import SwiftUI
import DurableTestHarness

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            DemoView()
                .withTestHarness(
                    settings: AppTestSettings(),
                    settingsView: AppTestSettingsView(),
                    enabled: true
                )
                .withTestSettingsPanelAccess()
        }
    }
}
