//
//  CurrencyExchangeViewController.swift
//  Freddy
//
//  Created by Sonam Dhingra on 12/7/15.
//  Copyright © 2015 Sonam Dhingra. All rights reserved.
//

import UIKit
import MBProgressHUD

class CurrencyExchangeViewController: UIViewController, UITextFieldDelegate, UIToolbarDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var usdAmountTextField: AmountTextField!
    @IBOutlet weak var usdStaticLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var gbpButton: CurrencyButton!
    @IBOutlet weak var eurButton: CurrencyButton!
    @IBOutlet weak var jpyButton: CurrencyButton!
    @IBOutlet weak var brlButton: CurrencyButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var freddyLaunchImageView: UIImageView!
    
    let toolBarHeight:CGFloat = 50
    var dollarAmount:String = "0"
    var currencyButtons = [CurrencyButton]()
    var selectedCurrencySymbol:CurrencyExchangeService.CurrencySymbols?
    
    lazy var numberformatter = NSNumberFormatter()
    var imageViewFrames = [CGImage]()
    
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        launchAnimation()
        currencyButtons = [gbpButton, eurButton, jpyButton, brlButton]
    }
    
    
    //MARK: Launch Animation
    
    func launchAnimation() {
        containerView.alpha = 0
        
        for i in 1...111 {
            if let image = UIImage(named: "FreddyLaunch\(i)")?.CGImage {
                imageViewFrames.append(image)
            }
        }

        let anim = CAKeyframeAnimation(keyPath: "contents")
        anim.values = imageViewFrames
        anim.duration = 3.0
        anim.repeatCount = 1
        anim.delegate = self
        freddyLaunchImageView.layer.addAnimation(anim, forKey: "animation")
    }
    
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        UIView.animateWithDuration(0.7, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.containerView.alpha = 1.0
            }) { (finished) -> Void in
                self.createToolBar()
                self.usdAmountTextField.becomeFirstResponder()
        }
    }
    
    //MARK: Setup
    
    func createToolBar() {
        let toolBar = UIToolbar(frame: CGRectMake(0, 0, CGRectGetWidth(view.frame), toolBarHeight))
        toolBar.backgroundColor = UIColor.seaGlassBlue()
        toolBar.userInteractionEnabled = true
        let doneBtn = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: Selector("doneSelected"))
        let flexibleSpaceBtn = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        toolBar.items = [flexibleSpaceBtn, flexibleSpaceBtn, doneBtn]
        toolBar.delegate = self
        usdAmountTextField.inputAccessoryView = toolBar
    }
    
    
    func doneSelected() {
        usdAmountTextField.resignFirstResponder()
        if let usdAmount = usdAmountTextField.text {
            dollarAmount = usdAmount
        }
    }
    
  
    //MARK: Button Actions
    
    @IBAction func gbpButtonSelected(sender: AnyObject) {
        convertCurrencyTo(CurrencyExchangeService.CurrencySymbols.GBP)
    }
    
    @IBAction func eurButtonSelected(sender: AnyObject) {
        convertCurrencyTo(CurrencyExchangeService.CurrencySymbols.EUR)
    }
    
    @IBAction func jpyButtonSelected(sender: AnyObject) {
        convertCurrencyTo(CurrencyExchangeService.CurrencySymbols.JPY)
    }
    
    @IBAction func brlButtonSelected(sender: AnyObject) {
        convertCurrencyTo(CurrencyExchangeService.CurrencySymbols.BRL)
    }
    
    
    //MARK: Data handling
    
    func convertCurrencyTo(symbol:CurrencyExchangeService.CurrencySymbols) {
        if usdAmountTextField.text?.isEmpty == false {
            selectedCurrencySymbol = symbol
            guard let usdIntValue = Int(usdAmountTextField.text!) else {
                return
            }
            
            //Begin Request
            
            let hud = MBProgressHUD(frame: CGRectMake(CGRectGetWidth(view.frame)/2, CGRectGetHeight(view.frame)/2, 40, 40))
            view.addSubview(hud)
            hud.show(true)
            CurrencyExchangeService.sharedService.convertUSDAmount(usdIntValue, toCurrencySymbol: symbol, completionClosure: { [unowned self] (response) -> () in
                
                if let info = response.data as? [String : AnyObject],
                    let rate = info["rate"] as? NSNumber {
                    self.calculateResultsFromExchangeRate(rate)
                } else {
                    //Handle error
                }
                hud.hide(true)
            })
        }
    }
    
    func calculateResultsFromExchangeRate(exchangeRate:NSNumber) {
        if usdAmountTextField.text?.isEmpty == false {
            guard let usdIntValue = Int(usdAmountTextField.text!) else {
                return
            }
            
            let calculatedAmount =  Double(usdIntValue) * Double(exchangeRate)
            numberformatter.maximumFractionDigits = 2
            if let finalAmount = numberformatter.stringFromNumber(NSNumber(double: calculatedAmount)),
             let selectedSymbol = selectedCurrencySymbol?.rawValue {
                resultLabel.text = "\(finalAmount) \(selectedSymbol)"
            }
        }
    }

}