//
//  CurrencyExchangeService.swift
//  Freddy
//
//  Created by Sonam Dhingra on 12/7/15.
//  Copyright © 2015 Sonam Dhingra. All rights reserved.
//

import UIKit

@IBDesignable class AmountTextField: UITextField {
  
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1.0
        self.tintColor = UIColor.seaGlassBlue()
        self.layer.borderColor = UIColor.seaGlassBlue().CGColor
        self.layer.cornerRadius = 12.0

    }
}
