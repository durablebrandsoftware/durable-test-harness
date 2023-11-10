//
//  Created by Shawn McKee on 10/27/23.
//  Provided by Durable Brand Software LLC.
//  http://durablebrand.software
//

import DurableTestHarness

/// The custom test settings unique to the app. Your app test settings must be a subclass
/// of `TestSettings`, and you pass an instance of it in the `settings:` parameter
/// of the `TestHarness` initializer.
///
/// Because settings are a class and not a struct, you need to provide encoding
/// and decoding code for your custom settings so that it can be persisted and saved to local storage
/// as a JSON string. Examples of this have been provided here for your reference to use in your own
/// settings file.
class AppTestSettings: TestSettings {
    
    /// An example of an app-specific test settings. Make sure to give your custom settings a
    /// default value (in this case, `false`) for what the setting should be for your App Store release build.
    /// Also, make sure to provide a `didSet` with a call `save()` as show, so that any time you change
    /// the setting, it will get persisted to local storage.
    public var skipWelcomeAtLaunch: Bool = false { didSet { save() } }
    
    /// A static, convenience function for getting the latest test settings. Providing this kind of function in your own
    /// custom settings will make it easier to access your settings in your app's code. See `DemoView.swift`
    /// for an example of how it access and uses the test settings.
    static func get() -> AppTestSettings { return (load() as! AppTestSettings) }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        skipWelcomeAtLaunch = try container.decode(Bool.self, forKey: .skipWelcomeAtLaunch)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.skipWelcomeAtLaunch, forKey: .skipWelcomeAtLaunch)
    }

    private enum CodingKeys: String, CodingKey {
        case skipWelcomeAtLaunch
    }

    /// An initializer that simply calls the `super.init()` is required for the encoder.
    required init() { super.init() }
    
}
