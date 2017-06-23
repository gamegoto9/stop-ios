//
//  TableForwortUIView.swift
//  mcr-team
//
//  Created by LIKIT on 4/2/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//

import UIKit

class TableForwortUIView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0.0
    @IBInspectable var borderColor: UIColor = UIColor.black
    @IBInspectable var borderWidth: CGFloat = 0.5
    private var customBackgroundColor = UIColor.white
    override var backgroundColor: UIColor?{
        didSet {
            customBackgroundColor = backgroundColor!
            super.backgroundColor = UIColor.clear
        }
    }
    
    func setup() {
        layer.shadowColor = UIColor.black.cgColor;
        layer.shadowOffset = CGSize.zero;
        layer.shadowRadius = 5.0;
        layer.shadowOpacity = 0.5;
        super.backgroundColor = UIColor.clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override func draw(_ rect: CGRect) {
        customBackgroundColor.setFill()
        UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius ?? 0).fill()
        
        let borderRect = bounds.insetBy(dx: borderWidth/2, dy: borderWidth/2)
        let borderPath = UIBezierPath(roundedRect: borderRect, cornerRadius: cornerRadius - borderWidth/2)
        borderColor.setStroke()
        borderPath.lineWidth = borderWidth
        borderPath.stroke()
        
        // whatever else you need drawn
    }

}



