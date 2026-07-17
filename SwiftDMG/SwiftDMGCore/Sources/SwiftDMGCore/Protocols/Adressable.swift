//
//  Adressable.swift
//  SwiftDMGCore
//
//  Created by Davi Sobreira Brasil on 16/07/26.
//


import Foundation

public protocol Addressable {
    func read(address: UInt16) -> UInt8
    func write(address: UInt16, value: UInt8)
}
