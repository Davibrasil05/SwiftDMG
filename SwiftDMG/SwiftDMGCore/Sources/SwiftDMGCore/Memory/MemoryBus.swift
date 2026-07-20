//
//  MemoryBus.swift
//  SwiftDMGCore
//
//  Created by Davi Sobreira Brasil on 16/07/26.
//

import Foundation

public class MemoryBus: Addressable{
    
    public var cartridge: Cartridge?
    
    private var wram = [UInt8](repeating: 0, count: 8192) //array de 8 bits para a memória de workram
    
    private var hram = [UInt8](repeating: 0, count:127)
    
    private var interruptEnable: UInt8 = 0
    
    public var vram = [UInt8](repeating: 0, count: 8192) // 0x8000 - 0x9FFF
    
    public var oam  = [UInt8](repeating: 0, count: 160)  // 0xFE00 - 0xFE9F
    
    // --- Registradores da PPU ---
    public var lcdc: UInt8 = 0x91 // 0xFF40 - LCD Control
    public var stat: UInt8 = 0x85 // 0xFF41 - LCD Status
    public var scy:  UInt8 = 0x00 // 0xFF42 - Scroll Y
    public var scx:  UInt8 = 0x00 // 0xFF43 - Scroll X
    public var ly:   UInt8 = 0x00 // 0xFF44 - Current Y Line (Somente Leitura)
    public var lyc:  UInt8 = 0x00 // 0xFF45 - Y Compare
    public var dma:  UInt8 = 0xFF // 0xFF46 - DMA Transfer
    public var bgp:  UInt8 = 0xFC // 0xFF47 - Background Palette
    public var obp0: UInt8 = 0xFF // 0xFF48 - Object Palette 0
    public var obp1: UInt8 = 0xFF // 0xFF49 - Object Palette 1
    public var wy:   UInt8 = 0x00 // 0xFF4A - Window Y
    public var wx:   UInt8 = 0x00 // 0xFF4B - Window X
    
    
    public init(){}
    
    public func read(address: UInt16) -> UInt8 {
        switch address {
        case 0x0000...0x7FFF:
            //rom do cartucho
            return cartridge?.read(address: address) ?? 0xFF
            
        case 0x8000...0x9FFF:
            //Vram
            return vram[Int(address - 0x8000)]
            
            
        case 0xA000...0xBFFF:
            //External ram (save do cartucho)
            return 0xFF
            
        case 0xC000...0xDFFF:
            //lendo wram
            return wram[Int(address - 0xC000)]
            
            
        case 0xE000...0xFDFF:
            //Echo ram, não utilizável
            return wram[Int(address - 0xE000)]
            
            
        case 0xFE00...0xFE9F:
            // OAM (Sprites)
            
            return oam[Int(address - 0xFE00)]
            
        case 0xFF80...0xFFFE:
            //hram
            return hram[Int(address - 0xFF80)]
            
        case 0xFFFF:
            return interruptEnable
            
        case 0xFF40: return lcdc
        case 0xFF41: return stat
        case 0xFF42: return scy
        case 0xFF43: return scx
        case 0xFF44: return ly
        case 0xFF45: return lyc
        case 0xFF46: return dma
        case 0xFF47: return bgp
        case 0xFF48: return obp0
        case 0xFF49: return obp1
        case 0xFF4A: return wy
        case 0xFF4B: return wx
            
        default:
            return 0xFF
            
        }
    }
    
    public func write(address: UInt16, value: UInt8){
        switch address {
        case 0x0000...0x7FFF:
            //rom do cartucho(somente leitura)
            break
            
        case 0x8000...0x9FFF:
            //vram
            vram[Int(address - 0x8000)] = value
            
            
        case 0xA000...0xBFFF:
            //External ram (save do cartucho)
            break
            
        case 0xC000...0xDFFF:
            //lendo wram
            wram[Int(address - 0xC000)] = value
            
            
        case 0xE000...0xFDFF:
            //Echo ram, não utilizável
            wram[Int(address - 0xE000)] = value
            
        case 0xFF01:
            // Interceptando a escrita do Cabo Link!
            let character = Character(UnicodeScalar(value))
            print(character, terminator: "")
        case 0xFE00...0xFE9F:
            // OAM (Sprites)
            
            oam[Int(address - 0xFE00)] = value
            
        case 0xFEA0...0xFEFF:
            // Espaço vazio / Não utilizável
            break
            
//        case 0xFF00...0xFF7F:
//            // I/O
//            break
            
        case 0xFF80...0xFFFE:
            //hram
            hram[Int(address - 0xFF80)] = value
            
        case 0xFFFF:
            interruptEnable = value
            
            
        case 0xFF40: lcdc = value
        case 0xFF41: stat = value
        case 0xFF42: scy = value
        case 0xFF43: scx = value
        case 0xFF44: break // LY é Read Only
        case 0xFF45: lyc = value
        case 0xFF46: dma = value
        case 0xFF47: bgp = value
        case 0xFF48: obp0 = value
        case 0xFF49: obp1 = value
        case 0xFF4A: wy = value
        case 0xFF4B: wx = value
            
            
        default:
            print("Aviso: Tentativa de escrita em endereço não mapeado: \(String(format: "%04X", address))")
            break
            
        }
        
        
        
    }
    
}
