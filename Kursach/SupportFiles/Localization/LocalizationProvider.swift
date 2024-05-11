import Foundation

struct LocalizationProvider {
    // Для получения строки по ключу
    static func localizedString(forKey key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
    
    // Для получения форматированной строки
    static func localizedFormattedString(forKey key: String, _ arguments: CVarArg...) -> String {
        let format = NSLocalizedString(key, comment: "")
        return String(format: format, arguments: arguments)
    }
    
    // Получение локализации с учетом плюрализации
    static func localizedPlurals(forKey key: String, count: Int) -> String {
        let format = NSLocalizedString(key, tableName: nil, bundle: .main, value: "", comment: "")
        return String(format: format, count)
    }
}
