//
//  CPU+Loads.swift
//  SwiftDMGCore
//
//  Created by Davi Sobreira Brasil on 18/07/26.
//

import Foundation

extension CPU {
    
    func push16(value: UInt16) {
        let highByte = UInt8(value >> 8)
        let lowByte = UInt8(value & 0x00FF)
        
        registers.sp &-= 1
        bus.write(address: registers.sp, value: highByte)
        
        registers.sp &-= 1
        bus.write(address: registers.sp, value: lowByte)
    }
    
    func pop16() -> UInt16 {
        let lowByte = UInt16(bus.read(address: registers.sp))
        registers.sp &+= 1
        
        let highByte = UInt16(bus.read(address: registers.sp))
        registers.sp &+= 1
        
        return (highByte << 8) | lowByte
    }
    
    func fetch16() -> UInt16 {
        let lowByte = UInt16(fetch())
        let highByte = UInt16(fetch())
        return (highByte << 8) | lowByte
    }
}
