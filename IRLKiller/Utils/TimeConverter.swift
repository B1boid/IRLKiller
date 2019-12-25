import UIKit

class TimeConverter: NSObject {
    
    private static let minuteFormatter = "yyyy-MM-dd HH:mm"
    private static let secondFormatter = "yyyy-MM-dd HH:mm:ss"
    
    private static let separatorSymbols: [Character] = ["-", " ", ":"]
    
    enum EvaluateTime {
        case minute
        case second
        
        func getFormatter() -> String {
            switch self {
            case .minute:
                return minuteFormatter
            case .second:
                return secondFormatter
            }
        }
    }
    
    class private func parseTimeToVector(date: String) -> [UInt] {
        let vector = date
            .split { separatorSymbols.contains($0) }
            .map   { UInt($0.trimmingCharacters(in: .whitespaces))! }
        
        return vector
    }
    
    class func convertToUTC(in timeValue: EvaluateTime) -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = timeValue.getFormatter()
        let formattedDate = format.string(from: date)
        return localToUTC(date: formattedDate, in: timeValue)
    }
    
    class func isMoreThanInterval(oldDate: String, interval: UInt, in timeValue: EvaluateTime) -> Bool {
        return showInterval(oldDate: oldDate, in: timeValue) > interval
    }
    
    class private func reduceVector(date: String, in timeValue: EvaluateTime) -> UInt {
        let vector = parseTimeToVector(date: date)
        let calculated =
            (vector[0] - Date.releaseYear) * Date.minsInYear +
             vector[1] * Date.minsInMonth +
             vector[2] * Date.minsInDay +
             vector[3] * Date.minsInHour +
             vector[4]
        
        switch timeValue {
        case .minute:
            return calculated
        case .second:
            return 60 * calculated + vector.last!
        }
    }
    
    class func showInterval(oldDate: String, in timeValue: EvaluateTime) -> UInt {
        let curDate = convertToUTC(in: timeValue)
        let newVector = reduceVector(date: curDate, in: timeValue)
        let oldVector = reduceVector(date: oldDate, in: timeValue)
        return oldVector > newVector ? 0 : newVector - oldVector
    }
    
    class func localToUTC(date: String, in timeValue: EvaluateTime) -> String {
        let formatter = timeValue.getFormatter()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = formatter
        
        return dateFormatter.string(from: dt!)
    }
}

extension Date {
    
    static let minsInHour: UInt = 60
    static let minsInDay = 24 * Date.minsInHour
    static let minsInMonth = 30 * Date.minsInDay
    static let minsInYear = 12 * Date.minsInMonth
    static let releaseYear: UInt = 2019
    
}
