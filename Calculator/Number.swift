//
//  Number.swift
//  Calculator
//
//  Created by JUNYEONG.YOO on 1/22/17.
//  Copyright © 2017 Boostcamp. All rights reserved.
//

import Foundation

struct Number {
	static let formatterWithSeperator: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.groupingSeparator = ","
		formatter.numberStyle = .decimal
		return formatter
	}()
}
