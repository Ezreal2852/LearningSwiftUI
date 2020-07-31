//
//  ContentView.swift
//  Learning SwiftUI
//
//  Created by Ezreal on 2020/7/16.
//  Copyright © 2020 Ezeal. All rights reserved.
//

import SwiftUI

/**
 一个计算器：
 数字、小数点、运算符、功能指令
 可以输入并展示、正确计算结果、正确处理错误
 可以记录用户操作，并显示在历史面板，拖动滑块可以回溯历史记录并正确显示
 */

struct ContentView: View {
    
    var body: some View {
        CalculatorView().environmentObject(CalculatorModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            ContentView()
//            ContentView().previewDevice("iPhone SE")
//            ContentView().previewDevice("iPhone 8 Plus")
//            ContentView().previewDevice("iPhone Xs Max")
        }
    }
}
