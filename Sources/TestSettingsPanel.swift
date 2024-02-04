//
//  Created by Shawn McKee on 10/27/23.
//  Provided by Durable Brand Software LLC.
//  http://durablebrand.software
//

import SwiftUI

/// The internal SwiftUI view used to display the "**TestSettings**" panel. The panel
/// is displayed whenever you long-press on the view you embedded in the `TestHarness` view.
struct TestSettingsPanel<Content: View>: View {

    @EnvironmentObject private var testHarnessState: TestHarnessState
    @Environment(\.dismiss) private var dismiss

    @ViewBuilder public let appTestingControlSettingsView: () -> Content

    @State private var hideScreenLogs = false
    @State private var infoConsoleLogs = true
    @State private var debugConsoleLogs = true
    @State private var warnConsoleLogs = true
    @State private var errorConsoleLogs = true
    @State private var criticalConsoleLogs = true
    @State private var todoConsoleLogs = true

    @State private var filter: String = ""
    @State private var doNotFilterErrorCriticalLogs = true

    @State private var persistSettings = true

    var body: some View {
        let appTestingControlSettingsView = self.appTestingControlSettingsView()
        return ScrollView {
            VStack {
                
                Text("Test Settings")
                    .font(.title2)
                    .padding()
                    .textCase(.uppercase)
                    .padding(.bottom, -15)

                if !(appTestingControlSettingsView is EmptyView) {
                    SectionHeader("App Test Settings")
                    appTestingControlSettingsView
                }
                
                consoleLogSettings()
                footerSettings()
            }
            .padding()
            .padding(.top, 8)
        }
        .overlay(alignment: .topTrailing) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
            }
            .buttonStyle(.plain)
            .padding()
        }
        .onAppear {
            let settings = TestSettings.load()
            hideScreenLogs = settings.hideScreenLogs
            infoConsoleLogs = settings.infoConsoleLogs
            debugConsoleLogs = settings.debugConsoleLogs
            warnConsoleLogs = settings.warnConsoleLogs
            errorConsoleLogs = settings.errorConsoleLogs
            criticalConsoleLogs = settings.criticalConsoleLogs
            todoConsoleLogs = settings.todoConsoleLogs

            filter = settings.filter
            doNotFilterErrorCriticalLogs = settings.doNotFilterErrorCriticalLogs

            persistSettings = settings.persistSettings
        }

    }
    
    private func consoleLogSettings() -> some View {
        return VStack {
            SectionHeader("Logging")
            Toggle("Hide Screen Logs", isOn: $hideScreenLogs)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onChange(of: hideScreenLogs) { value in
                    TestSettings.load().hideScreenLogs = hideScreenLogs
                    testHarnessState.hideScreenLogs = hideScreenLogs
                }
            SettingHeader("Console Logs:")
            Toggle("👁 INFO", isOn: $infoConsoleLogs)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onChange(of: infoConsoleLogs) { value in
                    TestSettings.load().infoConsoleLogs = infoConsoleLogs
                }
            Toggle("🕸 DEBUG", isOn: $debugConsoleLogs)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onChange(of: debugConsoleLogs) { value in
                    TestSettings.load().debugConsoleLogs = debugConsoleLogs
                }
            Toggle("⚠️ WARN", isOn: $warnConsoleLogs)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onChange(of: warnConsoleLogs) { value in
                    TestSettings.load().warnConsoleLogs = warnConsoleLogs
                }
            Toggle("‼️ ERROR", isOn: $errorConsoleLogs)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onChange(of: errorConsoleLogs) { value in
                    TestSettings.load().persistSettings = errorConsoleLogs
                }
            Toggle("🛑 CRITICAL", isOn: $criticalConsoleLogs)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onChange(of: criticalConsoleLogs) { value in
                    TestSettings.load().criticalConsoleLogs = criticalConsoleLogs
                }
            Toggle("📌 TODO", isOn: $todoConsoleLogs)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onChange(of: todoConsoleLogs) { value in
                    TestSettings.load().todoConsoleLogs = todoConsoleLogs
                }
            SettingHeader("Filter:")
            TextField(
                "Enter as the **`filter:`** param to **`Log`** calls",
                text: $filter
            )
            .onChange(of: filter) { value in
                TestSettings.load().filter = value.trimmingCharacters(in: .whitespaces)
            }
            #if os(iOS)
            .textInputAutocapitalization(.never)
            #endif
            .disableAutocorrection(true)
            .padding(.bottom, 8)

            Toggle("Do Not Filter ERROR or CRITICAL Logs", isOn: $doNotFilterErrorCriticalLogs)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onChange(of: doNotFilterErrorCriticalLogs) { value in
                    TestSettings.load().doNotFilterErrorCriticalLogs = doNotFilterErrorCriticalLogs
                }
        }
    }
    
    private func footerSettings() -> some View {
        let settings = TestSettings.load()
        return VStack {
            SectionDivider()
            Toggle("Persist Between Launches", isOn: $persistSettings)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onChange(of: persistSettings) { value in
                    settings.persistSettings = persistSettings
                }
        }
    }
}


/// Internal SwiftUI view to produce a section divider in the settings panel.
private struct SectionDivider: View{
    @Environment(\.colorScheme) var colorScheme
    init() {}
    var body: some View {
        Divider()
            .overlay(colorScheme == .dark ? Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.4) : Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.1))
            .padding(.top, 15)
            .padding(.bottom, 8)
    }
}


/// Internal SwiftUI view to produce a section header in the settings panel.
private struct SectionHeader: View{
    private var text: String

    init(_ text: String) { self.text = text }
    
    var body: some View {
        VStack(spacing: 0) {
            SectionDivider()
            Text(text)
                .font(.caption)
                .textCase(.uppercase)
                .opacity(0.5)
        }
    }
}


/// Internal SwiftUI view to produce a header for a particular setting.
private struct SettingHeader: View{
    private var text: String

    public init(_ text: String) { self.text = text }
    
    var body: some View {
        Text(text)
            .font(.caption)
            .textCase(.uppercase)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 10)
    }
}
