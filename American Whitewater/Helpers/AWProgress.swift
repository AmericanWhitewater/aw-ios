import UIKit

// A simple progress view typically used for showing
// activity while waiting for posting content, or waiting
// on activity from the server.

// Singleton class that can be called at any time
// Usage: AWProgress.shared.show() or AWProgress.shared.hide()
//        AWProgress.shared.hideWith(completion:) available if needed
class AWProgress {
    
    static let shared = AWProgress()
    
    var progressView = AWProgressView();
    
    // setup proper singleton
    private init() {}
       
    
    func show() {
        progressView.showProgress();
    }
    
    func hide() {
        progressView.hideWith(completion: nil)
    }
    
    func hideWith(completion: @escaping ()->()) {
        progressView.hideWith(completion: completion)
    }
    
}

class AWProgressView: UIView {
    
    //MARK: - DeviceType and ScreenSize
    //MARK: -
    struct ScreenSize  {
        static let Width         = UIScreen.main.bounds.size.width
        static let Height        = UIScreen.main.bounds.size.height
        static let Max_Length    = max(ScreenSize.Width, ScreenSize.Height)
        static let Min_Length    = min(ScreenSize.Width, ScreenSize.Height)
    }
    
    struct DeviceType {
        static let iPhone4  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.Max_Length < 568.0
        static let iPhone5_5s  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.Max_Length == 568.0
        static let iPhone6_6s_7 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.Max_Length == 667.0
        static let iPhone6P_6sP_7P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.Max_Length == 736.0
        static let iPhoneX = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.Max_Length == 812.0
        static let iPad = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.Max_Length == 1024.0
    }
    
    //MARK: - Private Properties
    //MARK: -
    
    // New Progress View
    private var progressBackView = UIView()
    public var progressBackColor: UIColor? = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
    
    private var floatingProgressWidth : CGFloat {
        
        var width = CGFloat()
        if DeviceType.iPhone4 || DeviceType.iPhone5_5s{
            width = ScreenSize.Min_Length*0.3
        }else if DeviceType.iPhone6_6s_7 || DeviceType.iPhone6P_6sP_7P || DeviceType.iPhoneX{
            width = ScreenSize.Min_Length*0.35
        }else if DeviceType.iPad{
            width = ScreenSize.Min_Length*0.25
        }
        return width
    }

    
    private var objProgressView = UIView()
    
    private var shapeLayer = CAShapeLayer()
    private var widthProgressView : CGFloat {
        
        var width = CGFloat()
        if DeviceType.iPhone4 || DeviceType.iPhone5_5s{
            width = ScreenSize.Min_Length*0.2
        }else if DeviceType.iPhone6_6s_7 || DeviceType.iPhone6P_6sP_7P || DeviceType.iPhoneX{
            width = ScreenSize.Min_Length*0.25
        }else if DeviceType.iPad{
            width = ScreenSize.Min_Length*0.15
        }
        return width
    }
    
    //MARK: - Private Properties
    //MARK: -
    // Pass your image here which will be used for progressView
    public var imgLogo: UIImage = UIImage(named:"awLogoLetter")!
    
    // Pass your color here which will be used as layer color
    public var firstColor: UIColor? = UIColor(webHex: 0x007CB3)
    
    // Add second and third colour if you want layer to have multiple colors. It will show animated colors on progressView layer
    public var secondColor: UIColor? = UIColor(webHex: 0x007CB3)
    public var thirdColor: UIColor? = UIColor(webHex: 0x007CB3)
    
    // Use this to set the speed of progressView
    public var duration: CGFloat = 5.0
    
    // Use this to set the line width of layer
    public var lineWidth: CGFloat = 4.0
    
    // Change background color of progressView
    public var bgColor = UIColor.clear
    
    // Returns bool for animating status of progressView
    public var isAnimating : Bool?
    
    //MARK: - AJProgressViewSetup Private Functions
    //MARK: -
    private func setupAJProgressView(isProgressView: Bool = false) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if (appDelegate.window?.subviews.contains(objProgressView))! {
            appDelegate.window?.bringSubviewToFront(objProgressView)
            //print("already there")
        }else{
            
            appDelegate.window?.addSubview(objProgressView)
            appDelegate.window?.bringSubviewToFront(objProgressView)
        }
        objProgressView.backgroundColor = bgColor
        objProgressView.frame = UIScreen.main.bounds
        objProgressView.layer.zPosition = 1
        
