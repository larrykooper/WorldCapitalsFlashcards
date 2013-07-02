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

@synthesize countryLayer, capitalLayer;
@synthesize isFlipped;
@synthesize myController;

#pragma mark - Initialization Code

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:0.424f green:0.506f blue:0.353f alpha:1.00f]];
        
        isFlipped = NO;
        
        // Create a CALayer object
        // FIRST LAYER
        
        countryLayer = [CALayer layer];
        countryLayer.doubleSided = NO;
        countryLayer.name = @"1";
        
        // Give it a size
        [countryLayer setBounds:CGRectMake(0.0, 0.0, cardWidth, cardHeight)];
        
        // Give it a location        
        [countryLayer setPosition:[self center]];
        
        // Give it a background color
        countryLayer.backgroundColor = [[UIColor whiteColor] CGColor];        
        
        [countryLayer setMasksToBounds:YES];
        CATextLayer *textLayer = [self makeLabel:@"Egypt"];
        [countryLayer addSublayer:textLayer];
        
        // Second layer (the one that starts out on the bottom)
        
        capitalLayer = [CALayer layer];
        capitalLayer.doubleSided = NO;
        capitalLayer.name = @"2";
        
        // Give it a size
        [capitalLayer setBounds:CGRectMake(0.0, 0.0, cardWidth, cardHeight)];
       
        [capitalLayer setPosition:[self center]];
        capitalLayer.backgroundColor = [[UIColor whiteColor] CGColor];
        [capitalLayer setMasksToBounds:YES];
        
        CATextLayer *backLayer = [self makeLabel:@"Cairo"];
        [capitalLayer addSublayer:backLayer];
        
        // Make my two new layers sublayers of the view's layer
        // add bottom first
        [[self layer] addSublayer:capitalLayer];
        [[self layer] addSublayer:countryLayer];
        
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

#pragma mark - Gesture Event Handlers

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

#pragma mark - Other

// Called when user rotates the device 
- (void)rotateMe
{
    //NSLog(@"rotateMe was called.");
    [countryLayer setPosition:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)];
    [capitalLayer setPosition:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)];
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
