//
//  ContentView.swift
//  Learning SwiftUI
//
//  Created by Ezreal on 2020/7/16.
//  Copyright © 2020 Ezeal. All rights reserved.
//

import SwiftUI

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
