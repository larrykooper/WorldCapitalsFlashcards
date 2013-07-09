//
//  WCFCardLabel.h
//  WorldCapitalsFlashcards
//
//  Created by Larry MBP on 7/2/13.
//  Copyright (c) 2013 Kooper, Laurence. All rights reserved.
//
// A WCFCardLabel contains the text written on the card.

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface WCFCardLabel : NSObject

@property (nonatomic) CATextLayer *textLayer;

- (id)initWithConfig;
- (WCFCardLabel *)updateLabel:(NSString *)text;

@end
