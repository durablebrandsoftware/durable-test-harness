//
//  Created by Shawn McKee on 10/27/23.
//  Provided by Durable Brand Software LLC.
//  http://durablebrand.software
//

import SwiftUI

/// The internal view for displaying the screen log messages.
struct ScreenLogView: View {

    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject fileprivate var screenLogState: ScreenLogState
    
    /// Returns the fully composed `ScreenLog` view.
    var body: some View {
        let messageBackgroundColor = (colorScheme == .dark ? Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.25) : Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.4))
        return VStack(spacing: 1) {
            if screenLogState.messages.count > 0 && !screenLogState.hidden {
                HStack {
                    Button {
                        clearLog()
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .background(messageBackgroundColor)
                }
                VStack(spacing: 1) {
                    ForEach(screenLogState.messages) { message in
                        HStack {
                            VStack {
                                Text(message.text)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundStyle(.white)
                                if let details = message.details {
                                    Text(details)
                                        .font(.footnote)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                        .allowsHitTesting(false)
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .background(messageBackgroundColor)
                    }
                    Spacer()
                }
                .allowsHitTesting(false)
            }
        }
    }
    
    private func clearLog() {
        screenLogState.messages = [ScreenLogMessage]()
    }
    
    private func removeMessage(id: String) {
        var foundIndex: Int? = nil
        for index in 0..<screenLogState.messages.count {
            let message = screenLogState.messages[index]
            if message.id == id {
                foundIndex = index
            }
        }
        if let index = foundIndex {
            screenLogState.messages.remove(at: index)
        }
    }
    
}

/// The internal struct representing a screen log message.
struct ScreenLogMessage: Identifiable, Codable {
    var id: String = UUID().uuidString
    var text: String
    var details: String?
}


/// The internal observable state object for managing and updating the screen log .
class ScreenLogState: ObservableObject {

    @Published var messages = [ScreenLogMessage]()
    @Published var hidden = TestSettings.load().hideScreenLogs

    func addMessage(_ text: String, details: String? = nil) {
        messages.insert(ScreenLogMessage(text: text, details: details), at: 0)
    }
}
var screenLogState = ScreenLogState()

