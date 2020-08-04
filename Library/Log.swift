import Foundation
import os.log

public class Log {
    private init() {}

    public static func debug(_ message: String) {
        writeLog(message: message, level: .debug)
    }

    public static func info(_ message: String) {
        writeLog(message: message, level: .info)
    }

    public static func error(_ message: String) {
        writeLog(message: message, level: .error)
    }

    public static func error(error: Error) {
        let message = String(reflecting: error)
        writeLog(message: message, level: .error)
    }

    public static func fatal(message: String, file: String = #file, function: String = #function, line: Int = #line) {
        writeLog(message: message, level: .fatal)
        assertionFailure(message)
    }

    public static func fatal(error: Error) {
        let message = String(reflecting: error)
        writeLog(message: message, level: .fatal)

        assertionFailure(message)
    }

    private static func writeLog(message: String, level: Level) {
        os_log("%@%@", log: .default, type: .debug, level.description, message)
    }

    private enum Level: CustomStringConvertible {
        case debug, info, error, fatal

        var description: String {
            switch self {
            case .debug: return "🔨"
            case .info: return "ℹ️"
            case .error: return "❗️️"
            case .fatal: return "😱"
            }
        }
    }
}
