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
//                .background(Color.green)
        }
    }
}

// MARK: - 计算器行

struct CalculatorButtonRow: View {
    
    let items: [CalculatorButtonItem]
    
    @EnvironmentObject var model: CalculatorModel
    
//    @Binding var brain: CalculatorBrain
    
    var body: some View {
        HStack {
            ForEach(items, id: \.self) { item in
                CalculatorButton(title: item.title,
                                 size: item.size,
                                 backgroundColorName: item.backgroundColorName,
                                 action: {
                                    self.model.apply(item)
//                                    self.brain = self.brain.apply(item: item)
                                    
                })
            }
        }
    }
}

// MARK: - 计算器列

struct CalculatorButtonPad: View {
    
//    @Binding var brain: CalculatorBrain
        
    let data: [[CalculatorButtonItem]] = [[.command(.clear), .command(.flip), .command(.percent), .op(.divide)],
                                          [.digit(7), .digit(8), .digit(9), .op(.multiply)],
                                          [.digit(4), .digit(5), .digit(6), .op(.minus)],
                                          [.digit(1), .digit(2), .digit(3), .op(.plus)],
                                          [.digit(0), .dot, .op(.equal)]]
    
    var body: some View {
        
        VStack(spacing: 8) {
            /// \.self 可以直接访问data中的元素，用元素本身值作为id，
            ForEach(data, id: \.self) { CalculatorButtonRow(items: $0) }
        }
    }
}

// MARK: - 计算器

struct CalculatorView: View {
    
    @EnvironmentObject var model: CalculatorModel
    
    /**
     在传递 brain 时，我们在它前面加上美元符号 $。
     在 Swift 5.1 中，对一个由 @ 符号修饰的属性，在它前面使用 $ 所取得的值，被称为投影属性 (projection property)。
     有些 @ 属性，比如这里的 @State 和 @Binding，它们的投影属性就是自身所对应值的 Binding 类型。
     不过要注意的是，并不是所有的 @ 属性都提供 $ 的投影访问方式。
     这样一来，底层 CalculatorButtonRow 中对 brain 的修改，将反过来影响和设置最顶层 ContentView 中的 @State brain。
     */
//    @State var brain: CalculatorBrain = .left("0")
    
    @State private var editingHistory = false
            
    var body: some View {
        
        VStack(spacing: 12) {
            Spacer()
            
            Button("操作记录：\(model.history.count)") {
                self.editingHistory = true
            }.sheet(isPresented: self.$editingHistory) {
                HistoryView(model: self.model)
            }
            
//            HStack {
//                Text("@State & @Binding: ")
//                Text(brain.output).foregroundColor(.red)
//                Spacer()
//            }.padding()
            
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
    
    /// @EnvironmentObject?
    @ObservedObject var model: CalculatorModel
    
    var body: some View {
        VStack {
            if model.totalCount == 0 {
                Text("没有记录")
            } else {
                HStack {
                    Text("记录：").font(.headline)
                    Text("\(model.historyDetail)").lineLimit(nil)
                }
                
                HStack {
                    Text("显示：").font(.headline)
                    Text("\(model.brain.output)")
                }
                
                Slider(value: $model.slidingIndex,
                       in: 0...Float(model.totalCount),
                       step: 1)
            }
        }
    }
}
