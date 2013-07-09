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
    // Create the path
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 230, 100)
                                                   byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(30.0, 30.0)];
    // Set the render color
    [[UIColor blackColor] setFill];
    
    // Fill the path
    
    [maskPath fillWithBlendMode:kCGBlendModeNormal
                           alpha:0.4];
       
    // Add instructions label
    
    UILabel *instrsLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 26, 200, 45)];
    [self addSubview:instrsLabel];
    
    instrsLabel.text = @"Swipe up: remove card\nSwipe left: try card again later";
    instrsLabel.textColor = [UIColor whiteColor];
    
    instrsLabel.textAlignment = NSTextAlignmentLeft;
    instrsLabel.backgroundColor = [UIColor clearColor];  
    instrsLabel.font = [UIFont systemFontOfSize:14.0];
    instrsLabel.numberOfLines = 0;
}

@end