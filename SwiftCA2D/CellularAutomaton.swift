//
//  CellularAutomaton.swift
//  SwiftCA2D
//
//  Created by slightair on 2014/06/06.
//  Copyright (c) 2014年 slightair. All rights reserved.
//

import Foundation

struct Rule {
    let survive, born, numConditions: Int
}

func makeRule(_ ruleString: String) -> Rule {
    let components = ruleString.components(separatedBy: "/")

    var survive = 0
    for c in components[0] {
        survive += 1 << (Int(String(c))! - 1)
    }
    var born = 0
    for c in components[1] {
        born += 1 << (Int(String(c))! - 1)
    }
    let numConditions = Int(components[2])!

    return Rule(survive: survive, born: born, numConditions: numConditions)
}

class CellularAutomaton {
    let width, height: Int
    let rule: Rule
    var cells: [Int]

    init(width: Int, height: Int, ruleString: String) {
        self.width = width
        self.height = height
        self.rule = makeRule(ruleString)
        self.cells = Array(repeating: 0, count: width * height)

        shuffle()
    }

    func shuffle() {
        for i in 0..<self.cells.count {
            self.cells[i] = arc4random() % 16 == 0 ? self.rule.numConditions - 1 : 0
        }
    }

    func tick() {
        var nextCells = Array(repeating: 0, count: width * height)
        let condMax = self.rule.numConditions - 1

        func index(_ x: Int, _ y: Int) -> Int {
            let adjustX = (x + self.width) % self.width
            let adjustY = (y + self.height) % self.height
            return adjustY * self.width + adjustX
        }

        for y in 0..<self.height {
            for x in 0..<self.width {
                let indexes = [
                    (x - 1, y - 1), (x, y - 1), (x + 1, y - 1),
                    (x - 1, y    ),             (x + 1, y    ),
                    (x - 1, y + 1), (x, y + 1), (x + 1, y + 1),
                ]
                let count = indexes.map{ self.cells[index($0.0, $0.1)] == condMax ? 1 : 0 }.reduce(0){ $0 + $1 }
                let env = count == 0 ? 0 : 1 << (count - 1)
                let idx = index(x, y)
                let prevCond = self.cells[idx]

                if prevCond == 0 && (self.rule.born & env) > 0 {
                    nextCells[idx] = condMax
                } else if prevCond == condMax && (self.rule.survive & env) > 0 {
                    nextCells[idx] = condMax
                } else {
                    if prevCond > 0 {
                        nextCells[idx] = prevCond - 1
                    }
                }
            }
        }
        self.cells = nextCells
    }
}
