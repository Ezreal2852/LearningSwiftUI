//
//  CalculatorModel.swift
//  Learning SwiftUI
//
//  Created by Ezreal on 2020/7/27.
//  Copyright © 2020 Ezeal. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 按钮模型

enum CalculatorButtonItem {
    
    /// 运算符
    enum Op: String {
        case plus    = "+"
        case minus   = "-"
        case divide  = "÷"
        case multiply = "×"
        case equal   = "="
    }
    
    /// 指令
    enum Command: String {
        case clear   = "AC"
        case flip    = "+/-"
        case percent = "%"
    }
    
    case digit(Int)
    case dot
    case op(Op)
    case command(Command)
}

extension CalculatorButtonItem {
    
    var title: String {
        switch self {
        case .digit(let value): return String(value)
        case .dot: return "."
        case .op(let op): return op.rawValue
        case .command(let command): return command.rawValue
        }
    }
    
    var size: CGSize {
        if case .digit(let value) = self, value == 0 {
            return CGSize(width: 88 * 2 + 8, height: 88)
        }
        return CGSize(width: 88, height: 88)
    }
    
    var backgroundColorName: String {
        switch self {
        case .digit, .dot: return "digitBackground"
        case .op: return "operatorBackground"
        case .command: return "commandBackground"
        }
    }
}

/// rawValue 作为 ForEach.id 的要求 Hashable
extension CalculatorButtonItem: Hashable {}

/// 为枚举对象添加描述，"\(CalculatorButtonItem)"便于显示
extension CalculatorButtonItem: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .digit(let num): return String(num)
        case .dot: return "."
        case .op(let op): return op.rawValue
        case .command(let command): return command.rawValue
        }
    }
}
