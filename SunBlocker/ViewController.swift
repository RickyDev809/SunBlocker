//
//  ViewController.swift
//  SunBlocker
//
//  Created by Ricardo Fernandez on 9/12/22.
//

import UIKit
import UserNotifications
import AVFoundation

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var autoBtn: UIButton!
    @IBOutlet weak var customBtn: UIButton!
    @IBOutlet weak var sweatSwimBtn: UIButton!
    
    var seconds = 0.0
    var timer: Timer?
    var isTimerRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().unselectedItemTintColor = .black
        
        startBtn.layer.cornerRadius = startBtn.frame.width / 2
        startBtn.layer.masksToBounds = true
        resetBtn.layer.cornerRadius = resetBtn.frame.width / 2
        resetBtn.layer.masksToBounds = true
        autoBtn.layer.cornerRadius = autoBtn.frame.width / 2
        autoBtn.layer.masksToBounds = true
        customBtn.layer.cornerRadius = customBtn.frame.width / 2
        customBtn.layer.masksToBounds = true
        sweatSwimBtn.layer.cornerRadius = sweatSwimBtn.frame.width / 2
        sweatSwimBtn.layer.masksToBounds = true
        sweatSwimBtn.titleLabel?.numberOfLines = 0
        sweatSwimBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        sweatSwimBtn.titleLabel?.lineBreakMode = .byWordWrapping
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
    
    //This function is used to calculate the timer when the user leaves the app and returns to it. If the user suspends the app or switches to another one this calculation is used to notify the user when it has been completed.
    
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
                notifyTimerCompleted()
            }
        } else {
            timeLabel.text = timeString(time: TimeInterval(seconds))
        }
    }
    
    //Runs the timer, performs calcaluations from when the user first presses start until timer is completed.
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
        
        UserDefaults.standard.set(Date(), forKey: "lastTimerStartTime")
        UserDefaults.standard.set(seconds, forKey: "totalTime")
        
        addNotification()
    }
    
    //Notification that shows when timer is up.
    
    func addNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "Timer Finished"
        content.body = "Time to Reapply!"
        content.sound = .default
        var trigger: UNTimeIntervalNotificationTrigger
        trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let notification = UNNotificationRequest(identifier: "timer", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(notification)
        
        timeLabel.text = timeString(time: TimeInterval(seconds))
        
    }
    
    //Once the time is completed this updates the time label text to remind the user to apply sunscreen.
    
    func notifyTimerCompleted() {
        timeLabel.text = "Apply Suncreen!"
        
    }
    
    // This funciton updates the timer. Either it continues the timer or invalidates it when it reaches 0.
    
    @objc func updateTimer(){
        if seconds < 1 {
            timer?.invalidate()
            notifyTimerCompleted()
            
        } else {
            seconds -= 1
            timeLabel.text = timeString(time: TimeInterval(seconds))
        }
    }
    
    //This is the start button which begins the timer after the user has selected the time they want to be reminded. Includes code that invalidates time if there is one already running.
    
    @IBAction func startBtn(_ sender: UIButton) {
        
        if seconds < 1 {
            timer?.invalidate()
        } else {
            if isTimerRunning == false {
                runTimer()
            }
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, _ in
                guard success else {
                    return
                }
            }
        }
        self.plusBtn.isHidden = true
        self.minusBtn.isHidden = true
    }
    
    //This resets the timer to 0 when user presses reset button.
    
    @IBAction func resetBtn(_ sender: UIButton) {
        timer?.invalidate()
        seconds = 0
        timeLabel.text = timeString(time: TimeInterval(seconds))
        isTimerRunning = false
        self.plusBtn.isHidden = true
        self.minusBtn.isHidden = true
    }
    
    // Auto timer sets the timer to 2 hours which is the recommened time to reapply sunscreen.
    
    @IBAction func autoBtn(_ sender: UIButton) {
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
    
    // TimeString Function that calculates the hours,minutes and seconds for the timer.
    
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

