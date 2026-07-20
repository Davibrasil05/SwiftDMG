//
//  Core.swift
//  SwiftDMGCore
//
//  Created by Davi Sobreira Brasil on 16/07/26.
//

import Foundation

public class Core {
    public let bus: MemoryBus
    public let cpu: CPU
    
    public var isCartridgeLoaded: Bool {
        return bus.cartridge != nil
    }
    
    public init() {
        self.bus = MemoryBus()
        self.cpu = CPU(bus:bus)
    }
    
    public func insert(cartridge: Cartridge){
        bus.cartridge = cartridge
        
        cpu.registers.pc = 0x0100
    }
    
    public func stepFrame(){
        var cyclesThisFrame = 0
        let maxCyclesPerFrame = 17556
        
        while cyclesThisFrame < maxCyclesPerFrame {
            let cyclesSpent = cpu.step()
            cyclesThisFrame += cyclesSpent
        }
        
        //ppu.step(cycles: cyclesSpent)
    }
}
