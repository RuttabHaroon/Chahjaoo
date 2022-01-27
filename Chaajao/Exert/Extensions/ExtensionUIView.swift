import UIKit

extension UIView {
	func constraintsForAnchoringTo(boundsOf view: UIView) -> [NSLayoutConstraint] {
		return [
			topAnchor.constraint(equalTo: view.topAnchor),
			leadingAnchor.constraint(equalTo: view.leadingAnchor),
			view.bottomAnchor.constraint(equalTo: bottomAnchor),
			view.trailingAnchor.constraint(equalTo: trailingAnchor)
		]
	}
	
    func setupHexagonView() {
           let lineWidth: CGFloat = 0
           let path = self.roundedPolygonPath(rect: self.bounds, lineWidth: lineWidth, sides: 6, cornerRadius: 0, rotationOffset: CGFloat(Double.pi / 2.0))
           
           let mask = CAShapeLayer()
           mask.path = path.cgPath
           mask.lineWidth = lineWidth
           mask.strokeColor = UIColor.clear.cgColor
           mask.fillColor = UIColor.white.cgColor
           self.layer.mask = mask
           
           let border = CAShapeLayer()
           border.path = path.cgPath
           border.lineWidth = lineWidth
           border.strokeColor = UIColor.clear.cgColor
           border.fillColor = UIColor.clear.cgColor
           self.layer.addSublayer(border)
       }
       
       internal func roundedPolygonPath(rect: CGRect, lineWidth: CGFloat, sides: NSInteger, cornerRadius: CGFloat, rotationOffset: CGFloat = 0)
           -> UIBezierPath {
               let path = UIBezierPath()
               let theta: CGFloat = CGFloat(2.0 * Double.pi) / CGFloat(sides) // How much to turn at every corner
               let _: CGFloat = cornerRadius * tan(theta / 2.0)     // Offset from which to start rounding corners
               let width = min(rect.size.width, rect.size.height)        // Width of the square
               
               let center = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + width / 2.0)
               
               // Radius of the circle that encircles the polygon
               // Notice that the radius is adjusted for the corners, that way the largest outer
               // dimension of the resulting shape is always exactly the width - linewidth
               let radius = (width - lineWidth + cornerRadius - (cos(theta) * cornerRadius)) / 2.0
               
               // Start drawing at a point, which by default is at the right hand edge
               // but can be offset
               var angle = CGFloat(rotationOffset)
               
