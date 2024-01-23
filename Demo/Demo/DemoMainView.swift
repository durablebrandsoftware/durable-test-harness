//
//  Created by Shawn McKee on 10/27/23.
//  Provided by Durable Brand Software LLC.
//  http://durablebrand.software
//

import SwiftUI
import DurableTestHarness

/// The main Demo view, with UI demonstrating the various logging enhancements of the test harness, and some
/// instructions on how to pull up the "**Test Settings**" panel.
struct DemoMainView: View {
    var body: some View {
        VStack(spacing: 20) {
            
            // Adding some buttons to the app view to trigger some example screen and console logging...
            
            Button("Action One (INFO Log)") {
                Log.toScreen("Action One Triggered", details: "With INFO logged to console.")
                Log.info("An INFO Log")
            }
            Button("Action Two (DEBUG Log)") {
                Log.toScreen("Action Two Triggered", details: "With DEBUG logged to console.")
                Log.debug("A DEBUG Log")
            }
            Button("Action Three (WARN Log)") {
                Log.toScreen("Action Three Triggered", details: "With WARN logged to console.")
                Log.warn("A WARN Log")
           }
            Button("Action Four (ERROR Log)") {
                Log.toScreen("Action Four Triggered", details: "With ERROR logged to console.")
                Log.error("An ERROR Log")
            }
            Button("Action Five (CRITICAL Log)") {
                Log.toScreen("Action Five Triggered", details: "With CRITICAL logged to console.")
                Log.critical("A CRITICAL Log")
            }
            Button("Action Six (TODO Log)") {
                Log.toScreen("Action Six Triggered", details: "With TODO logged to console.")
                Log.todo("A TODO Log")
            }

            Button("Log Test Settings") {
                Log.toScreen("Current Test Settings", details: AppTestSettings.get())
                Log.info(AppTestSettings.get())
            }
            
            Text("Press and hold on the screen (anywhere a button doesn’t exist) to open up the “__Test Settings__” panel.")
                .padding(.top, 20)
                .opacity(0.25)
                .multilineTextAlignment(.center)
            
        }
        .padding()
        .onAppear {
            // Log a screen message on startup to have an example log message appear first thing.
            Log.toScreen("Demo View Has Appeared", details: "Ready for user interaction.")
        }
    }
}

#Preview {
    DemoMainView()
}
