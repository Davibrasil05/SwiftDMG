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
    func addWithCarry(value: UInt8) {
        let a = registers.a
        
        let carryValue: UInt8 = registers.carryFlag ? 1 : 0
        
        let result = Int(a) + Int(value) + Int(carryValue)
        
        let finalA = UInt8(truncatingIfNeeded: result)
        registers.zeroFlag = (finalA == 0)
        
        registers.subtractFlag = false
        
        registers.halfCarryFlag = (a & 0x0F) + (value & 0x0F) + carryValue > 0x0F
        
        registers.carryFlag = result > 0xFF
        
        registers.a = finalA
    }
    func add16(value: UInt16) {
        let hl = registers.hl
        
        let result = Int(hl) + Int(value)
        
        registers.subtractFlag = false
        
        registers.halfCarryFlag = (hl & 0x0FFF) + (value & 0x0FFF) > 0x0FFF
        
        registers.carryFlag = result > 0xFFFF
        
        registers.hl = UInt16(truncatingIfNeeded: result)
    }
    func subtract(value: UInt8) {
        let a = registers.a
        
        registers.zeroFlag = (a == value)
        
        registers.subtractFlag = true
        
        registers.halfCarryFlag = (a & 0x0F) < (value & 0x0F)
        
        registers.carryFlag = (a < value)
        
        registers.a = a &- value
    }
    func subtractWithCarry(value: UInt8) {
            let a = registers.a
            let carryValue: UInt8 = registers.carryFlag ? 1 : 0
            
            let result = Int(a) - Int(value) - Int(carryValue)
            
            registers.zeroFlag = (UInt8(truncatingIfNeeded: result) == 0)
            registers.subtractFlag = true
            
            let halfCarryResult = Int(a & 0x0F) - Int(value & 0x0F) - Int(carryValue)
            registers.halfCarryFlag = halfCarryResult < 0
            
            registers.carryFlag = result < 0
            
            registers.a = UInt8(truncatingIfNeeded: result)
        }
    func shiftRightLogical(value: UInt8) -> UInt8 {
        
        let bitQueCaiu = (value & 0x01) == 0x01
        
        let newValue = value >> 1
        
        registers.zeroFlag = (newValue == 0)
        registers.subtractFlag = false
        registers.halfCarryFlag = false
        registers.carryFlag = bitQueCaiu
        
        return newValue
    }
    func rotateRightThroughCarry(value: UInt8) -> UInt8 {
        
        let bitQueVaiSair = (value & 0x01) == 0x01
        
        let bitQueVaiEntrar: UInt8 = registers.carryFlag ? 1 : 0
        
        let newValue = (value >> 1) | (bitQueVaiEntrar << 7)
        
        registers.zeroFlag = (newValue == 0)
        registers.subtractFlag = false
        registers.halfCarryFlag = false
        
        registers.carryFlag = bitQueVaiSair
        
        return newValue
    }
    func decimalAdjustAccumulator() {
        
        var a = Int(registers.a)
        
        if !registers.subtractFlag {
            
            if registers.halfCarryFlag || (a & 0x0F) > 0x09 {
                a += 0x06
            }
            if registers.carryFlag || a > 0x9F {
                a += 0x60
                registers.carryFlag = true
            }
        } else {
            
            if registers.halfCarryFlag {
                a = (a - 0x06) & 0xFF
            }
            if registers.carryFlag {
                a -= 0x60
            }
        }
        
        registers.halfCarryFlag = false
        
        registers.a = UInt8(a & 0xFF)
        registers.zeroFlag = (registers.a == 0)
    }
    func complementAccumulator() {
        registers.a = ~registers.a
        
        registers.subtractFlag = true
        registers.halfCarryFlag = true
    }
    func swapNibbles(value: UInt8) -> UInt8 {
        
        let newValue = (value >> 4) | (value << 4)
        
        registers.zeroFlag = (newValue == 0)
        registers.subtractFlag = false
        registers.halfCarryFlag = false
        registers.carryFlag = false
        
        return newValue
    }
}
