//
//  CalculatorView.swift
//  Learning SwiftUI
//
//  Created by Ezreal on 2020/7/27.
//  Copyright © 2020 Ezeal. All rights reserved.
//

import SwiftUI
import Combine

// MARK: - 计算器按钮

struct CalculatorButton: View {
    
    let fontSize: CGFloat = 38
    let title: String
    let size: CGSize
    let backgroundColorName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: fontSize))
                .foregroundColor(.white)
                .frame(width: size.width, height: size.height)
                .background(Color(backgroundColorName))
                .cornerRadius(size.width / 2)
        }
    }
}

// MARK: - 计算器行

struct CalculatorButtonRow: View {
    
    let items: [CalculatorButtonItem]
    
    @EnvironmentObject var model: CalculatorModel
    
    var body: some View {
        HStack {
            ForEach(items, id: \.self) { item in
                CalculatorButton(title: item.title,
                                 size: item.size,
                                 backgroundColorName: item.backgroundColorName,
                                 action: { self.model.apply(item) })
            }
        }
    }
}

// MARK: - 计算器列

struct CalculatorButtonPad: View {
        
    let data: [[CalculatorButtonItem]] = [[.command(.clear), .command(.flip), .command(.percent), .op(.divide)],
                                          [.digit(7), .digit(8), .digit(9), .op(.multiply)],
                                          [.digit(4), .digit(5), .digit(6), .op(.minus)],
                                          [.digit(1), .digit(2), .digit(3), .op(.plus)],
                                          [.digit(0), .dot, .op(.equal)]]
    
    var body: some View {
        
        VStack(spacing: 8) {
            ForEach(data, id: \.self) { CalculatorButtonRow(items: $0) }
        }
    }
}

// MARK: - 计算器

struct CalculatorView: View {
    
    @EnvironmentObject var model: CalculatorModel
    
    @State private var editingHistory = false
        
    var body: some View {
        
        VStack(spacing: 12) {
            Spacer()
            Button("操作履历：\(model.history.count)") {
                self.editingHistory = true
            }.sheet(isPresented: self.$editingHistory) {
                HistoryView(model: self.model)
            }
            Text(model.brain.output)
                .font(.system(size: 76))
                .minimumScaleFactor(0.5)
                .padding(.trailing, 24)
                .lineLimit(1)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
            CalculatorButtonPad()
                .padding(.bottom)
        }
        .scaleEffect(UIScreen.main.bounds.width / 414.0)
    }
}

// MARK: - 历史记录

struct HistoryView: View {
    
    @ObservedObject var model: CalculatorModel
    
    var body: some View {
        VStack {
            if model.totalCount == 0 {
                Text("没有履历")
            } else {
                HStack {
                    Text("履历").font(.headline)
                    Text("\(model.historyDetail)").lineLimit(nil)
                }
                HStack {
                    Text("显示").font(.headline)
                    Text("\(model.brain.output)")
                }
                Slider(value: $model.slidingIndex,
                       in: 0...Float(model.totalCount),
                       step: 1)
            }
        }
    }
}
