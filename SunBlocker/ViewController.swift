//
//  ViewController.swift
//  SunBlocker
//
//  Created by Ricardo Fernandez on 9/12/22.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    
    var seconds = 0.0
    var timer: Timer?
    var isTimerRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc private func applicationWillResignActive() {
        timer?.invalidate()
        
    }
    
    @objc private func applicationDidBecomeActive() {
        
        if let lastTimerStartTime = UserDefaults.standard.value(forKey: "lastTimerStartTime") as? Date,
           let totalTime = UserDefaults.standard.value(forKey: "totalTime") as? Double {
            let timeSinceStartTime = Date() - lastTimerStartTime
            if timeSinceStartTime < totalTime {
                seconds = totalTime - timeSinceStartTime
                runTimer()
            } else {
                seconds = 0
                timeLabel.text = timeString(time: TimeInterval(seconds))
            }
        } else {
            timeLabel.text = timeString(time: TimeInterval(seconds))
        }
        notifyTimerCompleted()
    }
    
    //This begins the timer after user has selected on of the options of time.
    
    @IBAction func startBtn(_ sender: UIButton) {
        if isTimerRunning == false {
            runTimer()
            
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, _ in
                guard success else {
                    return
                }
            }
        }
    }
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
        
        UserDefaults.standard.set(Date(), forKey: "lastTimerStartTime")
        UserDefaults.standard.set(seconds, forKey: "totalTime")
        
        addNotification()
    }
    
    func addNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "Timer Finished"
        content.body = "Time to Reapply!"
        var trigger: UNTimeIntervalNotificationTrigger
        trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let notification = UNNotificationRequest(identifier: "timer", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(notification)
        
        timeLabel.text = timeString(time: TimeInterval(seconds))
        
    }
    
    func notifyTimerCompleted() {
        timeLabel.text = "Reapply!"
    }
    
    @objc func updateTimer(){
        if seconds < 1 {
            timer?.invalidate()
            notifyTimerCompleted()
            
            // Send alert to indicate "Reapply!"
        } else {
            seconds -= 1
            timeLabel.text = timeString(time: TimeInterval(seconds))
        }
    }
    
    //This resets the timer to 0
    
    @IBAction func resetBtn(_ sender: UIButton) {
        timer?.invalidate()
        seconds = 0
        timeLabel.text = timeString(time: TimeInterval(seconds))
        isTimerRunning = false
    }
    
    // Auto timer sets the timer to 2 hours which is the recommened time to reapply sunscreen.
    
    @IBAction func autoTimer(_ sender: UIButton) {
        timer?.invalidate()
        seconds = 7200
        timeLabel.text = timeString(time: TimeInterval(seconds))
        isTimerRunning = false
        self.plusBtn.isHidden = true
        self.minusBtn.isHidden = true
    }
    
    // Sweat or swim timer is a auto timer that is set for 45 minutes. This is the recommened time to reapply if a person is sweating or swimming after applying sun screen
    
    @IBAction func sweatSwimTimer(_ sender: UIButton) {
        timer?.invalidate()
        seconds = 2700
        timeLabel.text = timeString(time: TimeInterval(seconds))
        isTimerRunning = false
        self.plusBtn.isHidden = true
        self.minusBtn.isHidden = true
    }
    
    // Manual button selected, this lets the user set their own time and add or subtract by increments of 15 minutes.
    
    @IBAction func manualBtn(_ sender: UIButton) {
        timer?.invalidate()
        seconds = 3600
        timeLabel.text = timeString(time: TimeInterval(seconds))
        isTimerRunning = false
        self.plusBtn.isHidden = false
        self.minusBtn.isHidden = false
    }
    
    @IBAction func plusBtn(_ sender: UIButton) {
        seconds += 900
        timeLabel.text = timeString(time: TimeInterval(seconds))
    }
    
    @IBAction func minusBtn(_ sender: UIButton) {
        if (seconds > 900) { seconds -= 900}
        timeLabel.text = timeString(time: TimeInterval(seconds))
    }
    
    // TimeString Function
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}