               let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
               path.move(to: CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta)))
               
               for _ in 0 ..< sides {
                   angle += theta
                   
                   let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
                   let tip = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
                   let start = CGPoint(x: corner.x + cornerRadius * cos(angle - theta), y: corner.y + cornerRadius * sin(angle - theta))
                   let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))
                   
                   path.addLine(to: start)
                   path.addQuadCurve(to: end, controlPoint: tip)
               }
               
               path.close()
               
               // Move the path to the correct origins
               let bounds = path.bounds
               let transform = CGAffineTransform(translationX: -bounds.origin.x + rect.origin.x + lineWidth / 2.0,
                                                 y: -bounds.origin.y + rect.origin.y + lineWidth / 2.0)
               path.apply(transform)
               
               return path
       }
    
    
    /// Rotate a view by specified degrees in CGFloat
    var rotation:CGFloat {
        get {
            let radians:CGFloat = atan2(self.transform.b, self.transform.a)
            let degrees:CGFloat = radians * (180.0 / CGFloat(Double.pi))
            return degrees;
        }
        
        set {
            let radians = newValue / 180.0 * CGFloat(Double.pi)
            let rotation = self.transform.rotated(by: radians);
            self.transform = rotation
        }
    } //P.E.
    
    /// Loads nib from Bundle
    ///
    /// - Parameters:
    ///   - nibName: Nib Name
    ///   - viewIndex: View Index
    ///   - owner: Nib Owner AnyObject
    /// - Returns: UIView
    class func loadWithNib(_ nibName:String, viewIndex:Int, owner: AnyObject) -> Any {
        return Bundle.main.loadNibNamed(nibName, owner: owner, options: nil)![viewIndex];
    } //F.E.
    
    /// Loads dynamic nib from Bundle
    ///
    /// - Parameters:
    ///   - nibName: Nib Name
    ///   - viewIndex: View Index
    ///   - owner: Nib Owner AnyObject
    /// - Returns: UIView
    func loadDynamicViewWithNib(_ nibName:String, viewIndex:Int, owner: AnyObject) -> Any {
        
        let bundle = Bundle(for: type(of: owner));
        let nib = UINib(nibName: nibName, bundle: bundle);
        
        let rView: Any = nib.instantiate(withOwner: owner, options: nil)[viewIndex];
        return rView;
    } //F.E.
    
    /// Adds Boarder for the View
    ///
    /// - Parameters:
    ///   - color: Border Color
    ///   - width: Border Width
    func addBorder(_ color:UIColor?, width:Int){
        let layer:CALayer = self.layer;
        layer.borderColor = color?.cgColor
        layer.borderWidth = (CGFloat(width)/CGFloat(2)) as CGFloat
    } //F.E.
    
    func addBorderWidth(width:CGFloat){
        let layer:CALayer = self.layer;
        layer.borderWidth = width
    } //F.E.
    
    func addBordeColor(color:UIColor?){
        let layer:CALayer = self.layer;
        layer.borderColor = color?.cgColor
    } //F.E.
    
    /// Makes Rounded corners of View. it trims the view in circle
    func addRoundedCorners() {
        self.addRoundedCorners(self.frame.size.width/2.0);
    } //F.E.
    
    /// Adds rounded corner with defined radius
    ///
    /// - Parameter radius: Radius Value
    func addRoundedCorners(_ radius:CGFloat) {
        let layer:CALayer = self.layer;
        layer.cornerRadius = radius
    } //F.E.
    
    /// Adds Drop shadow on the view
    func addDropShadow() {
        let shadowPath:UIBezierPath=UIBezierPath(rect: self.bounds)
        let layer:CALayer = self.layer;
        layer.shadowColor = UIColor.black.cgColor;
        layer.shadowOffset = CGSize(width: 1, height: 1);
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 1.0
        layer.shadowPath = shadowPath.cgPath
        layer.masksToBounds = false;
    } //F.E.
    
    func addShadowColor(shadowColor: UIColor?) {
        let layer:CALayer = self.layer;
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
    }
    func addShadowOpacity(shadowOpacity: Float) {
        let layer:CALayer = self.layer;
        layer.shadowOpacity = shadowOpacity
    }
    func addShadowOffset(shadowOffset: CGSize) {
        let layer:CALayer = self.layer;
        layer.shadowOffset = shadowOffset
    }
    /// Shows view with fadeIn animation
    func fadeIn(duration:Double) {
        self.alpha=0.0;
        self.isHidden = false;
        UIView.animate(withDuration:duration, animations: { () -> Void in
            self.alpha=1.0;
        })
    } //F.E.
    
    // Hides view with fadeOut animation
    func fadeOut(duration:Double,completion:((_ finished:Bool)->())?) {
        self.alpha = 1.0
        UIView.animate(withDuration:duration, animations: { () -> Void in
            self.alpha=0.0;
            }, completion: { (finish:Bool) -> Void in
                self.isHidden = true;
                completion?(finish)
        }) 
    } //F.E.
    
    /// Shakes view in a static animation
    func shake() {
        let shake:CABasicAnimation = CABasicAnimation(keyPath: "position");
        shake.duration = 0.1;
        shake.repeatCount = 2;
        shake.autoreverses = true;
        shake.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 5, y: self.center.y));
        shake.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 5, y: self.center.y));
        self.layer.add(shake, forKey: "position");
    } //F.E.
    
    /// Removes all views from the view
    func removeAllSubviews() {
        for view in self.subviews {
            view.removeFromSuperview();
        }
    } //F.E.
    
} //E.E.

extension UIView {

	func takeScreenshot() -> UIImage {

		// Begin context
		UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)

		// Draw view in that context
		drawHierarchy(in: self.bounds, afterScreenUpdates: true)

		// And finally, get image
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		if (image != nil)
		{
			return image!
		}
		return UIImage()
	}
}


