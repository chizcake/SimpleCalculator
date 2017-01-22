//
//  ViewController.swift
//  Calculator
//
//  Created by JUNYEONG.YOO on 1/22/17.
//  Copyright © 2017 Boostcamp. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

	// MARK: Properties
	
	var activeTextField: UITextField!
	let pickerViewTitles: [String] = [ "Choose an Operator", "+", "-", "*", "/" ]
	
	var firstOperand: Int = 0
	var secondOperand: Int = 0
	var chosenOperator: String = ""
	

	// MARK: IBOutlets
	
	@IBOutlet weak var firstOperandTextField: UITextField!
	@IBOutlet weak var secondOperandTextField: UITextField!
	@IBOutlet weak var operatorPickerView: UIPickerView!
	@IBOutlet weak var resultButton: UIButton!
	@IBOutlet weak var resultLabel: UILabel!
	
	// MARK: Life cycle of Main View
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		firstOperandTextField.delegate = self
		secondOperandTextField.delegate = self
		operatorPickerView.delegate = self
		operatorPickerView.dataSource = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		resultButton.isEnabled = false
		resultLabel.isHidden = true
	}

	// MARK: TextField Delegate Methods
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		
		let oldText = textField.text! as NSString
		let newText = oldText.replacingCharacters(in: range, with: string)
		
		let digits = CharacterSet.decimalDigits
		var result = ""
		
		// Check whether the text is a decimal value or not
		for character in newText.unicodeScalars {
			if digits.contains(character) {
				result += String(character)
			}
		}
		
		if result == "" {
			self.configureUI(false)
		}
		
		if (result as NSString).length <= 9 {
			let resultAsInt = Int(result) ?? 0
			
			if textField == firstOperandTextField {
				firstOperand = resultAsInt
			} else {
				secondOperand = resultAsInt
			}
			
			textField.text = resultAsInt.formatted
		}
		
		return false
	}
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		activeTextField = textField
		return true
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		
		if didUserSetsAllValues() {
			self.configureUI(true)
		} else {
			self.configureUI(false)
		}
		
		return true
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		activeTextField = nil
	}
	
	// MARK: PickerView Data Source Methods
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return pickerViewTitles.count
	}
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	// MARK: PickerView Delegate Methods
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		
		self.view.endEditing(true)
		
		switch row {
		case 1:
			chosenOperator = "+"
			
		case 2:
			chosenOperator = "-"
			
		case 3:
			chosenOperator = "*"
			
		case 4:
			chosenOperator = "/"
			
		default:
			chosenOperator = ""
		}
		
		if didUserSetsAllValues() {
			self.configureUI(true)
		} else {
			self.configureUI(false)
		}
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return pickerViewTitles[row]
	}
	
	// When users touch outside of the TextField
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
		
		if didUserSetsAllValues() {
			self.configureUI(true)
		} else {
			self.configureUI(false)
		}
	}
	
	// Check whether users set all values to calculate
	func didUserSetsAllValues() -> Bool {
		return !((firstOperandTextField.text!.isEmpty)) && !((secondOperandTextField.text!.isEmpty)) && chosenOperator != ""
	}
	
	// Configure UI
	func configureUI(_ flag: Bool) {
		if flag {
			self.resultButton.isEnabled = true
		
		} else {
			self.resultButton.isEnabled = false
			self.resultLabel.isHidden = true
		}
	}
	
	// MARK: Get the Result Action
	
	@IBAction func getResultAction(_ sender: Any) {
		resultLabel.textColor = UIColor.black
		
		switch chosenOperator {
		case "+":
			resultLabel.text = (firstOperand + secondOperand).formatted
			
		case "-":
			resultLabel.text = (firstOperand - secondOperand).formatted
			
		case "*":
			resultLabel.text = (firstOperand * secondOperand).formatted
			
		default:
			if secondOperand != 0 {
				resultLabel.text = (Double(firstOperand) / Double(secondOperand)).formatted
			} else  {
				resultLabel.text = "Error: Cannot divide by zero"
				resultLabel.textColor = UIColor.red
			}
		}
		
		self.resultLabel.isHidden = false
	}
	
}

extension Integer {
	var formatted: String {
		return Number.formatterWithSeperator.string(from: self as! NSNumber) ?? ""
	}
}

extension Double {
	var formatted: String {
		return Number.formatterWithSeperator.string(from: self as NSNumber) ?? ""
	}
}
