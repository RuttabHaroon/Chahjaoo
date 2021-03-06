//
//  HexagonView.m
//  Hexagon
//
//  Created by Ben Chatelain on 11/26/13.
//  Copyright (c) 2014 Ben Chatelain
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "HexagonView.h"
#import <QuartzCore/QuartzCore.h>

@implementation HexagonView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self configureLayerForHexagon];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    if ((self = [super initWithCoder:coder])) {
        [self configureLayerForHexagon];
    }
    return self;
}

- (void)redraw
{
    [self configureLayerForHexagon];
    [self setNeedsLayout];
}

- (void)configureLayerForHexagon
{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    maskLayer.frame = self.bounds;

    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat hPadding = width * 1 / 8 / 2;

    UIGraphicsBeginImageContext(self.frame.size);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(width/2, 0)];
    [path addLineToPoint:CGPointMake(width - hPadding, height / 4)];
    [path addLineToPoint:CGPointMake(width - hPadding, height * 3 / 4)];
    [path addLineToPoint:CGPointMake(width / 2, height)];
    [path addLineToPoint:CGPointMake(hPadding, height * 3 / 4)];
    [path addLineToPoint:CGPointMake(hPadding, height / 4)];
    [path closePath];
    [path fill];
    maskLayer.path = path.CGPath;
    
    UIGraphicsEndImageContext();
    self.layer.mask = maskLayer;
  
}

-(void)addBorder: (CAShapeLayer*)maskLayer : (UIColor *)color  {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
      shapeLayer.path = [maskLayer path];
      shapeLayer.fillColor = [UIColor clearColor].CGColor;
      shapeLayer.strokeColor = color.CGColor; //Here you can set border with green color
      shapeLayer.lineWidth = 2;
      [self.layer addSublayer:shapeLayer];
}

-(void)clearBorder:(CAShapeLayer*)maskLayer : (UIColor *)color {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
      
        shapeLayer.path = [maskLayer path];
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeColor = color.CGColor; //Here you can set border with green color
        shapeLayer.lineWidth = 0;
        [self.layer addSublayer:shapeLayer];
}
@end
