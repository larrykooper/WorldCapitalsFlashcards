//
//  WCFViewController.m
//  WorldCapitalsFlashcards
//
//  Created by Kooper, Laurence on 6/27/13.
//  Copyright (c) 2013 Kooper, Laurence. All rights reserved.
//
//  Some card-flipping code from Gary Myers
// http://www.mycodestudio.com/blog/2011/01/10/coreanimation/

#import <QuartzCore/QuartzCore.h>
#import "WCFViewController.h"
#import "WCFView.h"
#import "WCFCardLabel.h"
#import "WCFConstants.h"
#import "WCFCountryStore.h"
#import "Country.h"

@implementation WCFViewController
@synthesize currentCountry, countLabel;
@synthesize dismissedCapital;

 - (void)loadView
{
    NSLog(@"Message 5: WCFViewController.m: loadView was called.");
    [self setView:[[WCFView alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
    [[self myView] setMyController:self];
    [[self myView] initLayers];
}

- (void)viewDidLoad
{
    NSLog(@"Message 6: WCFViewController.m: viewDidLoad was called.");
    
    // Add instructions label
    
    UILabel *instrsLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 340, 300, 30)];
    [self.view addSubview:instrsLabel];
    
    instrsLabel.text = @"Swipe up: remove card\nSwipe left: try card again later";
    instrsLabel.textColor = [UIColor blackColor];
    
    instrsLabel.textAlignment = NSTextAlignmentLeft;
    instrsLabel.backgroundColor = [UIColor clearColor];
    instrsLabel.font = [UIFont systemFontOfSize:12.0];
    instrsLabel.numberOfLines = 0;
    
    // Add 'number of cards' label
    
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 320, 300, 30)];
    [self.view addSubview:countLabel];
    
    countLabel.text = [NSString stringWithFormat:@"%d cards remaining / %d cards total", [[WCFCountryStore sharedStore] numCardsRemaining],
                       [[WCFCountryStore sharedStore] numCardsTotal]];
    
    countLabel.textColor = [UIColor blackColor];
    
    countLabel.textAlignment = NSTextAlignmentLeft;
    countLabel.backgroundColor = [UIColor clearColor];
    countLabel.font = [UIFont systemFontOfSize:12.0];
    countLabel.numberOfLines = 0;
}

- (CAAnimation *)flipAnimationWithDuration:(NSTimeInterval)aDuration
                                startValue:(CGFloat)startValue
                                  endValue:(CGFloat)endValue                               
{
	isTransitioning = YES;
    // Rotating halfway (pi radians) around the Y axis gives the appearance of flipping
    CABasicAnimation *flipAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];    
    flipAnimation.fromValue = [NSNumber numberWithDouble:startValue];
    flipAnimation.toValue = [NSNumber numberWithDouble:endValue];    
    
    // As the edge gets closer to us, it appears to move faster. Simulate this in 2D with an easing function
    flipAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    flipAnimation.duration = aDuration;
    
    // Hold the view in the state reached by the animation until we can fix it, or else we get an annoying flicker
	// this really means keep the state of the object at whatever the anim ends at
    flipAnimation.fillMode = kCAFillModeForwards;
    flipAnimation.removedOnCompletion = NO;
    
    return flipAnimation;
}

- (CAAnimation *)swipeAnimationWithDuration:(NSTimeInterval)aDuration
                                 startPoint:(CGPoint)startPoint
                                   endPoint:(CGPoint)endPoint
{
    isTransitioning = YES;
    CABasicAnimation *swipeAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    [swipeAnimation setFromValue:[NSValue valueWithCGPoint:startPoint]];
    [swipeAnimation setToValue:[NSValue valueWithCGPoint:endPoint]];
    [swipeAnimation setDuration:aDuration];
    return swipeAnimation;
}

