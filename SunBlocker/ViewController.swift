//
//  ViewController.swift
//  SunBlocker
//
//  Created by Ricardo Fernandez on 9/12/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var timeLabel: UILabel!
    
    var seconds = 0
    var timer = Timer()
    var isTimerRunning = false
    
    @IBAction func startBtn(_ sender: UIButton) {
        if isTimerRunning == false {
            runTimer()
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
    }
    
    @objc func updateTimer(){
        if seconds < 1 {
            timer.invalidate()
            // Send alert to indicate "Reapply!"
        } else {
            seconds -= 1
            timeLabel.text = timeString(time: TimeInterval(seconds))
        }
        
    }
    
    @IBAction func resetBtn(_ sender: UIButton) {
        timer.invalidate()
        seconds = 0
        timeLabel.text = timeString(time: TimeInterval(seconds))
        
        isTimerRunning = false
        
    }
    
    @IBAction func autoTimer(_ sender: UIButton) {
        timer.invalidate()
        seconds = 7200
        timeLabel.text = timeString(time: TimeInterval(seconds))
        
        isTimerRunning = false
        
    }

    @IBAction func sweatSwimTimer(_ sender: UIButton) {
        timer.invalidate()
        seconds = 2700
        timeLabel.text = timeString(time: TimeInterval(seconds))
        
        isTimerRunning = false
        
    }
    
    @IBAction func manualBtn(_ sender: UIButton) {
    
        
    }
    
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    // TimeString Function
    
 
        
        
    }

