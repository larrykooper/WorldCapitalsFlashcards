//
//  WCFCardLabel.m
//  WorldCapitalsFlashcards
//
//  Created by Larry MBP on 7/2/13.
//  Copyright (c) 2013 Kooper, Laurence. All rights reserved.
//

#import "WCFCardLabel.h"
#import "WCFConstants.h"

@implementation WCFCardLabel

@synthesize textLayer;

- (id)initWithConfig 
{
    self = [super init];
    if (self) {
        textLayer = [[CATextLayer alloc] init];
        [textLayer setFont:@"Helvetica"];
        [textLayer setFontSize:18];
        [textLayer setAnchorPoint:CGPointMake(0.0, 0.0)];
        [textLayer setBounds:CGRectMake(0.0, 0.0, cardWidth, 140.0)];         
        [textLayer setPosition:CGPointMake(0.0, 20.0)];        
        [textLayer setAlignmentMode:kCAAlignmentCenter];
        [textLayer setForegroundColor:[[UIColor blackColor] CGColor]];
        [textLayer setContentsScale:[[UIScreen mainScreen] scale]];        
    }
    return self;
}

- (WCFCardLabel *)updateLabel:(NSString *)text
{
    [textLayer setString:text];
    return self;
}

@end
