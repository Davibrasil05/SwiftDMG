//
//  Cartridge.swift
//  SwiftDMGCore
//
//  Created by Davi Sobreira Brasil on 16/07/26.
//

import Foundation

public class Cartridge {
    private let rom: [UInt8]
    
    public let title: String
    public let cartridgeType: UInt8
    
    public init(data: [UInt8]){
        self.rom = data
        
        let titleBytes = data[0x0134...0x0143]
        let validBytes = titleBytes.filter {$0 != 0}
        self.title = String(bytes: validBytes, encoding: .ascii) ?? "Unknown"
        
        self.cartridgeType = data[0x0147]
        
        print("Cartucho Inserido: \(title) (Tipo: \(String(format: "0x%02X", cartridgeType)))")
        
    }
    
    public func read(address: UInt16) -> UInt8 {
        let addr = Int(address)
        if addr < rom.count {
            return rom[addr]
        }
        return 0xFF
    }
}
