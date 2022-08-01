//
//  PushNotificationController.swift
//  APillLog
//
//  Created by 이지원 on 2022/07/28.
//
import Foundation
import UIKit

class PushNotificationController: UIViewController {
    
    // switch
    @IBOutlet weak var isTakeAlarmSwitch: UISwitch!
    @IBOutlet weak var isWriteAlarmSwitch: UISwitch!
    
    // datePicker
    @IBOutlet weak var morningTimePicker: UIDatePicker!
    @IBOutlet weak var afternoonTimePicker: UIDatePicker!
    @IBOutlet weak var eveningTimePicker: UIDatePicker!
    @IBOutlet weak var noteTimePicker: UIDatePicker!
    @IBOutlet weak var systemPreferenceView: UIView!
    @IBOutlet weak var blockView: UIView!
    
    let UserDefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotificationInfo()
        setChangeListener()
        checkSettingValue()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        self.navigationController?.navigationBar.tintColor = .AColor.accent
        self.navigationItem.title = "알림 설정"
        self.navigationController?.navigationBar.topItem?.title = "뒤로"
    }
    
    
    // MARK: setting View
    @objc func willEnterForeground() {
        checkSettingValue()
    }
    
    private func checkSettingValue() {
        AppDelegate.center.getNotificationSettings(completionHandler: { (setting) in
            
            DispatchQueue.main.async {
                if setting.authorizationStatus == .denied {
                    self.systemPreferenceView.isHidden = false
                    self.blockView.isHidden = false
                } else {
                    self.systemPreferenceView.isHidden = true
                    self.blockView.isHidden = true
                }
            }
        })
    }
    
    @IBAction func linkPreference(_ sender: Any) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
    }
    
    // MARK: notification center
    private func fetchNotificationInfo() {
        
        isTakeAlarmSwitch.isOn = UserDefault.bool(forKey: "isTakeAlarmSwitch")
        isWriteAlarmSwitch.isOn = UserDefault.bool(forKey: "isWriteAlarmSwitch")
        
        morningTimePicker.date = calculateTime(time: UserDefault.string(forKey: "morningTimePicker") ?? "09:00")
        afternoonTimePicker.date = calculateTime(time: UserDefault.string(forKey: "afternoonTimePicker") ?? "13:00")
        eveningTimePicker.date = calculateTime(time: UserDefault.string(forKey: "eveningTimePicker") ?? "19:00")
        noteTimePicker.date = calculateTime(time: UserDefault.string(forKey: "noteTimePicker") ?? "21:00")
    }
    
    private func setChangeListener()  {
        let info: [(UIDatePicker, String, String)] = [
            (morningTimePicker, "morningTimePicker", "아침"),
            (afternoonTimePicker, "afternoonTimePicker", "점심"),
            (eveningTimePicker, "eveningTimePicker", "저녁")
        ]
        
        
        for (timePicker, key, type) in info {
            timePicker.setOnDateChangeListener { [self] in
                UserDefault.set(calculateTime(time: timePicker.date), forKey: key)
                if isTakeAlarmSwitch.isOn {
                    removeNotificationCenter(key: key)
                    addNotificationCenter(key: key, type: type, time: timePicker.date)
                } else {
                    removeNotificationCenter(key: key)
                }
            }
        }
        
        noteTimePicker.setOnDateChangeListener { [self] in
            UserDefault.set(calculateTime(time: noteTimePicker.date), forKey: "noteTimePicker")
            if isWriteAlarmSwitch.isOn {
                removeNotificationCenter(key: "noteTimePicker")
                addNotificationCenter(time: noteTimePicker.date)
            } else {
                removeNotificationCenter(key: "noteTimePicker")
            }
        }
    }
    
    private func addNotificationCenter(time: Date) {
        let notificationCenter = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "오늘도 한 발 더 성장해볼까요?"
        content.body = "노트를 작성해보세요"
        content.sound = UNNotificationSound.default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute], from: time), repeats: true)
        let request = UNNotificationRequest(identifier: "noteTimePicker", content: content, trigger: trigger)
        notificationCenter.add(request) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    
    private func addNotificationCenter(key: String, type: String, time: Date) {
        let notificationCenter = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "저를 잊지 마세요"
        content.body = "\(type)에 깜빡한 일 없나요?"
        content.sound = UNNotificationSound.default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute], from: time), repeats: true)
        let request = UNNotificationRequest(identifier: key, content: content, trigger: trigger)
        notificationCenter.add(request) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    private func removeNotificationCenter(key: String) {
        let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.removePendingNotificationRequests(withIdentifiers: [key])
            notificationCenter.removeDeliveredNotifications(withIdentifiers: [key])
    }
    
    // MARK: Date Picker func
    private func calculateTime(time: String) -> Date {
        setDateFormatter().date(from: time) ?? Date()
    }
    
    private func calculateTime(time: Date) -> String {
        setDateFormatter().string(from: time)
    }
    
    private func setDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }
    
    
    @IBAction func toggleIsTakeAlarmSwitch(_ sender: Any) {
        UserDefault.set(isTakeAlarmSwitch.isOn, forKey: "isTakeAlarmSwitch")
        UserDefault.set(calculateTime(time: morningTimePicker.date), forKey: "morningTimePicker")
        UserDefault.set(calculateTime(time: afternoonTimePicker.date), forKey: "afternoonTimePicker")
        UserDefault.set(calculateTime(time: eveningTimePicker.date), forKey: "eveningTimePicker")
        
        if isTakeAlarmSwitch.isOn {
            addNotificationCenter(key: "morningTimePicker",  type: "아침", time: morningTimePicker.date)
            addNotificationCenter(key: "afternoonTimePicker", type: "점심", time: afternoonTimePicker.date)
            addNotificationCenter(key: "eveningTimePicker", type: "저녁", time: eveningTimePicker.date)
        } else {
            removeNotificationCenter(key: "morningTimePicker")
            removeNotificationCenter(key: "StringafternoonTimePicker")
            removeNotificationCenter(key: "StringeveningTimePicker")
        }
    }
    
    @IBAction func toggleIsWriteAlarmSwitch(_ sender: Any) {
        
        UserDefault.set(isWriteAlarmSwitch.isOn, forKey: "isWriteAlarmSwitch")
        UserDefault.set(calculateTime(time: noteTimePicker.date), forKey: "noteTimePicker")
        if isWriteAlarmSwitch.isOn {
            addNotificationCenter(time: noteTimePicker.date)
        } else {
            removeNotificationCenter(key: "noteTimePicker")
        }
    }
}


@available(iOS 14.0, *)

extension UIDatePicker {
    func setOnDateChangeListener(onDateChanged :@escaping () -> Void){
        self.addAction(UIAction(){ action in
            onDateChanged()
        }, for: .valueChanged)
    }
}
