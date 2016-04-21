import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
  @IBOutlet var celciusLabel: UILabel!
  @IBOutlet var textField: UITextField!
  
  var fahrenheitValue: Double? {
    didSet {
      updateCelciusLabel()
    }
  }
  
  var celciusValue: Double? {
    guard let fahrenheitValue = fahrenheitValue else {
      return nil
    }
    
    return (fahrenheitValue - 32) * (5/9)
  }
  
  let numberFormatter: NSNumberFormatter = {
    let nf = NSNumberFormatter()
    nf.numberStyle = .DecimalStyle
    nf.minimumFractionDigits = 0
    nf.maximumFractionDigits = 1
    return nf
  }()
  
  @IBAction func fahrenheitFieldEditingChanged(textField: UITextField) {
    guard let text = textField.text, value = Double(text) else {
      fahrenheitValue = nil
      return
    }
    
    fahrenheitValue = value
  }
  
  @IBAction func dismissKeyboard(sender: AnyObject) {
    textField.resignFirstResponder()
  }
  
  func updateCelciusLabel() {
    guard let celciusValue = celciusValue else {
      celciusLabel.text = "???"
      return
    }
    
    celciusLabel.text = numberFormatter.stringFromNumber(celciusValue)
  }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    let currentTextHasDecimal = {
        textField.text?.rangeOfString(".") != nil
    }()
    
    let replacementTextHasDecimal = {
      string.rangeOfString(".") != nil
    }()
    
    let isDecimalOk = !(currentTextHasDecimal && replacementTextHasDecimal)
    
    let hasAlphaChars = {
      string.rangeOfCharacterFromSet(NSCharacterSet.letterCharacterSet()) != nil
    }()
    
    return isDecimalOk && !hasAlphaChars
  }
}