- (void)flip
{
    NSLog(@"Message 2: WCFViewController.m: I am in flip");
    // If we are currently transitioning, ignore any further taps on the
    // card until we are done
	if (isTransitioning) {
        NSLog(@"Message 21: WCFViewController: in flip we transitioning, returning");
		return;
    }
    
    CALayer *front;
    CALayer *back;    
    CGFloat startValueFront, endValueFront, startValueBack, endValueBack;
    
    if (![[self myView] isFlipped]) {
        front = [[self myView] firstLayer];
        back = [[self myView] secondLayer];
        startValueFront = 0.0f;
        endValueFront = -M_PI;
        startValueBack = M_PI;
        endValueBack = 0.0f;
    } else {
        front = [[self myView] secondLayer];
        back = [[self myView] firstLayer];
        startValueFront = 0.0f;
        endValueFront = M_PI;
        startValueBack = -M_PI;
        endValueBack = 0.0f;
    }
    
	CAAnimation *frontAnimation = [self
                                 flipAnimationWithDuration:0.75f
                                                startValue:startValueFront
                                                  endValue:endValueFront];
    
    
    CAAnimation *backAnimation = [self
                                    flipAnimationWithDuration:0.75f
                                                   startValue:startValueBack
                                                     endValue:endValueBack];
    
    CGFloat zDistance = 1500.0f;
    
    // Create CATransform3D data structure
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1. / zDistance;
    front.transform = perspective;
    back.transform = perspective;
    
    frontAnimation.delegate = self;
    NSLog(@"Message 8: WCFViewController.m: About to do setValue");
    [frontAnimation setValue:@"flipAnim" forKeyPath:@"animationType"];
    [CATransaction begin];
    // Note -- the two keys must be SAME for it to work 
    [front addAnimation:frontAnimation forKey:@"flip"];
    [back addAnimation:backAnimation forKey:@"flip"];
    [CATransaction commit];

}

// Does the animation of making the card disappear
- (void)removeCard
{
    if (isTransitioning) {
        return;
    }
    
    CALayer *first = [[self myView] firstLayer];
    CALayer *second = [[self myView] secondLayer];
    
    CGFloat endPointY = 0.0 - (cardHeight / 2.0);
    
    CGPoint startPoint = CGPointMake([first position].x, [first position].y);
    CGPoint endPoint = CGPointMake([first position].x, endPointY);
    
    CAAnimation *firstAnimation = [self swipeAnimationWithDuration:0.3f
                                                        startPoint:startPoint
                                                          endPoint:endPoint];
    
    CAAnimation *secondAnimation = [self swipeAnimationWithDuration:0.3f
                                                         startPoint:startPoint
                                                           endPoint:endPoint];
    
    [firstAnimation setDelegate:self];
    [first setPosition:endPoint];
    [second setPosition:endPoint];
    [firstAnimation setValue:@"swipeUpAnim" forKeyPath:@"animationType"];
    
   
    
    [CATransaction begin];
    [first addAnimation:firstAnimation forKey:@"swipe1"];
    [second addAnimation:secondAnimation forKey:@"swipe2"];
    [CATransaction commit];

}


- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
    NSLog(@"Message 3: WCFViewController.m: I am in animationDidStop");
    
    if ([[animation valueForKey:@"animationType"] isEqual:@"swipeUpAnim"]) {
        NSLog(@"Message 24: WCFViewController: isEqual swipeUpAnim executing");
        NSLog(@"Message 25: Current country is: %@", [currentCountry countryName]);
        // Actually remove the card from the pack
        [[WCFCountryStore sharedStore] removeCard:currentCountry];
        // Update label
        
        NSString *myFormat;
        if ([[WCFCountryStore sharedStore] numCardsRemaining] == 1) {
            NSLog(@"Message 23: WCFViewController - One more card");
            myFormat = @"%d card remaining / %d cards total";
        } else {
            myFormat = @"%d cards remaining / %d cards total";
        }
        
        countLabel.text = [NSString stringWithFormat:myFormat, [[WCFCountryStore sharedStore] numCardsRemaining],
                           [[WCFCountryStore sharedStore] numCardsTotal]];
    }
    
    if ([[animation valueForKey:@"animationType"] isEqual:@"swipeUpAnim"] ||
        [[animation valueForKey:@"animationType"] isEqual:@"swipeLeftAnim"]) {
        NSLog(@"Swipe has ended.");
        [self showNextCard];
    }

    if ([[animation valueForKey:@"animationType"] isEqual:@"flipAnim"]) {
        NSLog(@"Message 4: We are in flipStop");
        [[self myView] setIsFlipped:![[self myView] isFlipped]];
    }
    
	isTransitioning = NO;
}
             
- (WCFView *)myView
{
    return (WCFView *)[self view];
}

