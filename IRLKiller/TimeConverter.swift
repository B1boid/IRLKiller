import UIKit

class TimeConverter: NSObject {
    
    func getCurTimeUTC() -> String{
        let date = Date()
         let format = DateFormatter()
         format.dateFormat = "yyyy-MM-dd HH:mm"
         let formattedDate = format.string(from: date)
         return localToUTC(date: formattedDate)
         
    }
    
    func getCurTimeUTCWithSec() -> String{
        let date = Date()
         let format = DateFormatter()
         format.dateFormat = "yyyy-MM-dd HH:mm:ss"
         let formattedDate = format.string(from: date)
         return localToUTCWithSec(date: formattedDate)
         
    }
    
    func isMoreThenDiff(oldDate:String,diff:Int) -> Bool{
        let curDate = getCurTimeUTC()
        let splitted = curDate.split { ["-", " ", ":"].contains(String($0)) }
        let curVec = splitted.map { Int(String($0).trimmingCharacters(in: .whitespaces)) }
        
        let splitted2 = oldDate.split { ["-", " ", ":"].contains(String($0)) }
        let oldVec = splitted2.map { Int(String($0).trimmingCharacters(in: .whitespaces)) }
        
        let allCur = 525600*(curVec[0]!-2019) + 43800*curVec[1]! + 1440*curVec[2]! + 60*curVec[3]! + curVec[4]!
        let allOld = 525600*(oldVec[0]!-2019) + 43800*oldVec[1]! + 1440*oldVec[2]! + 60*oldVec[3]! + oldVec[4]!
        return allCur-allOld > diff
        
    }
    
    func isMoreThenDiffInSeconds(oldDate:String,diff:Int) -> Bool{
        let curDate = getCurTimeUTCWithSec()
        let splitted = curDate.split { ["-", " ", ":"].contains(String($0)) }
        let curVec = splitted.map { Int(String($0).trimmingCharacters(in: .whitespaces)) }
        
        let splitted2 = oldDate.split { ["-", " ", ":"].contains(String($0)) }
        let oldVec = splitted2.map { Int(String($0).trimmingCharacters(in: .whitespaces)) }
        
        let allCur = 525600*60*(curVec[0]!-2019) + 43800*60*curVec[1]! + 1440*60*curVec[2]! + 60*60*curVec[3]! + 60*curVec[4]! + curVec[5]!
        let allOld = 525600*60*(oldVec[0]!-2019) + 43800*60*oldVec[1]! + 1440*60*oldVec[2]! + 60*60*oldVec[3]! + 60*oldVec[4]!+oldVec[5]!
        return allCur-allOld > diff
        
    }
    
    func showDiff(oldDate:String) -> Int{
        let curDate = getCurTimeUTC()
        let splitted = curDate.split { ["-", " ", ":"].contains(String($0)) }
        let curVec = splitted.map { Int(String($0).trimmingCharacters(in: .whitespaces)) }
        
        let splitted2 = oldDate.split { ["-", " ", ":"].contains(String($0)) }
        let oldVec = splitted2.map { Int(String($0).trimmingCharacters(in: .whitespaces)) }
        
        let allCur = 525600*(curVec[0]!-2019) + 43800*curVec[1]! + 1440*curVec[2]! + 60*curVec[3]! + curVec[4]!
        let allOld = 525600*(oldVec[0]!-2019) + 43800*oldVec[1]! + 1440*oldVec[2]! + 60*oldVec[3]! + oldVec[4]!
        
        return allCur-allOld
    }
    
    func showDiffInSec(oldDate:String) -> Int{
        let curDate = getCurTimeUTCWithSec()
        let splitted = curDate.split { ["-", " ", ":"].contains(String($0)) }
        let curVec = splitted.map { Int(String($0).trimmingCharacters(in: .whitespaces)) }
        
        let splitted2 = oldDate.split { ["-", " ", ":"].contains(String($0)) }
        let oldVec = splitted2.map { Int(String($0).trimmingCharacters(in: .whitespaces)) }
        
        let allCur = 525600*60*(curVec[0]!-2019) + 43800*60*curVec[1]! + 1440*60*curVec[2]! + 60*60*curVec[3]! + 60*curVec[4]! + curVec[5]!
        let allOld = 525600*60*(oldVec[0]!-2019) + 43800*60*oldVec[1]! + 1440*60*oldVec[2]! + 60*60*oldVec[3]! + 60*oldVec[4]!+oldVec[5]!
        return allCur-allOld
    }
    
    
    
    func localToUTC(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current

        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        return dateFormatter.string(from: dt!)
    }
    
    func localToUTCWithSec(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current

        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return dateFormatter.string(from: dt!)
    }
    
    

}
