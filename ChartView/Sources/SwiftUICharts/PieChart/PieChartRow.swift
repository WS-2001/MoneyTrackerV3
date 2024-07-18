//
//  PieChartRow.swift
//  ChartView
//
//  Created by András Samu on 2019. 06. 12..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI

public struct PieChartRow : View {
    var data: [Double]
    var colors: [Color]
    var slices: [PieSlice] {
        var tempSlices:[PieSlice] = []
        var lastEndDeg:Double = 0
        let maxValue = data.reduce(0, +)
        for slice in data {
            let normalized:Double = Double(slice)/Double(maxValue)
            let startDeg = lastEndDeg
            let endDeg = lastEndDeg + (normalized * 360)
            lastEndDeg = endDeg
            tempSlices.append(PieSlice(startDeg: startDeg, endDeg: endDeg, value: slice, normalizedValue: normalized))
        }
        return tempSlices
    }

    @Binding var showValue: Bool
    @Binding var currentValue: Double

    @State private var currentTouchedIndex = -1 {
        didSet {
            if oldValue != currentTouchedIndex {
                showValue = currentTouchedIndex != -1
                currentValue = showValue ? slices[currentTouchedIndex].value : 0
            }
        }
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<self.slices.count) { i in
                    PieChartCell(rect: geometry.frame(in: .local), startDeg: self.slices[i].startDeg, endDeg: self.slices[i].endDeg, index: i, backgroundColor: .white, accentColor: self.colors[i])
                        .scaleEffect(self.currentTouchedIndex == i ? 1.1 : 1)
                        .animation(Animation.spring())
                }
            }
            .gesture(DragGesture()
                .onChanged({ value in
                    let rect = geometry.frame(in: .local)
                    let isTouchInPie = isPointInCircle(point: value.location, circleRect: rect)
                    if isTouchInPie {
                        let touchDegree = degree(for: value.location, inCircleRect: rect)
                        self.currentTouchedIndex = self.slices.firstIndex(where: { $0.startDeg < touchDegree && $0.endDeg > touchDegree }) ?? -1
                    } else {
                        self.currentTouchedIndex = -1
                    }
                })
                .onEnded({ value in
                    self.currentTouchedIndex = -1
                }))
        }
    }
}
