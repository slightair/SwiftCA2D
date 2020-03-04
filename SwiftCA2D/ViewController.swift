//
//  ViewController.swift
//  SwiftCA2D
//
//  Created by slightair on 2014/06/05.
//  Copyright (c) 2014年 slightair. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var timer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()

        let w = Int(self.view.bounds.size.width / 8)
        let h = Int(self.view.bounds.size.height / 8)

        let caView = self.view as! CAView
        caView.automaton = CellularAutomaton(width: w, height: h, ruleString: "345/2/4")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }

    @objc func tick() {
        let caView = self.view as! CAView
        caView.automaton!.tick()
        caView.setNeedsDisplay()
    }
}
