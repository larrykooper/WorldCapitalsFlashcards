//
//  WCFView.m
//  WorldCapitalsFlashcards
//
//  Created by Kooper, Laurence on 6/28/13.
//  Copyright (c) 2013 Kooper, Laurence. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "WCFView.h"
#import "WCFViewController.h"

CGFloat const cardHeight = 150.0;
CGFloat const cardWidth = 250.0;

@implementation WCFView

@synthesize firstLayer, secondLayer;
@synthesize isFlipped;
@synthesize myController;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0.424f green:0.506f blue:0.353f alpha:1.00f]];
        
        isFlipped = NO;
        
        // Create a CALayer object
        // FIRST LAYER
        firstLayer= [CALayer layer];
        firstLayer.doubleSided = NO;
        firstLayer.name = @"1";
        
        // Give it a size
        [firstLayer setBounds:CGRectMake(0.0, 0.0, cardWidth, cardHeight)];
        
        // Give it a location        
        [firstLayer setPosition:[self center]];
        
        // Give it a background color
        firstLayer.backgroundColor = [[UIColor whiteColor] CGColor];        
        
        [firstLayer setMasksToBounds:YES];
        CATextLayer *textLayer = [self makeLabel:@"Egypt"];
        [firstLayer addSublayer:textLayer];
        
        // Second layer (the one that starts out on the bottom)
        
        secondLayer = [CALayer layer];
        secondLayer.doubleSided = NO;
        secondLayer.name = @"2";
        
        // Give it a size
        [secondLayer setBounds:CGRectMake(0.0, 0.0, cardWidth, cardHeight)];
       
        [secondLayer setPosition:[self center]];
        secondLayer.backgroundColor = [[UIColor whiteColor] CGColor];
        [secondLayer setMasksToBounds:YES];
        
        CATextLayer *backLayer = [self makeLabel:@"Cairo"];
        [secondLayer addSublayer:backLayer];
        
        // Make my two new layers sublayers of the view's layer
        // add bottom first
        [[self layer] addSublayer:secondLayer];
        [[self layer] addSublayer:firstLayer];
        
        // Add the tap gesture recognizer
        
        UITapGestureRecognizer *tapRecognizer =
             [[UITapGestureRecognizer alloc] initWithTarget:self
                                                     action:@selector(tap:)];
        [self addGestureRecognizer:tapRecognizer];
        
        UISwipeGestureRecognizer *swipeRecognizer =
              [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                        action:@selector(swipeUp:)];
        
        [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
        
        [self addGestureRecognizer:swipeRecognizer];
        
        UISwipeGestureRecognizer *swipeLeftRecognizer =
             [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                       action:@selector(swipeLeft:)];
        
        [swipeLeftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self addGestureRecognizer:swipeLeftRecognizer];
    }
    return self;
}

- (void)tap:(UIGestureRecognizer *)gr
{
    CGPoint myPoint = [gr locationInView:self];
    CGFloat cardTopY = ((self.bounds.size.height / 2.0) - cardHeight / 2.0);  
    CGFloat cardBottomY = cardTopY + cardHeight;
    CGFloat cardLeftX = ((self.bounds.size.width / 2.0) - cardWidth / 2.0);
    CGFloat cardRightX = (cardLeftX + cardWidth);
    
    if (myPoint.y > cardTopY && myPoint.y < cardBottomY && myPoint.x > cardLeftX && myPoint.x < cardRightX) {
        [myController flip];
    }    
}

- (void)swipeUp:(UIGestureRecognizer *)gr
{
    NSLog(@"swipeUp was called.");
    [myController removeCard];
}

- (void)swipeLeft:(UIGestureRecognizer *)gr
{
    NSLog(@"swipeLeft was called.");    
}

- (void)rotateMe
{
    //NSLog(@"rotateMe was called.");
    [firstLayer setPosition:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)];
    [secondLayer setPosition:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)];
}

- (CATextLayer *)makeLabel:(NSString *)text
{
    CATextLayer *label = [[CATextLayer alloc] init];
    [label setFont:@"Helvetica"];
    [label setFontSize:18];
    [label setBounds:CGRectMake(0.0, 0.0, 50.0, 30.0)];  // make the bounds width = the width of card
    // to center the text
    [label setPosition:CGPointMake(40.0, 20.0)];  // In real life adjust it to center the text somehow
    [label setString:text];
    [label setAlignmentMode:kCAAlignmentCenter];
    [label setForegroundColor:[[UIColor blackColor] CGColor]];
    [label setContentsScale:[[UIScreen mainScreen] scale]];
    
    return label;
}

@end
