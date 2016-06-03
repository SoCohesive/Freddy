//
//  CurrencyExchangeService.swift
//  Freddy
//
//  Created by Sonam Dhingra on 12/7/15.
//  Copyright © 2015 Sonam Dhingra. All rights reserved.
//

import UIKit

@IBDesignable class CurrencyButton: UIButton {
  

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        self.backgroundColor = UIColor.seaGlassBlue()
        self.layer.cornerRadius = 12.0
    }
    

}

