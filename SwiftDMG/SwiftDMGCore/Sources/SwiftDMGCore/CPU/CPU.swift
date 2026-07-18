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
