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

enum CalculatorButtonItem: Hashable {// rawValue 作为 ForEach.id 的要求 Hashable
    
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

// MARK: - 计算器的状态

/// 左侧数字 + 计算符号 + 右侧数字 + 计算符号或等号
enum CalculatorBrain {
    /// 计算器正在输入算式左侧数字，这个状态将在用户按下计算操作按钮 (加减乘除号) 后改变为下一个状态。
    case left(String)
    /// 计算器输入了左侧数字和计算符号，等待开始输入右侧符号。
    case leftOp(
        left: String,
        op: CalculatorButtonItem.Op
    )
    /// 计算器已经输入了左侧数字，计算符号，和部分右侧数字，并在等待更多右侧数字的输入。
    case leftOpRight(
        left: String,
        op: CalculatorButtonItem.Op,
        right: String
    )
    /// 输入或计算结果出现了错误，无法继续。比如发生了“除以 0”的操作。
    case error
}
