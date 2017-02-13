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
    func makeCircle()
    {
        self.layer.cornerRadius = self.frame.height/2
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
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
}
