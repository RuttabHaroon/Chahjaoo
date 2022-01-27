
import Foundation
import UIKit

extension UIImage {

	public convenience init?(bounds: CGRect, colors: [UIColor], orientation: GradientOrientation = .horizontal) {
		let gradientLayer = CAGradientLayer()
		gradientLayer.frame = bounds
		gradientLayer.colors = colors.map({ $0.cgColor })

		if orientation == .horizontal {
			gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5);
			gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5);
		}

		UIGraphicsBeginImageContext(gradientLayer.bounds.size)
		gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		guard let cgImage = image?.cgImage else { return nil }
		self.init(cgImage: cgImage)
	}
	
    func aspectFitImage(inRect rect: CGRect) -> UIImage? {
        let width = self.size.width
        let height = self.size.height
        let aspectWidth = rect.width / width
        let aspectHeight = rect.height / height
        let scaleFactor = aspectWidth > aspectHeight ? rect.size.height / height : rect.size.width / width

        UIGraphicsBeginImageContextWithOptions(CGSize(width: width * scaleFactor, height: height * scaleFactor), false, 0.0)
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: width * scaleFactor, height: height * scaleFactor))

        defer {
            UIGraphicsEndImageContext()
        }

        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)

        layer.render(in: UIGraphicsGetCurrentContext()!)

        let outputImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return outputImage!
    }
}
extension UIImageView {
    
    
    func topAlignmentAndAspectFit(to view: UIView) {
        self.contentMode = .scaleAspectFill
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        self.addConstraints(
            [NSLayoutConstraint(item: self,
                                attribute: .height,
                                relatedBy: .equal,
                                toItem: self,
                                attribute: .width,
                                multiplier: self.frame.size.height / self.frame.size.width,
                                constant: 0.0)])
        view.addConstraints(
            [NSLayoutConstraint(item: self,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1.0,
                                constant: 0.0)])
        view.addConstraints(
            [NSLayoutConstraint(item: self,
                                attribute: .width,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .width,
                                multiplier: 1.0,
                                constant: 0.0)])
        view.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]",
                                           options: .alignAllTop,
                                           metrics: nil,
                                           views: ["imageView": self]))
    }
    
       var contentClippingRect: CGRect {
            guard let image = image else { return bounds }
            guard contentMode == .scaleAspectFit else { return bounds }
            guard image.size.width > 0 && image.size.height > 0 else { return bounds }

            let scale: CGFloat
             scale = ((UIScreen.main.bounds.size.width) - 50) / image.size.width

            let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
            let x = (bounds.width - size.width) / 2.0
            let y = (bounds.height - size.height) / 2.0

            return CGRect(x: x, y: y, width: size.width, height: size.height)
        }
}

// MARK: - UIImage extention for Utility methods and property
public extension UIImage {
    
    /// Scaling image with image size and ratating image to identity if orientation is other than UIImageOrientation.up
    ///
    /// - Parameter maxSize: Maximum Image Size
    /// - Returns: Resized and Ratated UIImage
    func scaleAndRotateImage(_ maxSize: CGFloat) -> UIImage {
        
        let imgRef = self.cgImage!
        
        let width = CGFloat(imgRef.width)
        let height = CGFloat(imgRef.height)
        var transform = CGAffineTransform.identity
        var bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        if width > maxSize || height < maxSize {
            let ratio = width / height
            
            if ratio > 1 {
                bounds.size.width = maxSize
                bounds.size.height = bounds.size.width / ratio
            } else {
                bounds.size.height = maxSize
                bounds.size.width = bounds.size.height * ratio
            }
        }
        
        let scaleRatio = bounds.size.width / width
        let imageSize = CGSize(width: width, height: height)
        var boundHeight : CGFloat = 0.0
        
        let ori = self.imageOrientation
        
        switch(ori) {
        case .up:
            transform = CGAffineTransform.identity
            break
            
        case .down:
            transform = CGAffineTransform(translationX: imageSize.width, y: imageSize.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
            break
            
        case .left:
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.width)
            transform = transform.rotated(by: CGFloat(3.0 * Double.pi / 2.0))
            break
            
        case .right:
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            transform = CGAffineTransform(translationX: imageSize.height, y: 0.0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2.0))
            break
            
        case .upMirrored:
            transform = CGAffineTransform(translationX: imageSize.width, y: 0.0)
            transform = transform.scaledBy(x: -1.0, y: -1.0)
            break
            
        case .downMirrored:
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.height)
            transform = transform.scaledBy(x: 1.0, y: -1.0)
            break
            
        case .leftMirrored:
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            transform = CGAffineTransform(translationX: imageSize.height, y: imageSize.width)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
            transform = transform.rotated(by: CGFloat(3.0 * Double.pi / 2.0))
            break
            
        case .rightMirrored:
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2.0))
            break
        default:break
        }
        
        UIGraphicsBeginImageContext(bounds.size)
        let context = UIGraphicsGetCurrentContext()
        
        if ori == UIImage.Orientation.right || ori == UIImage.Orientation.left {
            context!.scaleBy(x: -scaleRatio, y: scaleRatio)
            context!.translateBy(x: -height, y: 0.0)
        } else {
            context!.scaleBy(x: scaleRatio, y: -scaleRatio)
            context!.translateBy(x: 0.0, y: -height)
        }
        
        context!.concatenate(transform)
        UIGraphicsGetCurrentContext()!.draw(imgRef, in: CGRect(x: 0, y: 0, width: width, height: height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    } //F.E.
} //CLS END

extension UIImage {
    func imageToBase64String(image: UIImage) -> String {
        let imageData = image.pngData()!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
}
