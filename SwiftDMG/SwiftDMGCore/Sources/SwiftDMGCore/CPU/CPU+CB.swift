//
//  CPU+CB.swift
//  SwiftDMGCore
//
//  Created by Davi Sobreira Brasil on 19/07/26.
//

import Foundation

extension CPU {
    
    func executeCB(opcode: UInt8) -> Int {
        switch opcode {
        case 0x19:
            registers.c = rotateRightThroughCarry(value: registers.c)
            return 2
        case 0x1A:
            registers.d = rotateRightThroughCarry(value: registers.d)
            return 2
        case 0x38:
            registers.b = shiftRightLogical(value: registers.b)
            return 2
        default:
            fatalError("Opcode CB não implementado: 0xCB \(String(format: "0x%02X", opcode))")
        }
    }
}
