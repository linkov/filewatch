//
//  SDWDropView.m
//  Filewatch
//
//  Created by alex on 12/3/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "SDWDropView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSColor+Util.h"

@interface SDWDropView ()

@property CGRect patternRectangle;
@property CGFloat dashPhase;

@property (strong) CAShapeLayer *shapeLayer;
@property (strong) CAShapeLayer *backgroundLayer;

@end

@implementation SDWDropView


- (void)awakeFromNib {

    self.patternRectangle = [self bounds];
    self.dashPhase = 5;

    self.wantsLayer = YES;

    CGRect shapeRect = CGRectInset(NSRectToCGRect([self bounds]), 5.0, 5.0);

    self.shapeLayer = [CAShapeLayer layer];
    [self.shapeLayer setBounds:shapeRect];
    [self.shapeLayer setPosition:CGPointMake(4.0f, 4.0f)];
    self.shapeLayer.anchorPoint = CGPointMake(0.0f, 0.0f);

    [self.shapeLayer setFillColor:[[NSColor clearColor] CGColor]];
    [self.shapeLayer setStrokeColor:[[NSColor colorWithHexColorString:@"033649"] CGColor]];
    [self.shapeLayer setLineWidth:3.0f];
    [self.shapeLayer setLineJoin:kCALineJoinRound];

  //  [self.shapeLayer setFillRule:kCAFillRuleEvenOdd];
  //  [self.shapeLayer setFillMode:@"kCAFillRuleEvenOdd"];

    [self.shapeLayer setLineDashPattern:

     [NSArray arrayWithObjects:[NSNumber numberWithInt:10],
      [NSNumber numberWithInt:5],
      nil]

     ];

    [self.shapeLayer setPath:CGPathCreateWithRoundedRect(shapeRect, 2, 2, &CGAffineTransformIdentity)];

    [self.layer addSublayer:self.shapeLayer];



    self.backgroundLayer = [CAShapeLayer layer];
    self.backgroundLayer.bounds = CGRectInset(NSRectToCGRect(shapeRect), 4.0, 4.0);

    [self.backgroundLayer setPath:CGPathCreateWithRoundedRect(self.backgroundLayer.bounds, 2, 2, &CGAffineTransformIdentity)];
    [self.backgroundLayer setFillColor:[[NSColor colorWithHexColorString:@"95b5c2"] CGColor]];

    [self.backgroundLayer setPosition:CGPointMake(8.0f, 8.0f)];
    self.backgroundLayer.anchorPoint = CGPointMake(0.0f, 0.0f);

    [self.layer addSublayer:self.backgroundLayer];

    [self toggleAnimation];


}

//- (void)drawRect:(NSRect)dirtyRect {
////    CGContextRef currentContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
////    CGContextSetLineWidth( currentContext, 5.0 );
////
//////    CGFloat dashLengths[] = { 20, 30, 40, 30, 20, 10 };
////
////    CGContextSetLineDash( currentContext, self.dashPhase, NULL, 0 );
////
////    CGPathCreateWithRect(CGRectMake(2.0, 2.0, 100.0, 100.0), NULL);
////    CGContextStrokeRect(currentContext, CGRectInset(NSRectToCGRect([self bounds]), 3.0, 3.0));
//
//
//
//    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
//
//    CGContextSetLineWidth( context, 5.0 );
//
//    CGFloat dash[] = {6 ,1}; // pattern 6 times “solid”, 5 times “empty”
//    CGContextSetLineDash(context,0,dash,2);
////    CGPathCreateWithRect(CGRectMake(2.0, 2.0, 100.0, 100.0), NULL);
//
//
/////    CGPathCreateWithRoundedRect(CGRectMake(2.0, 2.0, 100.0, 100.0), 16, 16, nil);
//
//
//    CGContextStrokeRect(context, CGRectInset(NSRectToCGRect([self bounds]), 3.0, 3.0));
//    CGContextStrokePath( context );
//}
//

- (void)toggleAnimation {

    if ([self.shapeLayer animationForKey:@"linePhase"])
        [self.shapeLayer removeAnimationForKey:@"linePhase"];
    else {
        CABasicAnimation *dashAnimation;
        dashAnimation = [CABasicAnimation
                         animationWithKeyPath:@"lineDashPhase"];

        [dashAnimation setFromValue:[NSNumber numberWithFloat:0.0f]];
        [dashAnimation setToValue:[NSNumber numberWithFloat:15.0f]];
        [dashAnimation setDuration:0.75f];
        [dashAnimation setRepeatCount:10000];

        [self.shapeLayer addAnimation:dashAnimation forKey:@"linePhase"];
        
    }
}


@end