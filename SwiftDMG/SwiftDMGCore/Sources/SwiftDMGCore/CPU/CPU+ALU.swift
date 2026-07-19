//
//  CPU+ALU.swift
//  SwiftDMGCore
//
//  Created by Davi Sobreira Brasil on 18/07/26.
//


import Foundation

extension CPU {
    
    func increment8bit(value: UInt8) -> UInt8 {
        let halfCarry = (value & 0x0F) == 0x0F
        let newValue = value &+ 1
        
        registers.zeroFlag = (newValue == 0)
        registers.subtractFlag = false
        registers.halfCarryFlag = halfCarry
        
        return newValue
    }
    
    func decrement8bit(value: UInt8) -> UInt8 {
        let halfCarry = (value & 0x0F) == 0x00
        let newValue = value &- 1
        
        registers.zeroFlag = (newValue == 0)
        registers.subtractFlag = true
        registers.halfCarryFlag = halfCarry
        
        return newValue
    }
    
    func logicalOr(value: UInt8) {
        registers.a = registers.a | value
        
        registers.zeroFlag = (registers.a == 0)
        registers.subtractFlag = false
        registers.halfCarryFlag = false
        registers.carryFlag = false
    }
    
    func logicalXor(value: UInt8) {
        registers.a = registers.a ^ value
        
        registers.zeroFlag = (registers.a == 0)
        registers.subtractFlag = false
        registers.halfCarryFlag = false
        registers.carryFlag = false
    }
    func logicalAnd(value: UInt8) {
        registers.a = registers.a & value
        
        registers.zeroFlag = (registers.a == 0)
        registers.subtractFlag = false
        registers.halfCarryFlag = true // A anomalia de hardware do AND
        registers.carryFlag = false
    }
    
    func compare(value: UInt8) {
        registers.zeroFlag = (registers.a == value)
        registers.subtractFlag = true
        registers.halfCarryFlag = (registers.a & 0x0F) < (value & 0x0F)
        registers.carryFlag = (registers.a < value)
    }
    func add(value: UInt8) {
        let a = registers.a
        
        let result = Int(a) + Int(value)
    
        registers.a = UInt8(truncatingIfNeeded: result)
        
        registers.zeroFlag = (registers.a == 0)
        
        registers.subtractFlag = false
        

        registers.halfCarryFlag = (a & 0x0F) + (value & 0x0F) > 0x0F
        
        registers.carryFlag = result > 0xFF
    }
}
