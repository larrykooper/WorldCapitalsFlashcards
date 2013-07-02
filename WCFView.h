//
//  WCFView.h
//  WorldCapitalsFlashcards
//
//  Created by Kooper, Laurence on 6/28/13.
//  Copyright (c) 2013 Kooper, Laurence. All rights reserved.
//
// View class for the WCF's main view.

#import <Foundation/Foundation.h>
@class WCFViewController;

@interface WCFView : UIView
{   
    
}

@property (nonatomic, weak) WCFViewController *myController;
@property (nonatomic, strong) CALayer *firstLayer, *secondLayer;
@property BOOL isFlipped;

- (void)rotateMe;
- (CATextLayer *)makeLabel:(NSString *)text;

extern CGFloat const cardHeight;
extern CGFloat const cardWidth;

@end