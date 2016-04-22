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
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    let currentDate = NSDate()
    let calendar = NSCalendar.currentCalendar()
    let hour = calendar.component(.Hour, fromDate: currentDate)
    
    if hour > 12 {
      view.backgroundColor = UIColor.darkGrayColor()
    } else {
      view.backgroundColor = UIColor.lightGrayColor()
    }
  }
  
  @IBAction func fahrenheitFieldEditingChanged(textField: UITextField) {
    guard let text = textField.text, number = numberFormatter.numberFromString(text) else {
      fahrenheitValue = nil
      return
    }
    
    fahrenheitValue = number.doubleValue
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
    
    let currentLocale = NSLocale.currentLocale()
    let decimalSeparator = currentLocale.objectForKey(NSLocaleDecimalSeparator) as! String
    
    let currentTextHasDecimal = {
        textField.text?.rangeOfString(decimalSeparator) != nil
    }()
    
    let replacementTextHasDecimal = {
      string.rangeOfString(decimalSeparator) != nil
    }()
    
    let isDecimalOk = !(currentTextHasDecimal && replacementTextHasDecimal)
    
    let hasAlphaChars = {
      string.rangeOfCharacterFromSet(NSCharacterSet.letterCharacterSet()) != nil
    }()
    
    return isDecimalOk && !hasAlphaChars
  }
}