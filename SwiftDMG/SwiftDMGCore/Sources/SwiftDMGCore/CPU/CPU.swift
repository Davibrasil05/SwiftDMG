//
//  CPU.swift
//  SwiftDMGCore
//
//  Created by Davi Sobreira Brasil on 16/07/26.
//

import Foundation

public class CPU {
    public var registers = Registers()
    
    public var ime: Bool = false
    
    let bus: Addressable
    
    public init(bus: Addressable){
        self.bus = bus
        reset()
    }
    
    public func step() -> Int{
        let opcode = fetch()
        
        let cycles = execute(opcode: opcode)
        
        return cycles
    }
    
    func fetch() -> UInt8 {
        let byte = bus.read(address: registers.pc)
        registers.pc &+= 1 //operador overflow
        return byte
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
