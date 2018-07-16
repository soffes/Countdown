import Foundation
import ScreenSaver

final class Preferences: NSObject {

	// MARK: - Properties

	private let dateKey = "Date2"

	@objc var date: Date? {
		get {
            let timestamp = defaults?.object(forKey: dateKey) as? TimeInterval
			return timestamp.map { Date(timeIntervalSince1970: $0) }
		}

		set {
			if let date = newValue {
                defaults?.set(date.timeIntervalSince1970, forKey: dateKey)
			} else {
                defaults?.removeObject(forKey: dateKey)
			}
			defaults?.synchronize()

            NotificationCenter.default.post(name: .dateDidChange, object: newValue)
		}
	}

	private let defaults: ScreenSaverDefaults? = {
        let bundleIdentifier = Bundle(for: Preferences.self).bundleIdentifier
		return bundleIdentifier.flatMap { ScreenSaverDefaults(forModuleWithName: $0) }
	}()
}

extension Notification.Name {
    static let dateDidChange = Notification.Name(rawValue: "Preferences.dateDidChangeNotification")
}
