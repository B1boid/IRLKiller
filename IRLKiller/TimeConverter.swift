import UIKit

class TimeConverter: NSObject {
    
    func getCurTimeUTC() -> String{
        let date = Date()
         let format = DateFormatter()
         format.dateFormat = "yyyy-MM-dd HH:mm"
         let formattedDate = format.string(from: date)
         return localToUTC(date: formattedDate)
         
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
        //return allCur-allOld
    
        
    }
    
    func showDiff(oldDate:String,diff:Int) -> Int{
        let curDate = getCurTimeUTC()
        let splitted = curDate.split { ["-", " ", ":"].contains(String($0)) }
        let curVec = splitted.map { Int(String($0).trimmingCharacters(in: .whitespaces)) }
        
        let splitted2 = oldDate.split { ["-", " ", ":"].contains(String($0)) }
        let oldVec = splitted2.map { Int(String($0).trimmingCharacters(in: .whitespaces)) }
        
        let allCur = 525600*(curVec[0]!-2019) + 43800*curVec[1]! + 1440*curVec[2]! + 60*curVec[3]! + curVec[4]!
        let allOld = 525600*(oldVec[0]!-2019) + 43800*oldVec[1]! + 1440*oldVec[2]! + 60*oldVec[3]! + oldVec[4]!
        
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
    

}
