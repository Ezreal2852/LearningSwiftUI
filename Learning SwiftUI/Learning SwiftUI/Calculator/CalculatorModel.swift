//
//  CalculatorModel.swift
//  Learning SwiftUI
//
//  Created by Ezreal on 2020/7/28.
//  Copyright © 2020 Ezeal. All rights reserved.
//

import Combine

class CalculatorModel: ObservableObject {
    
    @Published var brain: CalculatorBrain = .left("0")
    @Published var history: [CalculatorButtonItem] = []
    
    var temporaryKept: [CalculatorButtonItem] = []
    
    var historyDetail: String {
        return history.map{ $0.description }.joined()
    }
    
    var totalCount: Int {
        history.count + temporaryKept.count
    }

    var slidingIndex: Float = 0 {
        didSet {
            keepHistory(upTo: Int(slidingIndex))
        }
    }
    
    func apply(_ item: CalculatorButtonItem) {
        brain = brain.apply(item: item)
        history.append(item)
        temporaryKept.removeAll()
        slidingIndex = Float(totalCount)
    }
    
    func keepHistory(upTo index: Int) {
        precondition(index <= totalCount, "Out of index.")
        
        let total = history + temporaryKept
        
        history = Array(total[..<index])
        temporaryKept = Array(total[index...])
        
        brain = history.reduce(CalculatorBrain.left("0")) { result, item in result.apply(item: item) }
    }
}
