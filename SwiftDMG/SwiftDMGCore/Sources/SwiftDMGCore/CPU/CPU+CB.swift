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
        case 0x18:
            // RR B
            registers.b = rotateRightThroughCarry(value: registers.b)
            return 2
        case 0x19:
            registers.c = rotateRightThroughCarry(value: registers.c)
            return 2
        case 0x1A:
            registers.d = rotateRightThroughCarry(value: registers.d)
            return 2
            
        case 0x1B:
            // RR E
            registers.e = rotateRightThroughCarry(value: registers.e)
            return 2
            
        case 0x1C:
            // RR H
            registers.h = rotateRightThroughCarry(value: registers.h)
            return 2
        case 0x1D:
            // RR L
            registers.l = rotateRightThroughCarry(value: registers.l)
            return 2
        case 0x37:
            // SWAP A
            registers.a = swapNibbles(value: registers.a)
            return 2
        case 0x38:
            registers.b = shiftRightLogical(value: registers.b)
            return 2
        default:
            fatalError("Opcode CB não implementado: 0xCB \(String(format: "0x%02X", opcode))")
        }
    }
}
