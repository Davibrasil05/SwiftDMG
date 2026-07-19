//
//  MemoryBus.swift
//  SwiftDMGCore
//
//  Created by Davi Sobreira Brasil on 16/07/26.
//

import Foundation

public class MemoryBus: Addressable{
    private var wram = [UInt8](repeating: 0, count: 8192) //array de 8 bits para a memória de workram
    
    private var hram = [UInt8](repeating: 0, count:127)
    
    private var interruptEnable: UInt8 = 0
    
    private var rom = [UInt8](repeating: 0, count: 32768)
    
    public init(){}
    
    public func read(address: UInt16) -> UInt8 {
        switch address {
        case 0x0000...0x7FFF:
            //rom do cartucho
            return rom[Int(address)]
            
        case 0x8000...0x9FFF:
            //Vram
            return 0xFF
            
            
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
            
            return 0xFF
            
        case 0xFF80...0xFFFE:
            //hram
            return hram[Int(address - 0xFF80)]
            
        case 0xFFFF:
            return interruptEnable
            
            
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
            break
            
            
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
            
            break
            
        case 0xFEA0...0xFEFF:
            // Espaço vazio / Não utilizável
            break
            
        case 0xFF00...0xFF7F:
            // I/O
            break
            
        case 0xFF80...0xFFFE:
            //hram
            hram[Int(address - 0xFF80)] = value
            
        case 0xFFFF:
            interruptEnable = value
            
            
        default:
            print("Aviso: Tentativa de escrita em endereço não mapeado: \(String(format: "%04X", address))")
            break
            
        }
        
        
        
    }
    
    public func load(cartdrigeData: [UInt8]){
        for(index, byte) in cartdrigeData.enumerated() {
            if index < rom.count {
                rom[index] = byte
            }
        }
    }
}
