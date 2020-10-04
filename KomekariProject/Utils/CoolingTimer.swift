//
//  CoolingTimer.swift
//  KomekariProject
//
//  Created by 酒井専冴 on 2020/10/02.
//

import Foundation

class CoolingFunction: Timer {
    
    var timer = Timer()
    var counter = 0
    var hasCooled: Bool {
        return counter > 30 ? true: false
    }
    func start() {
        if counter > 30 { return }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(increment), userInfo: nil, repeats: true)
    }
    func resetTimer() {
        timer.invalidate()
        self.counter = 0
    }
    func stop() {
        timer.invalidate()
    }
    
    @objc func increment() {
        self.counter += 1
        if counter > 30 {
            timer.invalidate()
            counter = 0
        }
    }
    deinit {
        print("CoolingTimer Deinit")
    }
    
}
