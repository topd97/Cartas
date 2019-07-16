//
//  PlayCardView.swift
//  MakingCard
//
//  Created by Thiago Outeiro Pereira Damasceno on 12/07/19.
//  Copyright © 2019 Thiago Outeiro Pereira Damasceno. All rights reserved.
//

import UIKit

@IBDesignable
class PlayCardView: UIView {
    
    @IBInspectable
    var rank: Int = 1 { didSet { setNeedsDisplay(); setNeedsLayout()}}
    @IBInspectable
    var suit: String = "♠️" { didSet { setNeedsDisplay(); setNeedsLayout()}}
    @IBInspectable
    var isfacedUp: Bool = true { didSet { setNeedsDisplay(); setNeedsLayout()}}
    
    private var cornerString: NSAttributedString {
        
        return centeredAttributedString(rankString + "\n" + suit, fontSize: cornerFontSize)
    }
    
    private lazy var upperLeftCornerLabel = createLabel()
    private lazy var lowerRightCornerLabel = createLabel()
    
    var faceCardScale: CGFloat = SizeRatio.faceCardImageSizeToBoundsSize {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @objc func adjustFaceCardScale(byHandlingGestureRecognizedBy recognizer: UIPinchGestureRecognizer){
        switch recognizer.state {
        case .changed, .ended:
            faceCardScale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    private func createLabel() -> UILabel{
        let label = UILabel()
        label.numberOfLines = 0
        addSubview(label)
        return label
    }

    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString{
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.paragraphStyle: paragraphStyle, .font: font])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    private func configureGeneralLabel(_ label: UILabel, text: NSAttributedString, isFacedUp: Bool){
        label.attributedText = text
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !isFacedUp
    }
    
   
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureGeneralLabel(upperLeftCornerLabel, text: cornerString, isFacedUp: self.isfacedUp)
        configureGeneralLabel(lowerRightCornerLabel,text: cornerString, isFacedUp: self.isfacedUp)
        upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        lowerRightCornerLabel.frame.origin = bounds.origin.offsetBy(dx: bounds.size.width - lowerRightCornerLabel.frame.size.width - cornerOffset , dy: bounds.size.height - lowerRightCornerLabel.frame.size.height - cornerOffset)
        
        lowerRightCornerLabel.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi)
    }
    
    func getStringHeight(_ string: NSAttributedString) -> CGFloat{
        let constraintRect = CGSize(width: frame.width, height: .greatestFiniteMagnitude)
        let boundingBox = string.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            context: nil)
        return boundingBox.height
    }
    
    func drawPips(){
        let pipsPerRow = [[0],[1],[1,1],[1,1,1],[2,2],[2,1,2],[2,2,2],[2,1,2,2],[2,2,2,2],[2,2,1,2,2],[2,2,2,2,2]]
        
        let frame = bounds.zoom(by: faceCardScale)
        
        let formation = pipsPerRow[rank]
        let rowCount = formation.count
        let rowHeight:CGFloat = frame.height / CGFloat(rowCount)
        var actualY: CGFloat = CGFloat(0)
        
        for quant in formation{
            let pips = centeredAttributedString(suit, fontSize: cornerFontSize)
            let stringHeight = getStringHeight(pips)
            let centerY = (rowHeight - stringHeight)/2
            
            switch quant{
            case 1:
                let rectToLabel = CGRect(x: frame.minX, y: frame.minY + centerY + actualY, width: frame.width, height: stringHeight)
                pips.draw(in: rectToLabel)
            case 2:
                let rectToLabelLeft = CGRect(x: frame.minX, y: frame.minY + centerY + actualY, width: frame.width/2, height: stringHeight)
                let rectToLabelRight = CGRect(x: frame.minX + frame.width/2 , y: frame.minY + centerY + actualY, width: frame.width/2, height: stringHeight)
                pips.draw(in: rectToLabelLeft)
                pips.draw(in: rectToLabelRight)
            default:
                return
            }
            actualY += rowHeight
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let roundedRect = UIBezierPath.init(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        if isfacedUp{
            if rank>10{
                UIImage(named:"faces", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection)?.draw(in: bounds.zoom(by: faceCardScale))
                
            } else{
                drawPips()
            }
        } else {
            UIImage(named: "backCard", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection)?.draw(in: bounds)
        }
    }
    
    
}

extension PlayCardView{
    private struct SizeRatio{
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCoernerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    private var cornerRadius: CGFloat{
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    private var cornerOffset: CGFloat{
        return cornerRadius * SizeRatio.cornerOffsetToCoernerRadius
    }
    private var cornerFontSize: CGFloat{
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    private var rankString: String{
        switch rank {
        case 1: return "A"
        case 2...10: return String(rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }
}

extension CGRect{
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height/2)
    }
    var rightHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height/2)
    }
    
    func zoom (by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        
        return insetBy(dx: (width - newWidth)/2, dy: (height - newHeight)/2)
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint{
        return CGPoint(x: x+dx, y: y+dy)
    }
}
