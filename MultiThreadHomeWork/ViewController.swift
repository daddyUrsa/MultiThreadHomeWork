//
//  ViewController.swift
//  MultiThreadHomeWork
//
//  Created by Alexey Golovin on 19.02.2021.
//
/*

 Разберитесь в коде, указанном в данном примере.
 Вам нужно определить где конкретно реализованы проблемы многопоточности (Race Condition, Deadlock, Priority inversion) и укажите их. Объясните, из-за чего возникли проблемы.
 Попробуйте устранить эти проблемы.
 Готовый проект отправьте на проверку. 
 
*/

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        exampleOne()
//        exampleTwo()
//        exampleThree()
    
    }
    
    func exampleOne() {
        var storage: [String] = []
        let concurrentQueue = DispatchQueue(label: "concurrent", attributes: .concurrent)
        
        concurrentQueue.async {
            for i in 0...1000 {
                sleep(1)
                storage.append("Cell: \(i)")
            }
        }

        concurrentQueue.async {
            for i in 0...1000 {
                storage[i] = "Box: \(i)"
            }
        }
    }
    
    func exampleTwo() {
        print("a")
        DispatchQueue.main.async {
            DispatchQueue.main.sync {
                print("b")
            }
            print("c")
        }
        print("d")
    }
    
    func exampleThree() {
        let high = DispatchQueue.global(qos: .userInteractive)
        let medium = DispatchQueue.global(qos: .userInitiated)
        let low = DispatchQueue.global(qos: .background)

        let semaphore = DispatchSemaphore(value: 1)
        
        high.async {
            Thread.sleep(forTimeInterval: 2)
            semaphore.wait()
            defer { semaphore.signal() }

            print("High priority task is now running")
        }

        for i in 1 ... 10 {
            medium.async {
                let waitTime = Double(exactly: arc4random_uniform(7))!
                print("Running medium task \(i)")
                Thread.sleep(forTimeInterval: waitTime)
            }
        }

        low.async {
            semaphore.wait()
            defer { semaphore.signal() }

            print("Running long, lowest priority task")
            Thread.sleep(forTimeInterval: 5)
        }
    }

}

