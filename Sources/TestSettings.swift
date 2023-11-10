//
//  Created by Shawn McKee on 10/27/23.
//  Provided by Durable Brand Software LLC.
//  http://durablebrand.software
//

import Foundation


/// The base class for providing test settings for the harness. Apps should subclass this
/// class to provide their own custom app test settings, and then pass an instance of it in
/// the `settings:` parameter of the `TestHarness` initializer.
open class TestSettings: Codable, CustomDebugStringConvertible {
    
    public var hideScreenLogs: Bool = false { didSet { save() } }

    public var infoConsoleLogs: Bool = true { didSet { save() } }
    public var debugConsoleLogs: Bool = true { didSet { save() } }
    public var warnConsoleLogs: Bool = true { didSet { save() } }
    public var errorConsoleLogs: Bool = true { didSet { save() } }
    public var criticalConsoleLogs: Bool = true { didSet { save() } }
    public var todoConsoleLogs: Bool = true { didSet { save() } }

    public var filter: String = "" { didSet { save() } }
    public var doNotFilterErrorCriticalLogs: Bool = true { didSet { save() } }

    public var persistSettings: Bool = true { didSet { save() } }
    
    public required init() {}
    
    /// Used by the test harness to save the settings to local storage as a JSON string. You
    /// should never need to call this function directly.
    public func save() {
        if let json = asJSON {
            let fileURL = TestSettings.getSettingsFileURL()
            try? json.write(to: fileURL, atomically: true, encoding: .utf8)
        }
    }

    /// Used by the test harness to load the current test settings that had been previously
    /// persisted to local storage. You should never need to call this function directly.
    public static func load() -> TestSettings {
        if testHarnessEnabled {
            let fileURL = TestSettings.getSettingsFileURL()
            if let JSON = try? String(contentsOf: fileURL) {
                if let data = JSON.data(using: .utf8) {
                    if var settings = try? JSONDecoder().decode(type(of: currentTestSettings), from: data) {
                        if settings.persistSettings {
                            currentTestSettings = settings
                            return settings
                        } else {
                            settings = type(of: currentTestSettings).init() as! Self
                            settings.persistSettings = false
                            currentTestSettings = settings
                            return settings
                        }
                    }
                }
            }
        }
        return self.init()
    }

    /// Internal helper function to return the name of the saved settings file.
    private static func getSettingsFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent("test.harness.settings")
    }
    
    /// Helper getter to return the settings as a JSON string. This is used, in part,
    /// to persist the settings as JSON to local storage.
    public var asJSON: String? {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(self)
            return String(data: jsonData, encoding: .utf8)
        }
        catch {}
        return nil
    }
    
    /// Required function for the `CustomDebugStringConvertible` protocol, allowing
    /// the settings to writting to the console as a `String`. It uses the `asJSON` getter
    /// to convert the settings to JSON.
    public var debugDescription: String {
        "\(String(describing: type(of: self))): \(asJSON ?? "nil")"
    }
    
}

var currentTestSettings = TestSettings()
