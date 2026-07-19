//
//  CPU+Jumps.swift
//  SwiftDMGCore
//
//  Created by Davi Sobreira Brasil on 18/07/26.
//

import Foundation

extension CPU {
    
    func jumpRelative(condition: Bool) -> Int {
        let offsetByte = fetch()
        let offset = Int8(bitPattern: offsetByte)
        
        if condition {
            let currentPC = Int(registers.pc)
            let jumpDistance = Int(offset)
            registers.pc = UInt16(truncatingIfNeeded: currentPC + jumpDistance)
            return 3
        } else {
            return 2
        }
    }
    
    func callSubroutine(condition: Bool) -> Int {
        let destinationAddress = fetch16()
        
        if condition {
            push16(value: registers.pc)
            registers.pc = destinationAddress
            return 6
        } else {
            return 3
        }
    }
    
    func returnSubroutine() -> Int {

        registers.pc = pop16()
        return 4
    }
}
