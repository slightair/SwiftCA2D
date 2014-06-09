//
//  CAView.swift
//  SwiftCA2D
//
//  Created by slightair on 2014/06/05.
//  Copyright (c) 2014年 slightair. All rights reserved.
//

import UIKit

class CAView : UIView {
    let tileSize: CGFloat = 8.0
    var automaton: CellularAutomaton?

    override func drawRect(rect : CGRect?) {
        let ctx  = UIGraphicsGetCurrentContext()
        let colorSpace = CGColorSpaceCreateDeviceCMYK()
        let horizontalTiles = self.bounds.size.width / tileSize
        let verticalTiles = self.bounds.size.height / tileSize
        let numConditions = automaton!.rule.numConditions
        let cells = automaton!.cells

        for y in 0..verticalTiles {
            for x in 0..horizontalTiles {
                let condition = cells[Int(y * horizontalTiles + x)]
                let magenta = 1.0 - (1.0 / CGFloat(numConditions - 1) * CGFloat(condition))
                let components: CGFloat[] = condition == 0 ? [0.0, 0.0, 0.0, 1.0, 1.0] : [0.0, magenta, 1.0, 0.0, 1.0]
                let color = CGColorCreate(colorSpace, components)

                CGContextSetFillColorWithColor(ctx, color)
                CGContextFillRect(ctx, CGRect(x: x * tileSize, y: y * tileSize, width: tileSize, height: tileSize))
            }
        }
    }
}