//
//  ZorroSignApp.swift
//  ZorroSign
//
//  Created by Apple on 04/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ZorroSignApp: UIApplication {

    private var timeoutInSeconds: TimeInterval {
        return 50 * 60 
    }
    
    private var timer: Timer?
    
    private func resetTimer() {
        if let timer = timer {
            timer.invalidate()
        }
        
        timer = Timer.scheduledTimer(timeInterval: timeoutInSeconds,
                                     target: self,
                                     selector: #selector(ZorroSignApp.timeHasExceeded),
                                     userInfo: nil,
                                     repeats: false)
    }
    
    @objc private func timeHasExceeded() {
        NotificationCenter.default.post(name: .appTimeout,
                                        object: nil
        )
    }
    
    override func sendEvent(_ event: UIEvent) {
        
        super.sendEvent(event)
        
        if timer != nil {
            self.resetTimer()
        }
        
        if let touches = event.allTouches {
            
            for touch in touches where touch.phase == UITouch.Phase.began {
                self.resetTimer()
            }
        }
    }
}
