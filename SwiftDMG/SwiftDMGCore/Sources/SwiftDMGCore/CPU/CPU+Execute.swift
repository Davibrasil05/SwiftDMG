//
//  CPU+Execute.swift
//  SwiftDMGCore
//
//  Created by Davi Sobreira Brasil on 18/07/26.
//

import Foundation

extension CPU {
    func execute(opcode: UInt8) -> Int{
        switch opcode {
        case 0x00:
            return 1
            
        case 0x01:
            // LD BC,u16 - 0x01
            
            registers.bc = fetch16()
            return 3
            
        case 0x03:
            //INC BC
            registers.bc &+= 1
            
            return 2
            
        case 0x05:
            // DEC B
            registers.b = decrement8bit(value: registers.b)
            return 1
            
        case 0x06:
            // LD B,u8
            let value = fetch()
            registers.b = value
            
            return 2
        case 0x0D:
            // DEC C
            registers.c = decrement8bit(value: registers.c)
            return 1
        case 0x0E:
            // LD C, u8
            let value = fetch()
            registers.c = value
            
            return 2
            
        case 0x11:
            // LD DE, u16
            
            registers.de = fetch16()
            return 3
            
        case 0x12:
            // LD (DE), A
            bus.write(address: registers.de, value: registers.a)
            
            return 2
            
        case 0x13:
            // INC DE
            registers.de &+= 1
            return 2
            
        case 0x14:
            //INC D
            registers.d = increment8bit(value: registers.d)
            return 1
            
        case 0x18:
            // JR i8
            return jumpRelative(condition: true)
            
        case 0x1A:
            // LD A,(DE)
            
            registers.a = bus.read(address: registers.de)
            
            return 2
        case 0x1C:
            // INC E
            
            registers.e = increment8bit(value: registers.e)
            return 1
            
        case 0x20:
            // JR NZ, i8 (Jump Relative if Not Zero)
            return jumpRelative(condition: !registers.zeroFlag)
        case 0x21:
            let lowByte = UInt16(fetch())
            let highByte = UInt16(fetch())
            
            registers.hl = (highByte << 8) | lowByte
            
            return 3
            
        case 0x22:
            // LD (HL+), A
       
            bus.write(address: registers.hl, value: registers.a)
            
            registers.hl &+= 1
            
            return 2
            
        case 0x31:
            // LD SP, u16
            
            registers.sp = fetch16()
            return 3
        case 0x47:
            // LD B, A
            registers.b = registers.a
            
            return 1
            
        case 0x23:
            // INC HL
            registers.hl &+= 1
            
            return 2
            
        case 0x24:
            // INC H
            
            registers.h = increment8bit(value: registers.h)
            return 1
        case 0x28:
            // JR Z, i8
            return jumpRelative(condition: registers.zeroFlag)
        case 0x2A:
            // LD A,(HL+)
            
            //valor da memoria aonde o hl aponta
            let value = bus.read(address: registers.hl)
            
            registers.a = value
            
            registers.hl &+= 1
            
            return 2
            
        case 0x2C:
            // INC L - 0x2C
            registers.l = increment8bit(value: registers.l)
            return 1
        case 0x2E:
            // LD L, u8
            let value = fetch()
            registers.l = value
            
            return 2
        case 0x3E:
            // LD A, d8
            
            let value = fetch()
            registers.a = value
            
            return 2
            
        case 0x77:
            //LD (HL), A
            bus.write(address: registers.hl, value: registers.a)
            return 2
        case 0x78:
            //LD A, B
            registers.a = registers.b
            return 1
            
        case 0x7C:
            // LD A, H
            registers.a = registers.h
            return 1
        case 0x7D:
            // LD A, L
            registers.a = registers.l
            return 1
            
        case 0xA9:
            // XOR A,C
            logicalXor(value: registers.c)
            return 1
        case 0xB1:
            // OR A, C
            logicalOr(value: registers.c)
            return 1
        case 0xC1:
            // POP BC
            registers.bc = pop16()
            return 3
        case 0xC3:
            // JP a16
            registers.pc = fetch16()
            return 4
            
        case 0xC4:
            // CALL NZ, a16
            return callSubroutine(condition: !registers.zeroFlag)
            
        case 0xC5:
            push16(value: registers.bc)
            return 4
            
        case 0xC6:
            // ADD A,u8 
            
            
        case 0xC9:
            // RET (Return da Sub-rotina)
            return returnSubroutine()
            
        case 0xCD:
            // CALL a16
            return callSubroutine(condition: true)
            
        case 0xE0:
            // LD (0xFF00 + u8), A)
            
            let offset = UInt16(fetch())
            
            let hardwareAddress = 0xFF00 + offset
            
            bus.write(address: hardwareAddress, value: registers.a)
            
            return 3
        case 0xE1:
            // POP HL
            registers.hl = pop16()
            return 3
        case 0xE5:
            // PUSH HL
            push16(value: registers.hl)
            return 4
        case 0xE6:
            // AND A, d8
            let value = fetch()
            logicalAnd(value: value)
            return 2
        case 0xEA:
            // LD (u16),A
            
            let destinationAddress = fetch16()
            bus.write(address: destinationAddress, value: registers.a)
            return 4
            
        case 0xF0:
            // LD A,(FF00+u8)
            let offset = UInt16(fetch())
            
            let hardwareAddress = 0xFF00 + offset
            
            registers.a = bus.read(address: hardwareAddress)
            
            return 3
        case 0xF1:
            // POP AF
            registers.af = pop16()
            return 3
        case 0xF3:
            // DI Disable Interrupts
            ime = false
            
            return 1
            
        case 0xF5:
            // PUSH AF
            push16(value: registers.af)
            return 4
        case 0xFA:
            // LD A, (u16)
            let targetAddress = fetch16()
            registers.a = bus.read(address: targetAddress)
            return 4
            
            
        case 0xFE:
            // CP A, d8
            let value = fetch()
            compare(value: value)
            return 2
            
        case 0xAF:
            registers.a ^= registers.a
            
            registers.zeroFlag = (registers.a == 0)
            registers.subtractFlag = false
            registers.halfCarryFlag = false
            registers.carryFlag = false
            
            return 1
        default:
            fatalError("Opcode \(String(format: "0x%02X", opcode)) não implementado ainda!")
        }
    }
}
