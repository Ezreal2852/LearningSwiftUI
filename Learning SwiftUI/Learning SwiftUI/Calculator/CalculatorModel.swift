//
//  CalculatorModel.swift
//  Learning SwiftUI
//
//  Created by Ezreal on 2020/7/28.
//  Copyright © 2020 Ezeal. All rights reserved.
//

import Combine

class CalculatorModel: ObservableObject {
    
    /// ObservableObject协议对象
//    let objectWillChange = PassthroughSubject<Void, Never>()
//
//    var brain: CalculatorBrain = .left("0") {
    /// 监听属性willSet，发送监听对象需要更新的通知
//        willSet { objectWillChange.send() }
//    }
    
    /// 当前操作
    @Published var brain: CalculatorBrain = .left("0")
    /// 历史操作
    @Published var history: [CalculatorButtonItem] = []
    
    /// 缓存回溯历史，产生新的操作清空
    var temporaryKept: [CalculatorButtonItem] = []
    
    /// 历史操作拼接展示
    var historyDetail: String {
        return history.map{ "\($0)" }.joined()
    }
    
    /// 全部历史条数
    var totalCount: Int {
        history.count + temporaryKept.count
    }

    /// 当前滑块位置
    var slidingIndex: Float = 0 {
        didSet {
            keepHistory(upTo: Int(slidingIndex))
        }
    }
    
    /// 响应操作
    func apply(_ item: CalculatorButtonItem) {
        brain = brain.apply(item: item)
        history.append(item)
        temporaryKept.removeAll()
        slidingIndex = Float(totalCount)
    }
    
    /// 滑动位置，回溯历史
    func keepHistory(upTo index: Int) {
        precondition(index <= totalCount, "Out of index.")
        
        let total = history + temporaryKept
        
        history = Array(total[..<index])
        temporaryKept = Array(total[index...])
        
        /// 通过历史数组获得最后的计算器状态，赋值还原
        brain = history.reduce(CalculatorBrain.left("0"), { $0.apply(item: $1) })
//        brain = history.reduce(into: CalculatorBrain.left("0"), { $0 = $0.apply(item: $1) })
    }
}
