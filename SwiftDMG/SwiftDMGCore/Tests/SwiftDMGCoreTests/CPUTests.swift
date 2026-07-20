//
//  CPUTests.swift
//  SwiftDMGCore
//
//  Created by Davi Sobreira Brasil on 18/07/26.
//

import XCTest
@testable import SwiftDMGCore

final class CPUTests: XCTestCase {
    var core: Core!
    
    override func setUpWithError() throws {
        core = Core()
    }
    
    override func tearDownWithError() throws {
        core = nil
    }
    
    func testBlargg01Special() throws {
        guard let url = Bundle.module.url(forResource:"01-special", withExtension: "gb") else {
            XCTFail("Não foi achado a rom")
            return
        }
        
        let data = try Data(contentsOf: url)
        
        let cartridge = Cartridge(data: [UInt8](data))
        
        core.insert(cartridge: cartridge)
        
        for _ in 0...1000 {
            core.stepFrame()
        }
    }
    
    func testBlargg03OpSpHl() throws {
        guard let url = Bundle.module.url(forResource:"03-op sp,hl", withExtension: "gb") else {
            XCTFail("Não foi achado a rom 03-op sp,hl")
            return
        }
        let data = try Data(contentsOf: url)
        
        let cartridge = Cartridge(data: [UInt8](data))
        
        core.insert(cartridge: cartridge)
        
        for _ in 0...1000 {
            core.stepFrame()
        }
    }
    func testBlargg04OpRImm() throws {
        guard let url = Bundle.module.url(forResource:"04-op r,imm", withExtension: "gb") else {
            XCTFail("Não foi achado a rom 04-op r,imm")
            return
        }
        let data = try Data(contentsOf: url)
        
        let cartridge = Cartridge(data: [UInt8](data))
        
        core.insert(cartridge: cartridge)
        
        for _ in 0...1000 {
            core.stepFrame()
        }
    }
    func testBlargg06LdRR() throws {
        guard let url = Bundle.module.url(forResource:"06-ld r,r", withExtension: "gb") else {
            XCTFail("Não foi achado a rom 06-ld r,r")
            return
        }
        let data = try Data(contentsOf: url)
        
        let cartridge = Cartridge(data: [UInt8](data))
        
        core.insert(cartridge: cartridge)
        
        for _ in 0...1000 {
            core.stepFrame()
        }
    }
}
