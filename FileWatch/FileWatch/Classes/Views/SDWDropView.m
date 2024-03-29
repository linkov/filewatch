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

@property BOOL canPerformAction;

@end

@implementation SDWDropView


- (void)awakeFromNib {

    self.canPerformAction = NO;

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

    [self registerForDraggedTypes:@[@"com.sdwr.filewatch.drag"]];

    self.shapeLayer.strokeColor = self.backgroundLayer.fillColor = [NSColor colorWithHexColorString:@"d5dbdf"].CGColor;


}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {

    [self startAnimation];

    self.canPerformAction = YES;

    return NSDragOperationMove;
}


- (void)draggingEnded:(id<NSDraggingInfo>)sender {
    [self stopAnimation];

    if (self.canPerformAction) {

        NSPasteboard *pBoard = [sender draggingPasteboard];
        NSData *data = [pBoard dataForType:@"com.sdwr.filewatch.drag"];

        NSDictionary *recipeDict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSLog(@"recipe dict - %@",recipeDict);
    }
}

- (void)draggingExited:(id<NSDraggingInfo>)sender {
    [self stopAnimation];

    self.canPerformAction = NO;

}

- (void)stopAnimation {

    self.shapeLayer.strokeColor = self.backgroundLayer.fillColor = [NSColor colorWithHexColorString:@"d5dbdf"].CGColor;

    [self.shapeLayer.modelLayer setValue:[self.shapeLayer.presentationLayer valueForKeyPath:@"lineDashPhase"] forKeyPath:@"lineDashPhase"];

    self.shapeLayer.strokeColor = self.backgroundLayer.fillColor = [NSColor colorWithHexColorString:@"d5dbdf"].CGColor;

    if ([self.shapeLayer animationForKey:@"linePhase"])
        [self.shapeLayer removeAnimationForKey:@"linePhase"];
}

- (void)startAnimation {

    self.shapeLayer.strokeColor = self.backgroundLayer.fillColor = [NSColor colorWithHexColorString:@"033649"].CGColor;

        CABasicAnimation *dashAnimation;
        dashAnimation = [CABasicAnimation
                         animationWithKeyPath:@"lineDashPhase"];

        [dashAnimation setFromValue:[NSNumber numberWithFloat:0.0f]];
        [dashAnimation setToValue:[NSNumber numberWithFloat:15.0f]];
        [dashAnimation setDuration:0.75f];
        [dashAnimation setRepeatCount:10000];

        [self.shapeLayer addAnimation:dashAnimation forKey:@"linePhase"];
}


@end
