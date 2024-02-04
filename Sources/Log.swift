//
//  Created by Shawn McKee on 10/27/23.
//  Provided by Durable Brand Software LLC.
//  http://durablebrand.software
//

import Foundation

/// A helper class with static functions that perform enhanced logging to the console and to the screen.
public class Log {
    
    /// Logs a string or object to the console as an INFO (👁) type log. The `functionName`, `fileName`, and `lineNumber` parameters will be generated for you.
    /// - Parameter message: The string or object to log to the console. If the object is `nil` then the string “nil” will be displayed in the console.
    /// - Parameter filter: An optional filter tag to apply to the log, which can then be filtered on through the **Test Settings** panel.
    public static func info(_ message:Any?, filter: String? = nil, functionName: String = #function, fileName: String = #file ,lineNumber: Int = #line) {
        log(type: .info, message:  message, filter: filter, functionName: functionName, fileName: fileName, lineNumber: lineNumber);
    }
    
    /// Logs a string or object to the console as a DEBUG (🕸) type log. The `functionName`, `fileName`, and `lineNumber` parameters will be generated for you.
    /// - Parameter message: The string or object to log to the console. If the object is `nil` then the string “nil” will be displayed in the console.
    /// - Parameter filter: An optional filter tag to apply to the log, which can then be filtered on through the **Test Settings** panel.
    public static func debug(_ message:Any?, filter: String? = nil, functionName: String = #function, fileName: String = #file ,lineNumber: Int = #line) {
        log(type: .debug, message:  message, filter: filter, functionName: functionName, fileName: fileName, lineNumber: lineNumber);
     }
    
    /// Logs a string or object to the console as a WARN (⚠️) type log. The `functionName`, `fileName`, and `lineNumber` parameters will be generated for you.
    /// - Parameter message: The string or object to log to the console. If the object is `nil` then the string “nil” will be displayed in the console.
    /// - Parameter filter: An optional filter tag to apply to the log, which can then be filtered on through the **Test Settings** panel.
    public static func warn(_ message:Any?, filter: String? = nil, functionName: String = #function, fileName: String = #file ,lineNumber: Int = #line) {
        log(type: .warn, message:  message, filter: filter, functionName: functionName, fileName: fileName, lineNumber: lineNumber);
    }
    
    /// Logs a string or object to the console as an ERROR (‼️) type log. The `functionName`, `fileName`, and `lineNumber` parameters will be generated for you.
    /// - Parameter message: The string or object to log to the console. If the object is `nil` then the string “nil” will be displayed in the console.
    /// - Parameter filter: An optional filter tag to apply to the log, which can then be filtered on through the **Test Settings** panel.
    public static func error(_ message:Any?, filter: String? = nil, functionName: String = #function, fileName: String = #file ,lineNumber: Int = #line) {
        log(type: .error, message:  message, filter: filter, functionName: functionName, fileName: fileName, lineNumber: lineNumber);
    }
    
    /// Logs a string or object to the console as a CRITICAL (🛑) type log. The `functionName`, `fileName`, and `lineNumber` parameters will be generated for you.
    /// - Parameter message: The string or object to log to the console. If the object is `nil` then the string “nil” will be displayed in the console.
    /// - Parameter filter: An optional filter tag to apply to the log, which can then be filtered on through the **Test Settings** panel.
    public static func critical(_ message:Any?, filter: String? = nil, functionName: String = #function, fileName: String = #file ,lineNumber: Int = #line) {
        log(type: .critical, message:  message, filter: filter, functionName: functionName, fileName: fileName, lineNumber: lineNumber);
    }
    
    /// Logs a string or object to the console as a TODO (📌) type log. The `functionName`, `fileName`, and `lineNumber` parameters will be generated for you.
    /// - Parameter message: The string or object to log to the console. If the object is `nil` then the string “nil” will be displayed in the console.
    /// - Parameter filter: An optional filter tag to apply to the log, which can then be filtered on through the **Test Settings** panel.
    public static func todo(_ message:Any?, filter: String? = nil, functionName: String = #function, fileName: String = #file ,lineNumber: Int = #line) {
        log(type: .todo, message:  message, filter: filter, functionName: functionName, fileName: fileName, lineNumber: lineNumber);
    }
    
    /// Logs a string or object to the screen in a semi-transparent list that overlays the app view. The list grows with each now screen log, adding the most resent
    /// message to the top of the list.
    /// - Parameter message: The string or object to log to the screen. If the object passed is `nil` then the string “nil” will be displayed.
    /// - Parameter details: An optional line of details that will be displayed in smaller type under the message.
    public static func toScreen(_ message: Any?, details: Any? = nil) {
        if testHarnessEnabled {
            testHarnessState.addScreenLogMessage((message != nil ? String(describing: message!) : "nil"), details: (details != nil ? String(describing: details!) : nil))
        }
    }
    
    /// Internal function for sending the log to the console.
    private static func log(type: LogType, message: Any?, filter: String?, functionName: String, fileName: String, lineNumber: Int) {
        if canLog(type, filter) {
            print(generateConsoleLogString(type: type, message: message, filter: filter, functionName: functionName, fileName: fileName, lineNumber: lineNumber))
        }
    }
    
    /// Internal function for composing the `String` to log to the console.
    private static func generateConsoleLogString(type: LogType, message: Any?, filter: String?, functionName: String, fileName: String, lineNumber: Int) -> String {
        var logString = ""
        if canLog(type, filter) {
            var symbol = ""
            
            switch type {
            case .info:
                symbol = "👁"
            case .debug:
                symbol = "🕸"
            case .warn:
                symbol = "⚠️"
            case .error:
                symbol = "‼️"
            case .critical:
                symbol = "🛑"
            case .todo:
                symbol = "📌 TODO:"
            }
            
            logString = "\(symbol)\t====> \(message != nil ? String(describing: message!) : "nil") ............ \(URL(fileURLWithPath: fileName).lastPathComponent): \(functionName) [Line: \(lineNumber)]"
        }
        return logString
    }

    /// Internal function for determining if the type of log should be displayed, based on the settings and filter
    /// set in the “Test Settings” panel.
    private static func canLog(_ type: LogType, _ filter: String?) -> Bool {
        
        if !testHarnessEnabled { return false }
        
        let settings = TestSettings.load()
        
        var filterMatches = (filter ?? "") == settings.filter
        if settings.filter == "" { filterMatches = true }
        
        switch type {
        case .info:
            return settings.infoConsoleLogs && filterMatches
        case .debug:
            return settings.debugConsoleLogs && filterMatches
        case .warn:
            return settings.warnConsoleLogs && filterMatches
        case .error:
            return (settings.errorConsoleLogs && filterMatches) || (settings.errorConsoleLogs && !filterMatches && settings.doNotFilterErrorCriticalLogs)
        case .critical:
            return (settings.criticalConsoleLogs && filterMatches) || (settings.criticalConsoleLogs && !filterMatches && settings.doNotFilterErrorCriticalLogs)
        case .todo:
            return settings.todoConsoleLogs && filterMatches
        }
    }
}


/// The internal enum for specifying log types.
private enum LogType {
    case info
    case debug
    case warn
    case error
    case critical
    case todo
}
