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
            
        case 0x04:
            // INC B
            registers.b = increment8bit(value: registers.b)
            return 1
        case 0x05:
            // DEC B
            registers.b = decrement8bit(value: registers.b)
            return 1
            
        case 0x06:
            // LD B,u8
            let value = fetch()
            registers.b = value
            
            return 2
            
        case 0x08:
            // LD (u16), SP
            let address = fetch16()
            
            let lowByte = UInt8(registers.sp & 0x00FF)
            let highByte = UInt8(registers.sp >> 8)
            
            bus.write(address: address, value: lowByte)
            bus.write(address: address &+ 1, value: highByte)
            
            return 5
            
        case 0x0C:
            // INC C
            registers.c = increment8bit(value: registers.c)
            return 1
            
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
            
        case 0x16:
            // LD D,u8
            registers.d = fetch()
            return 2
            
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
            
        case 0x1D:
            // DEC E
            registers.e = decrement8bit(value: registers.e)
            return 1
            
        case 0x1E:
            registers.e = fetch()
            return 2
            
        case 0x1F:
            // RRA (Rotate Right A Through Carry - Fast)
            
            registers.a = rotateRightThroughCarry(value: registers.a)
            
            registers.zeroFlag = false
            
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
            
        case 0x25:
            // DEC H
            registers.h = decrement8bit(value: registers.h)
            return 1
        case 0x26:
            // LD H,u8
            let value = fetch()
            registers.h = value
            
            return 2
            
        case 0x27:
            // DAA
            decimalAdjustAccumulator()
            return 1
            
        case 0x31:
            // LD SP, u16
            
            registers.sp = fetch16()
            return 3
            
        case 0x33:
            // INC SP
            registers.sp &+= 1
            return 2
            
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
            
        case 0x29:
            // ADD HL, HL
            add16(value: registers.hl)
            return 2 // Essa instrução gasta 2 ciclos!
            
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
            
        case 0x2D:
            // DEC L
            registers.l = decrement8bit(value: registers.l)
            return 1
        case 0x2E:
            // LD L, u8
            let value = fetch()
            registers.l = value
            
            return 2
            
        case 0x2F:
            //CPL
            complementAccumulator()
            return 1
            
        case 0x30:
            // JR NC,i8
            return jumpRelative(condition: !registers.carryFlag)
            
        case 0x32:
            // LD (HL-),A - 0x32
            
            bus.write(address: registers.hl, value: registers.a)
            
            registers.hl &-= 1
            
            return 2
            
        case 0x35:
            // DEC (HL)
            let originalValue = bus.read(address: registers.hl)
            
            let newValue = decrement8bit(value: originalValue)
            
            
            bus.write(address: registers.hl, value: newValue)
            
            
            return 3
            
        case 0x36:
            // LD (HL),u8
            let value = fetch()
            bus.write(address: registers.hl, value: value)
            
            return 2
            
        case 0x38:
            // JR C,i8
            return jumpRelative(condition: registers.carryFlag)
            
        case 0x39:
            // ADD HL,SP
            add16(value: registers.sp)
            return 2
            
        case 0x3B:
            // DEC SP
            registers.sp &-= 1
            return 2
            
        case 0x3C:
            // INC A
            registers.a = increment8bit(value: registers.a)
            return 1
            
        case 0x3D:
            // DEC A
            registers.a = decrement8bit(value: registers.a)
            return 1
        case 0x3E:
            // LD A, d8
            let value = fetch()
            registers.a = value
            
            return 2
            
            // --- LD B, r ---
        case 0x40: registers.b = registers.b; return 1
        case 0x41: registers.b = registers.c; return 1
        case 0x42: registers.b = registers.d; return 1
        case 0x43: registers.b = registers.e; return 1
        case 0x44: registers.b = registers.h; return 1
        case 0x45: registers.b = registers.l; return 1
        case 0x46: registers.b = bus.read(address: registers.hl); return 2
        case 0x47: registers.b = registers.a; return 1
            
            // --- LD C, r ---
        case 0x48: registers.c = registers.b; return 1
        case 0x49: registers.c = registers.c; return 1
        case 0x4A: registers.c = registers.d; return 1
        case 0x4B: registers.c = registers.e; return 1
        case 0x4C: registers.c = registers.h; return 1
        case 0x4D: registers.c = registers.l; return 1
        case 0x4E: registers.c = bus.read(address: registers.hl); return 2
        case 0x4F: registers.c = registers.a; return 1
            
            // --- LD D, r ---
        case 0x50: registers.d = registers.b; return 1
        case 0x51: registers.d = registers.c; return 1
        case 0x52: registers.d = registers.d; return 1
        case 0x53: registers.d = registers.e; return 1
        case 0x54: registers.d = registers.h; return 1
        case 0x55: registers.d = registers.l; return 1
        case 0x56: registers.d = bus.read(address: registers.hl); return 2
        case 0x57: registers.d = registers.a; return 1
            
            // --- LD E, r ---
        case 0x58: registers.e = registers.b; return 1
        case 0x59: registers.e = registers.c; return 1
        case 0x5A: registers.e = registers.d; return 1
        case 0x5B: registers.e = registers.e; return 1
        case 0x5C: registers.e = registers.h; return 1
        case 0x5D: registers.e = registers.l; return 1
        case 0x5E: registers.e = bus.read(address: registers.hl); return 2
        case 0x5F: registers.e = registers.a; return 1
            
            // --- LD H, r ---
        case 0x60: registers.h = registers.b; return 1
        case 0x61: registers.h = registers.c; return 1
        case 0x62: registers.h = registers.d; return 1
        case 0x63: registers.h = registers.e; return 1
        case 0x64: registers.h = registers.h; return 1
        case 0x65: registers.h = registers.l; return 1
        case 0x66: registers.h = bus.read(address: registers.hl); return 2
        case 0x67: registers.h = registers.a; return 1
            
            // --- LD L, r ---
        case 0x68: registers.l = registers.b; return 1
        case 0x69: registers.l = registers.c; return 1
        case 0x6A: registers.l = registers.d; return 1
        case 0x6B: registers.l = registers.e; return 1
        case 0x6C: registers.l = registers.h; return 1
        case 0x6D: registers.l = registers.l; return 1
        case 0x6E: registers.l = bus.read(address: registers.hl); return 2
        case 0x6F: registers.l = registers.a; return 1
            
            // --- LD (HL), r ---
        case 0x70: bus.write(address: registers.hl, value: registers.b); return 2
        case 0x71: bus.write(address: registers.hl, value: registers.c); return 2
        case 0x72: bus.write(address: registers.hl, value: registers.d); return 2
        case 0x73: bus.write(address: registers.hl, value: registers.e); return 2
        case 0x74: bus.write(address: registers.hl, value: registers.h); return 2
        case 0x75: bus.write(address: registers.hl, value: registers.l); return 2
        case 0x76: fatalError("HALT não implementado ainda! (0x76)") // Única exceção da tabela!
        case 0x77: bus.write(address: registers.hl, value: registers.a); return 2
            
            // --- LD A, r ---
        case 0x78: registers.a = registers.b; return 1
        case 0x79: registers.a = registers.c; return 1
        case 0x7A: registers.a = registers.d; return 1
        case 0x7B: registers.a = registers.e; return 1
        case 0x7C: registers.a = registers.h; return 1
        case 0x7D: registers.a = registers.l; return 1
        case 0x7E: registers.a = bus.read(address: registers.hl); return 2
        case 0x7F: registers.a = registers.a; return 1
            
        case 0x97:
            // SUB A, A
            subtract(value: registers.a)
            return 1
        case 0x9F:
            // SBC A, A
            subtractWithCarry(value: registers.a)
            return 1
            
        case 0xA9:
            // XOR A,C
            logicalXor(value: registers.c)
            return 1
            
        case 0xAD:
            // XOR A,L
            logicalXor(value: registers.l)
            return 1
            
        case 0xAE:
            // XOR A,(HL)
            let value = bus.read(address: registers.hl)
            logicalXor(value: value)
            return 2
            
        case 0xAF:
            // XOR A,A - 0xAF
            logicalXor(value: registers.a)
            return 1
            
        case 0xBA:
            // CP A,D
            compare(value: registers.d)
            return 1
            
        case 0xB0:
            // OR A,B
            logicalOr(value: registers.b)
            return 1
            
        case 0xB1:
            // OR A, C
            logicalOr(value: registers.c)
            return 1
            
        case 0xB6:
            // OR A,(HL)
            let value = bus.read(address: registers.hl)
            logicalOr(value: value)
            return 2
        case 0xB7:
            // OR A,A
            logicalOr(value: registers.a)
            return 1
            
        case 0xB9:
            // CP A,C
            compare(value: registers.c)
            return 1
            
        case 0xB8:
            // CP A,B
            compare(value: registers.b)
            return 1
            
        case 0xBB:
            // CP A,E
            compare(value: registers.e)
            return 1
            
        case 0xC1:
            // POP BC
            registers.bc = pop16()
            return 3
            
        case 0xC2:
            // JP NZ,u16
            return jumpAbsolute(condition: !registers.zeroFlag)
        case 0xC3:
            // JP a16
            return jumpAbsolute(condition: true)
            
        case 0xC4:
            // CALL NZ, a16
            return callSubroutine(condition: !registers.zeroFlag)
            
        case 0xC5:
            push16(value: registers.bc)
            return 4
            
        case 0xC6:
            // ADD A, d8
            let value = fetch()
            add(value: value)
            return 2
            
            
        case 0xC8:
            // RET Z
            _ = returnSubroutine(condition: registers.zeroFlag)
            return 4
        case 0xC9:
            // RET (Return da Sub-rotina)
            _ = returnSubroutine(condition: true)
            return 4
            
            
        case 0xCB:
            // PREFIX CB
            let cbOpcode = fetch()
            
            return executeCB(opcode: cbOpcode)
        case 0xCD:
            // CALL a16
            return callSubroutine(condition: true)
            
        case 0xCE:
            // ADC A, d8 (Add with Carry puxando da memória)
            let value = fetch()
            addWithCarry(value: value)
            return 2
            
        case 0xD0:
            // RET NC
            return returnSubroutine(condition: !registers.carryFlag)
        case 0xD1:
            // POP DE
            registers.de = pop16()
            
            return 3
        case 0xD5:
            // PUSH DE
            push16(value: registers.de)
            return 4
            
        case 0xD6:
            // SUB A,u8
            
            let value = fetch()
            subtract(value: value)
            
            return 2
            
        case 0xD8:
            // RET C
            return returnSubroutine(condition: registers.carryFlag)
            
        case 0xDE:
            // SBC A, d8
            let value = fetch()
            subtractWithCarry(value: value)
            return 2
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
            
        case 0xE8:
            // ADD SP, i8
            let unsignedValue = fetch()
            let offset = Int8(bitPattern: unsignedValue)
            
            registers.zeroFlag = false
            registers.subtractFlag = false
            
            registers.halfCarryFlag = (registers.sp & 0x000F) + UInt16(unsignedValue & 0x0F) > 0x000F
            registers.carryFlag = (registers.sp & 0x00FF) + UInt16(unsignedValue) > 0x00FF
            
            registers.sp = UInt16(truncatingIfNeeded: Int32(registers.sp) + Int32(offset))
            
            return 4
        case 0xE9:
            // JP HL
            registers.pc = registers.hl
            return 1
            
        case 0xEA:
            // LD (u16),A
            let destinationAddress = fetch16()
            bus.write(address: destinationAddress, value: registers.a)
            return 4
            
            
        case 0xEE:
            // XOR A,u8
            let value = fetch()
            logicalXor(value: value)
            return 2
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
            
        case 0xF6:
            // OR A,u8
            let value = fetch()
            logicalOr(value: value)
            return 2
            
        case 0xF8:
            // LD HL, SP+i8
            let unsignedValue = fetch()
            let offset = Int8(bitPattern: unsignedValue)
            
            
            registers.zeroFlag = false
            registers.subtractFlag = false
            registers.halfCarryFlag = (registers.sp & 0x000F) + UInt16(unsignedValue & 0x0F) > 0x000F
            registers.carryFlag = (registers.sp & 0x00FF) + UInt16(unsignedValue) > 0x00FF
            
            
            registers.hl = UInt16(truncatingIfNeeded: Int32(registers.sp) + Int32(offset))
            
            return 3
        case 0xF9:
            // LD SP,HL
            registers.sp = registers.hl
            return 2
            
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
            
        default:
            fatalError("Opcode \(String(format: "0x%02X", opcode)) não implementado ainda!")
        }
    }
}
