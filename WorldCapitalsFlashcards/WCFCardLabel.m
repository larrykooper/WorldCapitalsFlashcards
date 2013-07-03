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

- (id)initWithText:(NSString *)text
{
    self = [super init];
    if (self) {
        textLayer = [[CATextLayer alloc] init];
        [textLayer setFont:@"Helvetica"];
        [textLayer setFontSize:18];
        [textLayer setBounds:CGRectMake(20.0, 0.0, cardWidth, 30.0)];  // make the bounds width = the width of card
        // to center the text
        [textLayer setPosition:CGPointMake(80.0, 20.0)];  // In real life adjust it to center the text somehow
        [textLayer setString:text];
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
