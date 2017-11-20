//
//  SimpleExtensions.swift
//
//  Created by Alen Peter on 11/02/17.
//  Copyright © 2017 Alen Peter. All rights reserved.
//

import UIKit


public extension UIImageView
{
    // to make an imageview circular:
    func makeCircle(borderWidth: CGFloat = 2, borderColor: UIColor = UIColor.black)
    {
        self.layer.cornerRadius = self.frame.height/2
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
}
public extension UIView
{
    // to set background image for a view:
    func setBackground(_ imageName: String)
    {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(named: "\(imageName)")
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        self.addSubview(imageViewBackground)
        self.sendSubview(toBack: imageViewBackground)
    }
    
    func shake(color: UIColor? = nil, height: CGFloat? = nil , duration: Double = 0.08, additionalViewToChangeColor: UIView? = nil)
    {
        self.superview?.isUserInteractionEnabled = false
        let additionalViewColor = additionalViewToChangeColor?.backgroundColor
        let originalColor = self.backgroundColor
        let originalHeight = self.frame.size.height
        let originalCenterX = self.center.x
        
        self.backgroundColor = color != nil ? color : originalColor
        UIView.animate(withDuration: 0.5) {
            additionalViewToChangeColor?.backgroundColor = color != nil ? color : originalColor
        }
        
        self.frame.size.height = (height != nil ? height : self.frame.size.height + 2)!
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut, .autoreverse], animations: {
        self.center.x = originalCenterX + 4
        }) { (true) in
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut, .autoreverse], animations: {
        self.center.x = originalCenterX - 7
        }) { (true) in
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut, .autoreverse], animations: {
        self.center.x = originalCenterX + 6
        }) { (true) in
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut, .autoreverse], animations: {
        self.center.x = originalCenterX - 5
        }) { (true) in
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut, .autoreverse], animations: {
        self.center.x = originalCenterX
        }) { (true) in
        self.frame.size.height = originalHeight
        self.backgroundColor = originalColor
        UIView.animate(withDuration: 0.5) {
        additionalViewToChangeColor?.backgroundColor = additionalViewColor
        }
        self.superview?.isUserInteractionEnabled = true }}}}}
    }
    
    func addDashedBorder(color: UIColor)
    {
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func addShadow(color: UIColor, opacity: Float, radius: CGFloat, offset: CGSize)
    {
        let view = self
        view.layer.shadowColor = color.cgColor
        view.layer.shadowOffset = offset
        view.layer.shadowOpacity = opacity
        view.layer.shadowRadius = radius
        view.layer.masksToBounds = false
    }
    
    func makeCapsuleShape(color : UIColor)
    {
        let view = self
        let layer = view.layer
        layer.borderWidth = 0.5
        layer.borderColor = color.cgColor
        layer.cornerRadius = layer.frame.size.height/2
        
    }
    
    func makeViewCircle()
    {
        let view = self
        let layer = view.layer
        layer.cornerRadius = layer.frame.size.height/2
        layer.masksToBounds = true
        
    }
    
    func makeShadowWithColor(color : UIColor)
    {
        let view = self
        view.layer.shadowColor = color.cgColor;
        view.layer.shadowOffset = CGSize(width: 5, height: -5);
        view.layer.shadowOpacity = 1;
        view.layer.shadowRadius = 25.0;
    }
    
    func makeRoundedCorner(color : UIColor, radius : CGFloat)
    {
        let view = self
        view.layer.cornerRadius = radius
        view.layer.borderWidth = 1.0
        view.layer.borderColor = color.cgColor
        view.clipsToBounds = true
    }
}
public extension UILabel
{
    func glow(stopAfter: Double? = 2)
    {
        let labelTransparency :CGFloat = 0.1
        let labelWidth:CGFloat = self.frame.size.width
        
        let glowSize :CGFloat = 40 / labelWidth
        
        let startingLocations :NSArray = [NSNumber.init(value:0.0), NSNumber.init(value:((Float)(glowSize / 2))),NSNumber.init(value:((Float)(glowSize)/1))]
        
        let endingLocations = [(1.0 - glowSize), (1.0 - (glowSize / 2)), 1.0] as NSArray
        
        let animation :CABasicAnimation = CABasicAnimation(keyPath: "locations")
        let glowMask:CAGradientLayer = CAGradientLayer.init()
        glowMask.frame = self.bounds
        
        let gradient = UIColor.init(white: 0.5, alpha: labelTransparency)
        glowMask.colors =  [gradient.cgColor,UIColor.white.cgColor,gradient.cgColor]
        glowMask.locations = startingLocations as? [NSNumber]
        glowMask.startPoint = CGPoint(x: 0 - (glowSize * 2), y: 1)
        glowMask.endPoint = CGPoint(x: 1 + glowSize, y: 1)
        self.layer.mask = glowMask
        
        animation.fromValue = startingLocations
        animation.toValue = endingLocations
        animation.repeatCount = Float.infinity
        animation.duration = 1
        animation.isRemovedOnCompletion = false
        glowMask.add(animation, forKey: "gradientAnimation")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + stopAfter!)
        {
            glowMask.removeAllAnimations()
            self.layer.mask = nil
        }
    }
    
    func setLineHeight(lineHeight: CGFloat, lineSpacing: CGFloat)
    {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = self.textAlignment
        
        let attrString = NSMutableAttributedString(string: self.text!)
        attrString.addAttribute(NSFontAttributeName, value: self.font, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
}

public extension UITextField
{
    
    func trimmedText() -> String
    {
        if self.text != ""
        {
            let currentText = self.text
            let trimmedText = currentText?.replacingOccurrences(of: " ", with: "")
            return trimmedText!
        }
        else
        {
            return ""
        }
    }
}

public extension String
{
    //Convert Hex String to UIColor
    func hexStringToUIColor () -> UIColor
    {
        let hex = self
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#"))
        {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6)
        {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

public extension Double
{
    // Rounds the double to decimal places value
    func roundTo(places:Int) -> Double
    {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


