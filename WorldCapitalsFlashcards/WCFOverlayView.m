//
//  WCFOverlayView.m
//  WorldCapitalsFlashcards
//
//  Created by Kooper, Laurence on 7/9/13.
//  Copyright (c) 2013 Kooper, Laurence. All rights reserved.
//

#import "WCFOverlayView.h"

@implementation WCFOverlayView

- (void)drawRect:(CGRect)rect
{
    NSLog(@"Message 18: WCFOverlayView: in drawRect");
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Create the path
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 230, 100)
                                                   byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(30.0, 30.0)];
    // Set the render color
    [[UIColor blackColor] setFill];
    
    // Fill the path
    
    [maskPath fillWithBlendMode:kCGBlendModeNormal
                           alpha:0.4];
    
    // Add the circle to close the window    
    // Fill is still black
    
    circleCenterX = 200.0;
    circleCenterY = 20.0;
    circleRadius = 16.0;
    sizeOfCross = 6.0;    
    
    CGContextAddArc(ctx, circleCenterX, circleCenterY, circleRadius, 0.0, M_PI * 2.0, YES);
    CGContextFillPath(ctx);
    
    // Add the x to show the user where to tap
    
    CGContextSetStrokeColorWithColor(ctx,[[UIColor whiteColor] CGColor]);
    CGContextSetLineWidth(ctx, 2.0);
    
    CGContextMoveToPoint(ctx, circleCenterX - sizeOfCross, circleCenterY - sizeOfCross);
    
    CGContextAddLineToPoint(ctx, circleCenterX + sizeOfCross, circleCenterY + sizeOfCross);
    // Draw the path
    CGContextStrokePath(ctx);
    
    CGContextMoveToPoint(ctx, circleCenterX + sizeOfCross, circleCenterY - sizeOfCross);
    CGContextAddLineToPoint(ctx, circleCenterX - sizeOfCross, circleCenterY + sizeOfCross);
    // Draw the path
    CGContextStrokePath(ctx);
    
    // Add the instructions label
    
    UILabel *instrsLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 26, 200, 45)];
    [self addSubview:instrsLabel];
    
    instrsLabel.text = @"Swipe up: remove card\nSwipe left: try card again later";
    instrsLabel.textColor = [UIColor whiteColor];
    
    instrsLabel.textAlignment = NSTextAlignmentLeft;
    instrsLabel.backgroundColor = [UIColor clearColor];  
    instrsLabel.font = [UIFont systemFontOfSize:14.0];
    instrsLabel.numberOfLines = 0;
    [self addTapRecognizer];
}

- (void)addTapRecognizer
{
    UITapGestureRecognizer *tapRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tap:)];
    [self addGestureRecognizer:tapRecognizer];    
}

- (void)tap:(UIGestureRecognizer *)gr
{
    NSLog(@"Message 17: WCFOverlayView: I am in tap handler");
        
    CGPoint myPoint = [gr locationInView:self];
    
    CGFloat targetTopY = circleCenterY - circleRadius;
    CGFloat targetBottomY = circleCenterY + circleRadius;
    CGFloat targetLeftX = circleCenterX - circleRadius;
    CGFloat targetRightX = circleCenterX + circleRadius;    
    
    if (myPoint.y > targetTopY && myPoint.y < targetBottomY && myPoint.x > targetLeftX && myPoint.x < targetRightX) {
        [self setHidden:YES];
       // let me do this first and later animate its removal 
    }    
}

@end