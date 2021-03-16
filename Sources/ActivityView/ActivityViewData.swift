//
//  ActiveChartWeek.swift
//  FocusTimer
//
//  Created by Xiaodong Liu on 10/03/2021.
//

import Foundation
import SwiftUI



public struct ActivityItem : Equatable,Codable,Hashable{
    var date : Date
    var duration : Int
    public init(date:Date, duration:Int){
        self.date = date
        self.duration = duration
    }
}


public class ActivityViewData {
    enum TileColors : CaseIterable{
        case tier1, tier2, tier3, tier4, tier5
    }
    
    var weeksNumber : Int
    var activityItems : [ActivityItem]?
    var monthIdentifier = [String]()
    var all = [[TileColors]]()
    
    public init(weeksNumber : Int, activeChartItems : [ActivityItem]?) {
        self.weeksNumber = weeksNumber
        self.activityItems = activeChartItems
        refresh()
    }
    
    func refresh(){
        self.monthIdentifier = getMonthIdentifier()
        self.all = gen()
    }
    
    
    private func formatedActiveChartItems() -> [Int:Int]{
        let sortedItems = self.activityItems?.sorted(by: { (p, n) -> Bool in
            return p.date.compare(n.date).rawValue < 0
        })
        let daysBreak = ((self.weeksNumber-1) * 7 + Date().dayNumberOfWeek()! - 1)
        let timeGapInterval = TimeInterval(-86500*daysBreak)
        let startDate = Date().addingTimeInterval(timeGapInterval)
        var results : [Int:Int] = [:]
        
        sortedItems?.forEach{ e in
            let day = Calendar.current.dateComponents([.day], from: startDate, to: e.date).day
            if results[day!] == nil{
                results[day!] = e.duration
            }else{
                results[day!]! += e.duration
            }
            
        }
        return results
    }
    
    private func gen() -> [[TileColors]] {
        let dict = self.formatedActiveChartItems()
        var durationMaxValue = 0
        dict.forEach{ (_, value) in
            durationMaxValue = durationMaxValue > value ? durationMaxValue : value
            
        }
        let tierInterval = durationMaxValue/5
        
        var results = [[TileColors]]()
        for week in (0...self.weeksNumber-1) {
            var tempResults : [TileColors] = []
            for day in (0...6){
                let offsetDay = week*7+day
                guard let value = dict[offsetDay] else{
                    tempResults.append(.tier1)
                    continue
                }
                switch value {
                    case let x where x<=tierInterval : tempResults.append(.tier1)
                    case let x where x<=2*tierInterval : tempResults.append(.tier2)
                    case let x where x<=3*tierInterval : tempResults.append(.tier3)
                    case let x where x<=4*tierInterval : tempResults.append(.tier4)
                    case let x where x<=5*tierInterval : tempResults.append(.tier5)
                default:
                    tempResults.append(.tier1)
                }
            }
            results.append(tempResults)
        }

        return results
    }
}


extension ActivityViewData {
    private func getMonthIdentifier() -> [String] {
        var results = [String]()
        var buffer = ""
        (0...self.weeksNumber-1).reversed().forEach{ i in
            let newLabel = Date().monthNumberOfYear(numberOfLastWeeks: i)!
            let skipAddIdentifier = newLabel == buffer || i > self.weeksNumber - 3
            if !skipAddIdentifier {
                results.append(newLabel)
                buffer = newLabel}else{
                    results.append("")
                } }
        return results
    }
}


extension ActivityViewData.TileColors{
    var color : Color {
        switch self {
        case .tier1 : return Color.init(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0)
        case .tier2 : return Color.init(red: 217.0/255.0, green: 229.0/255.0, blue: 145.0/255.0)
        case .tier3 : return Color.init(red: 152.0/255.0, green: 196.0/255.0, blue: 113.0/255.0)
        case .tier4 : return Color.init(red: 94.0/255.0, green: 160.0/255.0, blue: 77.0/255.0)
        case .tier5 : return Color.init(red: 56.0/255.0, green: 106.0/255.0, blue: 49.0/255.0)
        }
    }
}


extension Date{
    func monthNumberOfYear(numberOfLastWeeks:Int) -> String? {
        let f = Calendar.current.dateComponents([.month], from: self.addingTimeInterval(TimeInterval(-numberOfLastWeeks*604800))).month
        return DateFormatter().monthSymbols[f! - 1].prefix(3).description
    }
    
    func dayNumberOfWeek() -> Int? {
            return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    
}

