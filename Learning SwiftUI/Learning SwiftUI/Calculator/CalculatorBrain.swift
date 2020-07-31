//
//  CalculatorBrain.swift
//  Learning SwiftUI
//
//  Created by Ezreal on 2020/7/28.
//  Copyright © 2020 Ezeal. All rights reserved.
//

import Foundation

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
    /// 计算器等号显示了一个结果或错误，此时相当于输入了一个左边的数字
    case equal(value: String)
    /// 输入或计算结果出现了错误，无法继续。比如发生了“除以 0”的操作。
    case error
    
    /// 用于显示结果
    var output: String {
        let result: String
        switch self {
        case .left(let left): result = left
        case .leftOp(let left, _): result = left
        case .leftOpRight(_, _, let right): result = right
        case .equal(value: let value): result = value
        case .error: result = "Error"
        }
        guard let value = Double(result) else {
            return "Error"
        }
        
        return formatter.string(from: value as NSNumber)!
    }
    
    /// 接收输入数据，并返回计算器当前状态
    func apply(item: CalculatorButtonItem) -> CalculatorBrain {
        switch item {
        case .digit(let num): return apply(num: num)
        case .dot: return applyDot()
        case .op(let op): return apply(op: op)
        case .command(let command): return apply(command: command)
        }
    }
}

/// 8位小数点以内格式化
/// 文件内因为无需在他处使用，且不必为类型添加不必要的静态类型，闭包可以优化性能，防止重复调用
fileprivate var formatter: NumberFormatter = {
    let f = NumberFormatter()
    f.minimumFractionDigits = 0
    f.maximumFractionDigits = 8
    f.numberStyle = .decimal
    return f
}()

// MARK: 根据输入的类型+计算器当前状态->计算器的输入后状态

private extension CalculatorBrain {
    
    func apply(num: Int) -> CalculatorBrain {
        switch self {
        case .left(let left):
            return .left(left.apply(num: num))
        case .leftOp(let left, let op):
            return .leftOpRight(left: left, op: op, right: "0".apply(num: num))
        case .leftOpRight(let left, let op, let right):
            return .leftOpRight(left: left, op: op, right: right.apply(num: num))
        case .equal(_):
            return .left("0".apply(num: num))
        case .error:
            return .left("0".apply(num: num))
        }
    }
    
    func applyDot() -> CalculatorBrain {
        switch self {
        case .left(let left):
            return .left(left.applyDot())
        case .leftOp(let left, let op):
            return .leftOpRight(left: left, op: op, right: "0".applyDot())
        case .leftOpRight(let left, let op, let right):
            return .leftOpRight(left: left, op: op, right: right.applyDot())
        case .equal(_):
            return .left("0".applyDot())
        case .error:
            return .left("0".applyDot())
        }
    }
    
    func apply(op: CalculatorButtonItem.Op) -> CalculatorBrain {
        switch self {
        case .left(let left):
            switch op {
            case .plus, .minus, .multiply, .divide:
                return .leftOp(left: left, op: op)
            case .equal:
                return self
            }
        case .leftOp(let left, let currentOp):
            switch op {
            case .plus, .minus, .multiply, .divide:
                return .leftOp(left: left, op: op)
            case .equal:
                if let result = currentOp.calculate(l: left, r: left) {
                    return .leftOp(left: result, op: currentOp)
                } else {
                    return .error
                }
            }
        case .leftOpRight(let left, let currentOp, let right):
            switch op {
            case .plus, .minus, .multiply, .divide:
                if let result = currentOp.calculate(l: left, r: right) {
                    return .leftOp(left: result, op: currentOp)
                } else {
                    return .error
                }
            case .equal:
                if let result = currentOp.calculate(l: left, r: right) {
                    return .equal(value: result)
                } else {
                    return .error
                }
            }
        case .equal(let value):
            switch op {
            case .plus, .minus, .multiply, .divide:
                return .leftOp(left: value, op: op)
            case .equal: return self
            }
        case .error:
            return self
        }
    }
    
    func apply(command: CalculatorButtonItem.Command) -> CalculatorBrain {
        switch command {
        case .clear:
            return .left("0")
        case .flip:
            switch self {
            case .left(let left):
                return .left(left.flipped())
            case .leftOp(let left, let op):
                return .leftOpRight(left: left, op: op, right: "-0")
            case .leftOpRight(let left, let op, let right):
                return .leftOpRight(left: left, op: op, right: right.flipped())
            case .equal(let value):
                return .left(value.flipped())
            case .error:
                return .left("-0")
            }
        case .percent:
            switch self {
            case .left(let left):
                return .left(left.percentaged())
            case .leftOp:
                return self
            case .leftOpRight(let left, let op, let right):
                return .leftOpRight(left: left, op: op, right: right.percentaged())
            case .equal(let value):
                return .left(value.percentaged())
            case .error:
                return .left("-0")
            }
        }
    }
}

// MARK: - 字符串功能拓展(计算器功能键指令)

extension String {
        
    /// 输入数值
    func apply(num: Int) -> String { self == "0" ? "\(num)" : "\(self)\(num)" }
    
    /// 添加小数点
    func applyDot() -> String { contains(".") ? self : "\(self)." }
    
    /// 取相反值
    func flipped() -> String {
        if starts(with: "-") {
            var s = self
            s.removeFirst()
            return s
        } else {
            return "-\(self)"
        }
    }
    
    /// 百分比
    func percentaged() -> String { String(Double(self)! / 100) }
}

// MARK: - 运算符的计算方法

extension CalculatorButtonItem.Op {
    
    func calculate(l: String, r: String) -> String? {
        
        guard let left = Double(l), let right = Double(r) else {
            return nil
        }
        
        let result: Double?
        switch self {
        case .plus: result = left + right
        case .minus: result = left - right
        case .multiply: result = left * right
        case .divide: result = right == 0 ? nil : left / right
        case .equal: fatalError("等号不可能为连接运算符")
        }
        
        return result.map { String($0) }
    }
}