        // Add Progress Background View
        if isProgressView {
            progressBackView.backgroundColor = progressBackColor
            progressBackView.frame = CGRect(x: (ScreenSize.Width - floatingProgressWidth)/2, y: (ScreenSize.Height - floatingProgressWidth)/2, width: floatingProgressWidth, height: floatingProgressWidth)
            progressBackView.layer.zPosition = -5 // put it on top of everything
            progressBackView.layer.cornerRadius = 15
            progressBackView.layer.masksToBounds = true
            progressBackView.layer.borderColor = UIColor(webHex: 0x161616).cgColor //UIColor.darkGray.cgColor
            progressBackView.layer.borderWidth = 1
            
            //bgColor = UIColor.clear
            bgColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.35)
            self.addSubview(progressBackView)
        }
        
        self.backgroundColor = bgColor
        self.frame = UIScreen.main.bounds
        
        let innerView = UIView()
        innerView.frame = CGRect(x: (ScreenSize.Width - widthProgressView)/2, y: (ScreenSize.Height - widthProgressView)/2, width: widthProgressView, height: widthProgressView)
        innerView.backgroundColor = UIColor.clear
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = firstColor?.cgColor
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = 1
        shapeLayer.lineWidth = lineWidth
        
        let center = CGPoint(x: innerView.bounds.size.width / 2.0, y: innerView.bounds.size.height / 2.0)
        let radius = min(innerView.bounds.size.width, innerView.bounds.size.height)/2.0 - self.shapeLayer.lineWidth / 2.0
        let bezierPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.frame = innerView.bounds
        innerView.layer.addSublayer(shapeLayer)
        self.addSubview(innerView)
        
        let imgViewLogo = UIImageView()
        imgViewLogo.image = imgLogo
        imgViewLogo.contentMode = .scaleAspectFit
        imgViewLogo.backgroundColor = UIColor.clear
        imgViewLogo.clipsToBounds = true
        imgViewLogo.frame = CGRect(x: 0, y: 0, width: widthProgressView * 0.6, height: widthProgressView * 0.6)
        self.addSubview(imgViewLogo)
        
        imgViewLogo.center = innerView.center
        objProgressView.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        objProgressView.translatesAutoresizingMaskIntoConstraints = false
        
        let xConstraint = NSLayoutConstraint(item: objProgressView, attribute: .centerX, relatedBy: .equal, toItem: appDelegate.window!, attribute: .centerX, multiplier: 1, constant: 0)
        
        let yConstraint = NSLayoutConstraint(item: objProgressView, attribute: .centerY, relatedBy: .equal, toItem: appDelegate.window!, attribute: .centerY, multiplier: 1, constant: 0)
        
        appDelegate.window?.addConstraint(xConstraint)
        appDelegate.window?.addConstraint(yConstraint)
        
        self.centerXAnchor.constraint(equalTo: objProgressView.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: objProgressView.centerYAnchor).isActive = true
        self.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        self.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
    }
    
    private func animateStrokeEnd() -> CABasicAnimation {
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.beginTime = 0
        animation.duration = CFTimeInterval(duration / 2.0)
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        return animation
    }
    
    private func animateStrokeStart() -> CABasicAnimation {
        
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.beginTime = CFTimeInterval(duration / 2.0)
        animation.duration = CFTimeInterval(duration / 2.0)
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        return animation
    }
    
    private func animateRotation() -> CABasicAnimation {
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = Float.infinity
        
        return animation
    }
    
    private func animateColors() -> CAKeyframeAnimation {
        
        let colors = configureColors()
        let animation = CAKeyframeAnimation(keyPath: "strokeColor")
        animation.duration = CFTimeInterval(duration)
        animation.keyTimes = configureKeyTimes(colors: colors)
        animation.values = colors
        animation.repeatCount = Float.infinity
        return animation
    }
    
    private func animateGroup() {
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [animateStrokeEnd(), animateStrokeStart(), animateRotation(), animateColors()]
        animationGroup.duration = CFTimeInterval(duration)
        animationGroup.fillMode = CAMediaTimingFillMode.both
        animationGroup.isRemovedOnCompletion = false
        animationGroup.repeatCount = Float.infinity
        shapeLayer.add(animationGroup, forKey: "loading")
    }
    
    private func startAnimating() {
        isAnimating = true
        animateGroup()
    }
    
    private func stopAnimating() {
        isAnimating = false
        shapeLayer.removeAllAnimations()
    }
    
    private func configureColors() -> [CGColor] {
        var colors = [CGColor]()
        colors.append((firstColor?.cgColor)!)
        if secondColor != nil { colors.append((secondColor?.cgColor)!) }
        if thirdColor != nil { colors.append((thirdColor?.cgColor)!) }
        
        return colors
    }
    
    private func configureKeyTimes(colors: [CGColor]) -> [NSNumber] {
        switch colors.count {
        case 1:
            return [0]
        case 2:
            return [0, 1]
        default:
            return [0, 0.5, 1]
        }
    }
    
    //MARK: - Public Functions
    //MARK: -
    public func show() {
        
        self.setupAJProgressView(isProgressView: false)
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.alpha = 1.0
            self.startAnimating()
            
        }, completion: {(finished: Bool) -> Void in })
    }

    public func showProgress() {
        
        self.setupAJProgressView(isProgressView: true)
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.alpha = 1.0
            self.startAnimating()
            
        }, completion: {(finished: Bool) -> Void in })
    }

    public func hideWith(completion: (()->Void)?) {
        
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.alpha = 0.0
        }, completion: {(finished: Bool) -> Void in
            self.stopAnimating()
            self.removeFromSuperview()
            //self.progressBackView.removeFromSuperview()
            
            if let completion = completion {
                completion()
            }
        })
    }
}