- (BOOL)shouldAutorotate
{
    NSLog(@"shouldAutorotate was called.");
    [[self myView] rotateMe];
    return YES;
}


- (void)tryCardAgainLater
{
    NSLog(@"tryCardAgainLater was called.");
    if (isTransitioning) {
        return;
    }
    
    CALayer *first = [[self myView] firstLayer];
    CALayer *second = [[self myView] secondLayer];
    
    CGFloat endPointX = 0.0 - (cardWidth / 2.0);
    
    CGPoint startPoint = CGPointMake([first position].x, [first position].y);
    CGPoint endPoint = CGPointMake(endPointX, [first position].y);
    
    CAAnimation *firstAnimation = [self swipeAnimationWithDuration:0.3f
                                                        startPoint:startPoint
                                                          endPoint:endPoint];
    
    CAAnimation *secondAnimation = [self swipeAnimationWithDuration:0.3f
                                                         startPoint:startPoint
                                                           endPoint:endPoint];
    
    [firstAnimation setDelegate:self];
    [first setPosition:endPoint];
    [second setPosition:endPoint];
    [firstAnimation setValue:@"swipeLeftAnim" forKeyPath:@"animationType"];
  
    [CATransaction begin];
    [first addAnimation:firstAnimation forKey:@"swipe1"];
    [second addAnimation:secondAnimation forKey:@"swipe2"];
    [CATransaction commit];        
}

- (void)showNextCard
{
    if ([[WCFCountryStore sharedStore] cardDeckEmpty]) {
        NSLog(@"Message 22: WCFViewController: Card Deck is empty");
        [self showNoMoreCards];
        return;
    }
    NSLog(@"WCFViewController.m: showNextCard executing.");    
    
    WCFView *theView = [self myView];
    if ([theView isFlipped]) {
        NSLog(@"theView isFlipped");
        dismissedCapital = YES;
    } else {
        NSLog(@"theView is NOT Flipped");
        dismissedCapital = NO;
    }
        
    // Get a random card from the card that
    //  remain in the pack.
    Country *c = [[WCFCountryStore sharedStore] getRandomCardFromRemaining];
    [self setCurrentCountry:c];
    
    if (dismissedCapital) {        
        [[theView cardLabel] updateLabel:[c capital]];
        [[theView capitalLabel] updateLabel:[c countryName]];
        
    } else {
        [[theView cardLabel] updateLabel:[c countryName]];
        [[theView capitalLabel] updateLabel:[c capital]];        
    }    
       
    CALayer *country = [theView firstLayer];
    CALayer *capital = [theView secondLayer];
    CGRect bounds = [theView bounds];
    CGPoint endPoint = [theView center];
    
    CGFloat startPointX =  bounds.size.width + (cardWidth / 2.0) + 30;
    
    CGPoint startPoint = CGPointMake(startPointX, endPoint.y);
    
    CAAnimation *countryAnimation = [self swipeAnimationWithDuration:0.3f
                                                        startPoint:startPoint
                                                          endPoint:endPoint];
    
    CAAnimation *capitalAnimation = [self swipeAnimationWithDuration:0.3f
                                                         startPoint:startPoint
                                                           endPoint:endPoint];    
    [countryAnimation setDelegate:self];
    [country setPosition:endPoint];
    [capital setPosition:endPoint];
    [CATransaction begin];
    [country addAnimation:countryAnimation forKey:@"newcard1"];
    [capital addAnimation:capitalAnimation forKey:@"newcard2"];
    [CATransaction commit];
}

- (void)showNoMoreCards
{
    NSLog(@"Message 23: WCFViewController: executing showNoMoreCards");
    CGRect nmcFrame = CGRectMake(30, 240, 300, 50);
    UIView *nmcView = [[UIView alloc] initWithFrame:nmcFrame];
    [self.view addSubview:nmcView];
    UILabel *nmcLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 50)];
   
    [nmcLabel setText:@"No more cards!"];
    [nmcLabel setTextColor:[UIColor blackColor]];
    
    [nmcLabel setTextAlignment: NSTextAlignmentCenter];  
    
    [nmcLabel setBackgroundColor:[UIColor clearColor]];
    [nmcLabel setFont:[UIFont systemFontOfSize:16.0]];
       
    [nmcView addSubview:nmcLabel];    
}

@end
