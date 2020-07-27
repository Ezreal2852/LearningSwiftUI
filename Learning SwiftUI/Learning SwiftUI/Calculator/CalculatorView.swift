//
//  CalculatorView.swift
//  Learning SwiftUI
//
//  Created by Ezreal on 2020/7/27.
//  Copyright © 2020 Ezeal. All rights reserved.
//

import SwiftUI

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
    
    var body: some View {
        HStack {
            ForEach(items, id: \.self) { (item) -> CalculatorButton in
                CalculatorButton(title: item.title,
                                 size: item.size,
                                 backgroundColorName: item.backgroundColorName,
                                 action: { print(item.title) })
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
            ForEach(data, id: \.self) { (item) -> CalculatorButtonRow in
                CalculatorButtonRow(items: item)
            }
        }
    }
}

// MARK: - 计算器

struct CalculatorView: View {
    
    let scale: CGFloat = UIScreen.main.bounds.width / 414.0
    
    var body: some View {
        
        VStack(spacing: 12) {
            Spacer()
            Text("0")
                .font(.system(size: 76))
                .minimumScaleFactor(0.5)
                .padding(.trailing, 24)
                .lineLimit(1)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
            CalculatorButtonPad()
                .padding(.bottom)
        }
        .scaleEffect(scale)
    }
}
