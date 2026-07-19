//
//  Registers.swift
//  SwiftDMGCore
//
//  Created by Davi Sobreira Brasil on 16/07/26.
//

import Foundation

public struct Registers {
    //hi-lo
    public var a: UInt8 = 0
    public var f: UInt8 = 0
    
    public var b: UInt8 = 0
    public var c: UInt8 = 0
    
    public var d: UInt8 = 0
    public var e: UInt8 = 0
    
    public var h: UInt8 = 0
    public var l: UInt8 = 0
    
    //registradores 16bit nativo
    
    public var sp: UInt16 = 0xFFFE //stack pointer
    public var pc: UInt16 = 0x0100  //program counter
    
    
    public init(){}
    
    //bit 7: Z
    public var zeroFlag: Bool {
        get { return (f & 0b1000_0000) != 0 }
        set {
            if newValue { f |= 0b1000_0000}
            else { f &= 0b0111_1111 }
        }
    }
    //bit 6: N
    public var subtractFlag: Bool {
        get { return (f & 0b0100_0000) != 0}
        set {
            if newValue { f |= 0b0100_0000}
            else { f &= 0b1011_1111}
        }
    }
    
    //bit 5: H
    
    public var halfCarryFlag: Bool {
        get { return (f & 0b0010_0000) != 0}
        set {
            if newValue { f |= 0b0010_0000 }
            else { f &= 0b1101_1111}
        }
    }
    
    public var carryFlag: Bool {
        get { return (f & 0b0001_0000) != 0}
        set {
            if newValue { f |= 0b0001_0000}
            else { f &= 0b1110_1111}
        }
    }
    
    public var af: UInt16 {
        get { return (UInt16(a) << 8) | UInt16(f) }
        set {
            a = UInt8(newValue >> 8)
            f = UInt8(truncatingIfNeeded: newValue) & 0xF0
        }
    }
    
    public var bc: UInt16 {
        get { return (UInt16(b) << 8) | UInt16(c) }
        set {
            b = UInt8(newValue >> 8)
            c = UInt8(truncatingIfNeeded: newValue)
        }
    }
    
    public var de: UInt16 {
        get { return (UInt16(d) << 8) | UInt16(e) }
        set {
            d = UInt8(newValue >> 8)
            e = UInt8(truncatingIfNeeded: newValue)
        }
    }
    
    public var hl: UInt16 {
        get { return (UInt16(h) << 8) | UInt16(l) }
        set {
            h = UInt8(newValue >> 8)
            l = UInt8(truncatingIfNeeded: newValue)
        }
    }
}
