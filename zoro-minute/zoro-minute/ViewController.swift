//
//  ViewController.swift
//  zoro-minute
//
//  Created by 鈴木悠介 on 2022/03/16.
//

import UIKit
import UserNotifications

let zorome = [11111,22222,33333,44444,55555,111111,222222,235960]
let zoromeDate = [1]

class ViewController: UIViewController {
    
    @IBOutlet weak var countDownLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var timer = Timer()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        setNotification()
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute, .second]
        
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {(timer) in
            let now = getNowDate()
            let now0 = DateComponents(calendar: Calendar.current, hour: now.hour, minute: now.minute, second: now.second).date!
            var target: DateComponents
            if let i = zorome.firstIndex(where: {$0 > dateToInt(date: now)}) {
                print(zorome[i])
                target = setDate(time: zorome[i])
            } else {
                target = setDate(time: 0)
            }
            let nowDate = now.date
            let targetDate = target.date!
            
            let elapseTime = Calendar.current.dateComponents([.hour, .minute, .second], from: now0, to: targetDate)
            self.countDownLabel.text = String(elapseTime.hour!) + "h " + String(elapseTime.minute!) + "m " + String(elapseTime.second!) + "s"
        })
        
//        var calendar = Calendar.current
//        let trigger: UNNotificationTrigger
//        let now = getNowDate()
//        var notificationTime = nextNotificationTime()
//        let content = UNMutableNotificationContent()
//
//        trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)
////        trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)
//
//        content.title = "お知らせ"
//        content.body = "ボタンを押しました。"
//        content.sound = UNNotificationSound.default
//
//        // 直ぐに通知を表示
//        let request = UNNotificationRequest(identifier: "zorome", content: content, trigger: trigger)
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

func getNowDate() -> DateComponents {
    let dt = Date()
//    let now = DateComponents()

    let now = Calendar.current.dateComponents([.hour, .minute, .second], from: dt)
    
    return now
}

func nextNotificationTime() -> DateComponents {
    let nowDate = getNowDate()
    var notificationTime = nowDate
    
    var y = nowDate.year!
    var M = nowDate.month!
    var d = nowDate.day!
    var h = nowDate.hour!
    var m = nowDate.minute!
    var s = nowDate.second!
    s += 1
    
    var time = dateToInt(h: h, m: m, s: s)
//    time = Calendar.current.date(byAdding: .second, value: 1, to: notificationTime)
    
    if let i = zorome.firstIndex(where: {$0 > time}) {
        print(zorome[i])
        return setDate(time: zorome[i])
    }
    
    return setDate(time: 235960)
}

public func setNotification() {
    var calendar = Calendar.current
    var trigger = [UNNotificationTrigger]()
    var request = [UNNotificationRequest]()
    let content = UNMutableNotificationContent()
    content.title = "ゾロ目10秒前"
    content.body = "備えて。"
    content.sound = UNNotificationSound.default
    
    for (index, time) in zorome.enumerated() {
        trigger.append(UNCalendarNotificationTrigger(dateMatching: setDate(time: time - 10), repeats: true))
        request.append(UNNotificationRequest(identifier: "zorome" + String(index), content: content, trigger: trigger[index]))
        UNUserNotificationCenter.current().add(request[index], withCompletionHandler: nil)
    }
    
    
    // 直ぐに通知を表示
//    let request = UNNotificationRequest(identifier: "zorome", content: content, trigger: trigger[0])
//    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    
//    let f = DateFormatter()
//    f.timeStyle = .medium
//    f.dateStyle = .none
//    f.locale = Locale(identifier: "ja_JP")
//    let nowDate = Date()
    
}

func dateToString(date: DateComponents) -> String {
    let str = String(date.hour! & date.minute! & date.second!)
    
    return str
}

func dateToInt(h: Int, m: Int, s: Int) -> Int {
    
    return h * 10000 + m * 100 + s
}

func dateToInt(date: DateComponents) -> Int {
    
    return date.hour! * 10000 + date.minute! * 100 + date.second!
}

func setDate(time: Int) -> DateComponents {
//    var date = DateComponents()
//    date.year = now.year
//    date.month = now.month
//    date.day = now.day
//    date.hour = (time / 10000) % 100
//    date.minute = (time / 100) % 100
//    date.second = time % 100
    
    let hour = (time / 10000) % 100
    let minute = (time / 100) % 100
    let second = time % 100
    
    let date = DateComponents(calendar: Calendar.current, hour: hour, minute: minute, second: second)
    
//    date.hour = 20
//    date.minute = 16
//    date.second = 0

    return date
}

func isZorome(time: Int) -> Bool {
    if time == 0 { return true }
    let nsstring = String(time)
    let pattern = "^([0-9])\\1+$"
    guard let regex = try? NSRegularExpression(pattern: pattern, options: [.anchorsMatchLines]) else { return false }
    
    let range = NSRange(location: 0, length: (nsstring as NSString).length)
    
    let result = regex.matches(in: nsstring, options: [], range: range)
    
    return result.count > 0
}

