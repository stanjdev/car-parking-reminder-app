//
//  ContentView.swift
//  Shared
//
//  Created by Stanley Jeong on 7/1/22.
//

import SwiftUI
import UserNotifications

struct Settings {
    static let selectedDayKey = "selectedDay"
    static let notify12HrsKey = "notify12Hrs"
    static let notify1HrKey = "notify1Hr"
}

struct ContentView: View {
    enum Day: String, CaseIterable, Identifiable {
        case sunday, monday, tuesday, wednesday, thursday, friday, saturday
        var id: Self { self }
    }
    
    let days = ["dummy", "sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]
    
//    @State private var selectedDay: Day = .monday
    @AppStorage(Settings.selectedDayKey) var selectedDay: Day = .monday
    
//    THESE SHOULD GET FROM LOCALSTORAGE ON FIRST RENDER
    @AppStorage(Settings.notify12HrsKey) var notify12Hrs: Bool = true
//    @State private var notify12Hrs: Bool = true
    @AppStorage(Settings.notify1HrKey) var notify1Hr: Bool = false
//    @State private var notify1Hr: Bool = false
    
    @State private var oneHourBefore: Int = 7
    @State private var twelveHoursBefore: Int = 20
    
    @State private var displayDay12hrs: String = ""
    
    
    func checkPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
//             for notificationRequest:UNNotificationRequest in notificationRequests {
//                 print(notificationRequest.trigger.unsafelyUnwrapped)
////                 change state vars here, for the text view
//            }
        }
    }
    
    func scheduleNotificationTest() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Car parked on \(self.$selectedDay.wrappedValue.rawValue.capitalized) spot"
        content.subtitle = "Move car before 8am \(self.$selectedDay.wrappedValue.rawValue.capitalized)"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleNotification() {
//        Asking for first permission to fire notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    //    CLEAR ANY EXISTING TIME INTERVAL FIRST!
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Repark Car! Car parked on \(self.$selectedDay.wrappedValue.rawValue.capitalized) spot"
        content.subtitle = "Move car before 8am \(self.$selectedDay.wrappedValue.rawValue.capitalized)"
        content.sound = UNNotificationSound.default
        
//        2 separate notifications to be scheduled
        
        if self.$notify1Hr.wrappedValue == true {
//            print("Notify me 1 hr before on \(self.$selectedDay.wrappedValue.rawValue.capitalized): \(self.$notify1Hr.wrappedValue)")
//            let trigger1Hr = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            var date = DateComponents()
//            match day string to day array, get index of
            let index = days.firstIndex(of: self.$selectedDay.wrappedValue.rawValue)
            date.weekday = index.unsafelyUnwrapped
            date.hour = self.$oneHourBefore.wrappedValue
            date.minute = 0
            date.second = 0
            
            let trigger1Hr = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
            let request1Hr = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger1Hr)
            
            UNUserNotificationCenter.current().add(request1Hr)
        }
        
        if self.$notify12Hrs.wrappedValue == true {
//                    trigger 12 hour scheduleNotification() with previous day
//            print("Notify me 12 hrs before: \(self.$notify12Hrs.wrappedValue)")
            var date = DateComponents()
            var index = days.firstIndex(of: self.$selectedDay.wrappedValue.rawValue).unsafelyUnwrapped - 1
            if (index <= 0) {
                index = abs(index - 7)
            }
            displayDay12hrs = days[index]
            
            date.weekday = index
            date.hour = self.$twelveHoursBefore.wrappedValue
            date.minute = 0
            date.second = 0
            
            let trigger12Hr = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
            let request12Hr = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger12Hr)
            
            UNUserNotificationCenter.current().add(request12Hr)
        }
        checkPendingNotifications()
    }
    
    
    var body: some View {
        VStack {
            Text("Car Parked:").font(.system(size: 30, weight: .bold))
            Picker("Day", selection: $selectedDay) {
                ForEach(Day.allCases) { day in
                    Text(day.rawValue.capitalized.prefix(2))
                }
            }
            .pickerStyle(.segmented)
            .onReceive([self.$selectedDay].publisher.first()) { day in
                scheduleNotification()
//                print("\(day.wrappedValue.rawValue.capitalized) picked!")
            }
            
            Form {
                Section(header: Text("Notifications")) {
                    Toggle("12 hrs before", isOn: $notify12Hrs)
                        .onChange(of: notify12Hrs) { value in
//                            print("Notify me 12 hrs before: \(value)")
                            scheduleNotification()
                        }
                    Toggle("1 hr before on \(selectedDay.rawValue.capitalized)", isOn: $notify1Hr)
                        .onChange(of: notify1Hr) { value in
//                            print("Notify me 1 hr before on \(selectedDay.rawValue.capitalized): \(value)")
                            scheduleNotification()
                        }
                }
                if (notify12Hrs) {
                    Text("You will be notified on \(displayDay12hrs.capitalized) at \(twelveHoursBefore - 12):00 PM").font(.system(size: 14, weight: .light))
                }
                if (notify1Hr) {
                    Text("You will be notified on \(selectedDay.rawValue.capitalized) at \(oneHourBefore):00 AM").font(.system(size: 14, weight: .light))
                }

            }
            
            MapView()
//                .frame(height: 600)
            

        
//            VStack {
//                Button("Request Permission") {
//                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
//                        if success {
//                            print("All set!")
//                        } else if let error = error {
//                            print(error.localizedDescription)
//                        }
//                    }
//                }
//                Button("test notif") {
//                    scheduleNotificationTest()
//                }
//            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
