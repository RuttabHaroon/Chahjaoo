//
//  YAxisValueFormatter.swift
//  Chaajao
//
//  Created by Ahmed Khan on 28/09/2021.
//


import Charts
class YAxisValueFormatter : IAxisValueFormatter {

	func stringForValue(_ value: Double, axis: AxisBase?) -> String {
		return "\(Int(value))s"
	}
	
}

class XAxisValueFormatter : IAxisValueFormatter {

	func stringForValue(_ value: Double, axis: AxisBase?) -> String {
		return "\(Int(value) + 1)"
	}
}
