//
//  ActiveChart.swift
//  FocusTimer
//
//  Created by Xiaodong Liu on 10/03/2021.
//

import SwiftUI

public struct ActivityView: View {

    let data : ActivityViewData
    let showLegend : Bool
    
    public init(data : ActivityViewData, showLegend : Bool){
        self.data = data
        self.showLegend = showLegend
    }
    
    public var body: some View {
        VStack{
            HStack(alignment: .bottom){
                ForEach(0..<data.all.count){ index in
                    weekTiles(data: data.all[index],text: data.monthIdentifier[index] )
                }
            }
            if showLegend {
                HStack{
                    Spacer()
                    legend()
                        .padding(.trailing)
                }
            }
        }
    }
}

struct weekTiles:View {
    let data : [ActivityViewData.TileColors]
    let text : String
    var body: some View{
        VStack{
            Text(text)
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.horizontal , -5)
            ForEach(0..<data.count){ index in
                dayTile(tier: data[index])
            }
        }
    }
}

struct legend:View {
    var body: some View{
        HStack{
            Text("Less")
                .font(.caption)
                .foregroundColor(.gray)
            Rectangle()
                .frame(width:12,height: 12)
                .foregroundColor(ActivityViewData.TileColors.tier1.color)
                .padding(-3)
            Rectangle()
                .frame(width:12,height: 12)
                .foregroundColor(ActivityViewData.TileColors.tier2.color)
                .padding(-3)
            Rectangle()
                .frame(width:12,height: 12)
                .foregroundColor(ActivityViewData.TileColors.tier3.color)
                .padding(-3)
            Rectangle()
                .frame(width:12,height: 12)
                .foregroundColor(ActivityViewData.TileColors.tier4.color)
                .padding(-3)
            Rectangle()
                .frame(width:12,height: 12)
                .foregroundColor(ActivityViewData.TileColors.tier5.color)
                .padding(-3)
            Text("More")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct dayTile:View {
    let tier : ActivityViewData.TileColors
    var body: some View{
        VStack{
            Rectangle()
                .frame(width:15,height: 15)
                .foregroundColor(tier.color)
                .padding(-3)
        }
    }
}

