//
//  CPUTests.swift
//  SwiftDMGCore
//
//  Created by Davi Sobreira Brasil on 18/07/26.
//

import XCTest
@testable import SwiftDMGCore

final class CPUTests: XCTestCase {
    var bus: MemoryBus!
    var cpu: CPU!
    
    override func setUp() {
        super.setUp()
        bus = MemoryBus()
        cpu = CPU(bus: bus)
    }
    
    func testLoadInstruction_3E() {
        bus.write(address:0xC000, value: 0x3E)
        bus.write(address:0xC001, value: 0x55)
        
        cpu.registers.pc = 0xC000
        
        cpu.registers.a = 0x00
        
        let cycles = cpu.step()
        
        XCTAssertEqual(cpu.registers.a, 0x55, "O registrador A deveria conter 0x55")
        
        XCTAssertEqual(cycles, 2, "A instrução LD A, d8 deveria gastar 2 ciclos")
        
        // Como o PC leu 2 bytes (no C000 e no C001), ele deve estar apontando para o C002 agora
        XCTAssertEqual(cpu.registers.pc, 0xC002, "O PC deveria ter avançado 2 posições")
    }
}
