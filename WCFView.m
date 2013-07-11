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
#import "WCFCardLabel.h"
#import "WCFConstants.h"
#import "WCFCountryStore.h"
#import "Country.h"

@implementation WCFView

@synthesize firstLayer, secondLayer;
@synthesize myController;
@synthesize firstLabel, secondLabel;

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"Message 7: WCFView: initWithFrame started");
    self = [super initWithFrame:frame];
    return self;
}

- (void)initLayersToStartApp {
    // Next line is the (sort of) forest green 
    [self setBackgroundColor:[UIColor colorWithRed:0.424f green:0.506f blue:0.353f alpha:1.00f]];
    
    // Create a CALayer object
    // FIRST LAYER
    
    firstLayer= [CALayer layer];
    firstLayer.doubleSided = NO;
    firstLayer.name = @"1";
    
    // Give it a size
    [firstLayer setBounds:CGRectMake(0.0, 0.0, cardWidth, cardHeight)];
    
    // Give it a background color
    firstLayer.backgroundColor = [[UIColor whiteColor] CGColor];
    
    [firstLayer setMasksToBounds:YES];
    firstLabel = [[WCFCardLabel alloc] initWithConfig];

    [firstLayer addSublayer:[firstLabel textLayer]];
    
    // Second layer (the one that starts out on the bottom)
    
    secondLayer = [CALayer layer];
    secondLayer.doubleSided = NO;
    secondLayer.name = @"2";
    
    // Give it a size
    [secondLayer setBounds:CGRectMake(0.0, 0.0, cardWidth, cardHeight)];
    
    secondLayer.backgroundColor = [[UIColor whiteColor] CGColor];
    [secondLayer setMasksToBounds:YES];
    
    secondLabel = [[WCFCardLabel alloc] initWithConfig];

    [secondLayer addSublayer:[secondLabel textLayer]];
    
    // Make my two new layers sublayers of the view's layer
    // add bottom first
    [[self layer] addSublayer:secondLayer];
    [[self layer] addSublayer:firstLayer];
    
    // Add tap recognizer
    UITapGestureRecognizer *tapRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tap:)];
    [self addGestureRecognizer:tapRecognizer];
    
    // Add swipe up recognizer
    UISwipeGestureRecognizer *swipeRecognizer =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(swipeUp:)];
    
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    
    [self addGestureRecognizer:swipeRecognizer];
    
    // Add swipe left recognizer
    UISwipeGestureRecognizer *swipeLeftRecognizer =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(swipeLeft:)];
    
    [swipeLeftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:swipeLeftRecognizer];
    
    // Add swipe right recognizer
    UISwipeGestureRecognizer *swipeRightRecognizer =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(swipeRight:)];
    
    [swipeRightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:swipeRightRecognizer];       
}

- (void)initLayersToStartGame {
    
    // Pick a random country
    Country *c = [[WCFCountryStore sharedStore] getRandomCardFromRemaining];
    NSLog(@"Message 27: WCFView: Country I just got is named: %@", [c countryName]);
    [myController setCurrentCountry:c];
    NSLog(@"Message 25: WCFView: myController Current Country: %@", [[myController currentCountry] countryName]);

    // Give it a location
    [firstLayer setPosition:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)];
    
    [firstLabel updateLabel:[c countryName]];
    
    [secondLayer setPosition:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)];
    
    [secondLabel updateLabel:[c capital]];
}

- (void)tap:(UIGestureRecognizer *)gr
{
    NSLog(@"Message 1: WCFView: I am in tap handler");
    
    if ([[WCFCountryStore sharedStore] cardDeckEmpty] && ([[WCFCountryStore sharedStore] numCardsStashed] == 0) &&
        ([[WCFCountryStore sharedStore] numCardsRemoved] == [[WCFCountryStore sharedStore] numCardsTotal])) {
        // restart game
        [myController beginNewGame];
    } else {
        CGPoint myPoint = [gr locationInView:self];
        CGFloat cardTopY = ((self.bounds.size.height / 2.0) - cardHeight / 2.0);
        CGFloat cardBottomY = cardTopY + cardHeight;
        CGFloat cardLeftX = ((self.bounds.size.width / 2.0) - cardWidth / 2.0);
        CGFloat cardRightX = (cardLeftX + cardWidth);
        
        if (myPoint.y > cardTopY && myPoint.y < cardBottomY && myPoint.x > cardLeftX && myPoint.x < cardRightX) {
            [myController flip];
        }    
    }    
}

- (void)swipeUp:(UIGestureRecognizer *)gr
{
    NSLog(@"Message 41: WCFView: swipeUp was called.");
    NSLog(@"Message 74: WCFView: myController Current Country: %@", [[myController currentCountry] countryName]);
    [myController removeCard];
}

- (void)swipeLeft:(UIGestureRecognizer *)gr
{
    NSLog(@"WCFView: swipeLeft was called.");
    [myController tryCardAgainLater];
}

- (void)swipeRight:(UIGestureRecognizer *)gr
{
    NSLog(@"WCFView: swipeRight was called.");
    [myController getRidOfCardToRight];
}

- (void)rotateMe
{
    NSLog(@"WCFView: rotateMe was called.");
    NSLog(@"Message 75: WCFView: myController Current Country: %@", [[myController currentCountry] countryName]);
    if (![[WCFCountryStore sharedStore] cardDeckEmpty]) {
        [firstLayer setPosition:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)];
        [secondLayer setPosition:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)];
    }
}

@end