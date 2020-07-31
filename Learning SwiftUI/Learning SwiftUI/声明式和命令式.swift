//
//  声明式和命令式.swift
//  Learning SwiftUI
//
//  Created by Ezreal on 2020/7/31.
//  Copyright © 2020 Ezeal. All rights reserved.
//

import Foundation

struct Student {
    let name: String
    let scores: [科目: Int]
}

enum 科目: String, CaseIterable {
    case 语文, 数学, 英语, 物理
}

let students = [Student(name: "Jane", scores: [.语文: 86, .数学: 92, .英语: 73, .物理: 88]),
                Student(name: "Tom", scores: [.语文: 99, .数学: 52, .英语: 97, .物理: 36]),
                Student(name: "Emma", scores: [.语文: 91, .数学: 92, .英语: 100, .物理: 99])]

func testCommand() {
    
    print("命令式：")
    
    /// 我们现在想要检查 students 里的学生的平均分，并输出第一名的姓名。使用指令式的方式，依靠运算，循环和条件语句，可以给出下面这种解决方案：
    
    var best: (Student, Double)?
    
    for s in students {
        var totalScore = 0
        for key in 科目.allCases {
            totalScore += s.scores[key] ?? 0
        }
        let averageScore = Double(totalScore) / Double(科目.allCases.count)
        if let temp = best {
            if averageScore > temp.1 {
                best = (s, averageScore)
            }
        } else {
            best = (s, averageScore)
        }
    }
    
    if let best = best {
        print("最高平均分: \(best.1), 姓名: \(best.0.name)")
    } else {
        print("students 为空")
    }
}

func testDeclare() {
    
    print("申明式：")
        
    /**
     将 students 映射为了 (Student, 平均分) 的数组，然后对平均分按降序进行排序，最后取出排序后的首个元素。
     在这个过程中，我们仅仅是用语句描述了我们想要的结果，例如：按规则进行映射、对元素进行排序等。
     我们并不关心代码在底层具体是如何操作数组的，而只关心这段代码能够得到我们所描述的结果。
     */
    
    func average(_ scores: [科目: Int]) -> Double {
        Double(scores.values.reduce(0, +)) / Double(科目.allCases.count)
    }
    
    let best = students
        .map { ($0, average($0.scores)) }
        .sorted { $0.1 > $1.1 }
        .first
    
    if let best = best {
        print("最高平均分: \(best.1), 姓名: \(best.0.name)")
    } else {
        print("students 为空")
    }
}
