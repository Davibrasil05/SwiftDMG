//
//  CPU.swift
//  SwiftDMGCore
//
//  Created by Davi Sobreira Brasil on 16/07/26.
//

import Foundation

public class CPU {
    public var registers = Registers()
    
    private let bus: Addressable
    
    public init(bus: Addressable){
        self.bus = bus
        reset()
    }
    
    public func step() -> Int{
        let opcode = fetch()
        
        let cycles = execute(opcode: opcode)
        
        return cycles
    }
    
    private func fetch() -> UInt8 {
        let byte = bus.read(address: registers.pc)
        registers.pc &+= 1 //operador overflow
        return byte
    }
    
    private func execute(opcode: UInt8) -> Int {
        switch opcode {
        case 0x00:
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
    private func reset() {
        // Os valores padrão do emulador ao iniciar o jogo
        registers.af = 0x01B0
        registers.bc = 0x0013
        registers.de = 0x00D8
        registers.hl = 0x014D
        registers.sp = 0xFFFE
        registers.pc = 0x0100
    }
}
