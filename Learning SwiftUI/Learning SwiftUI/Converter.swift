//
//  propertyWrapper.swift
//  Learning SwiftUI
//
//  Created by Ezreal on 2020/7/29.
//  Copyright © 2020 Ezeal. All rights reserved.
//

import Foundation

/**
 
 propertyWrapper：属性包装
 
 @propertyWrapper
 public struct State<Value> : DynamicViewProperty, BindingConvertible {
 
   public init(initialValue value: Value)
   
   /// 固有值
   public var value: Value { get nonmutating set }
   /// 包装值
   public var wrappedValue: Value { get nonmutating set }
   /// 推断值
   public var projectedValue: Binding<Value> { get }
 }
 
 1、由于 init(initialValue:) 的存在，我们可以使用直接给 brain 赋值的写法，将一个 CalculatorBrain 传递给 brain。
 我们可以为属性包装中定义的 init 方法添加更多的参数，我们会在接下来看到一个这样的例子。
 不过 initialValue 这个参数名相对特殊：当它出现在 init 方法的第一个参数位置时，编译器将允许我们在声明的时候直接为 @State var brain 进行赋值。
 
 2、在访问 brain 时，这个变量暴露出来的就是 CalculatorBrain 的行为和属性。
 对 brain 进行赋值，看起来也就和普通的变量赋值没有区别。
 但是，实际上这些调用都触发的是属性包装中的 wrappedValue。
 @State 的声明，在底层将 brain 属性“包装”到了一个 State<CalculatorBrain> 中，并保留外界使用者通过 CalculatorBrain 接口对它进行操作的可能性。
 
 3、使用美元符号前缀 ($) 访问 brain，其实访问的是 projectedValue 属性。
 在 State 中，这个属性返回一个 Binding 类型的值，通过遵守 BindingConvertible，State 暴露了修改其内部存储的方法，这也就是为什么传递 Binding 可以让 brain 具有引用语义的原因。
 
 */

func testConverter() {
        
    /// wrappedValue = projectedValue
    print("\(Converter.usd_cny) = \(Converter.$usd_cny)")
    
    print("\(Converter.cny_usd) = \(Converter.$cny_usd)")
    
    /// set wrappedValue
    Converter.usd_cny = "1000"
    
    print("\(Converter.usd_cny) = \(Converter.$usd_cny)")
}

@propertyWrapper struct Converter {
    
    @Converter("100", from: "USD", to: "CNY", rate: 7)
    static var usd_cny
    
    @Converter("100", from: "CNY", to: "USD", rate: 1.0 / 7.0)
    static var cny_usd
    
    let from: String
    let to: String
    let rate: Double
    
    var value: Double
    
    var wrappedValue: String {
        get { "\(from) \(value)" }
        set { value = Double(newValue) ?? -1 }
    }
    
    var projectedValue: String {
        "\(to) \(value * rate)"
    }
    
    init(_ initialValue: String,
         from: String,
         to: String,
         rate: Double) {
        
        self.rate = rate
        self.value = 0
        self.from = from
        self.to = to
        self.wrappedValue = initialValue
    }
}
