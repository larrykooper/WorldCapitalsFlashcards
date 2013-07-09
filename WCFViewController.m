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
#import "WCFOverlayView.h"

@implementation WCFViewController
@synthesize currentCountry, countLabel;
@synthesize firstLayerStatus, secondLayerStatus;
@synthesize firstLabelShowing, secondLabelShowing;

- (void)loadView
{
    NSLog(@"Message 5: WCFViewController: loadView was called.");
    [self setView:[[WCFView alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];  
    [[self myView] setMyController:self];   
    [[self myView] initLayersToStartApp];
    [self createInstrsOverlay];
    [self beginNewGame];
}

- (void)createInstrsOverlay
{    
    CGRect viewFrame = CGRectMake(0, 29, 230, 100);
    
    WCFOverlayView *ovlyView = [[WCFOverlayView alloc] initWithFrame:viewFrame];
    [ovlyView setBackgroundColor:[UIColor clearColor]];
    [[self view] addSubview:ovlyView];
}

- (void)beginNewGame
{
    [[WCFCountryStore sharedStore] setUpRemainingCards];
    
    UIView *v = [[self view] viewWithTag:[@"10" integerValue]];
    if (v) {
        v.hidden = YES;
        [[self view] bringSubviewToFront:v];
        [v removeFromSuperview];
    }
    [self refreshCountLabel];
    
    [[self myView] initLayersToStartGame];
    NSLog(@"Message 71: WCFViewController: Current country is: %@", [currentCountry countryName]);
   
    [self setFirstLayerStatus:@"UP"];
    [self setSecondLayerStatus:@"DOWN"];
    [self setFirstLabelShowing:@"COUNTRY"];
    [self setSecondLabelShowing:@"CAPITAL"];
}

- (void)viewDidLoad
{
    NSLog(@"Message 6: WCFViewController: viewDidLoad was called.");
    NSLog(@"Message 72: WCFViewController: Current country is: %@", [currentCountry countryName]);    
    
    // Add 'number of cards' label
    CGFloat yOfCountLabel = (([[self view] bounds].size.height) / 2) + (cardHeight / 2) + 15.0;
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(34, yOfCountLabel, cardWidth, 30)];
    [self.view addSubview:countLabel];
    
    countLabel.textColor = [UIColor blackColor];
    
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.backgroundColor = [UIColor whiteColor];
    countLabel.font = [UIFont systemFontOfSize:14.0];
    countLabel.numberOfLines = 0;
    [self refreshCountLabel];
    
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
    NSLog(@"Message 2: WCFViewController: I am in flip");
    // If we are currently transitioning, ignore any further taps on the
    // card until we are done
	if (isTransitioning) {
        NSLog(@"Message 21: WCFViewController: in flip we transitioning, returning");
		return;
    }
    
    NSLog(@"Message 44: WCFViewController: firstLayerStatus: %@", [self firstLayerStatus]);
    NSLog(@"Message 45: WCFViewController: secondLayerStatus: %@", [self secondLayerStatus]);
        
    NSLog(@"Message 46: WCFViewController: firstLabelShowing: %@", [self firstLabelShowing]);
    NSLog(@"Message 47: WCFViewController: secondLabelShowing: %@", [self secondLabelShowing]);
    
    CALayer *front;
    CALayer *back;    
    CGFloat startValueFront, endValueFront, startValueBack, endValueBack;
    
    if ([firstLayerStatus isEqual:@"DOWN"] && [firstLabelShowing isEqual:@"COUNTRY"]) {
        NSLog(@"Message 53: WCFViewController: ");
        front = [[self myView] secondLayer];
        back = [[self myView] firstLayer];
        startValueFront = 0.0f;
        endValueFront = M_PI;
        startValueBack = -M_PI;
        endValueBack = 0.0f;
    } 
    
    if ([firstLayerStatus isEqual:@"UP"] && [firstLabelShowing isEqual:@"COUNTRY"]) {
        NSLog(@"Message 54: WCFViewController: ");
        front = [[self myView] firstLayer];
        back = [[self myView] secondLayer];
        startValueFront = 0.0f;
        endValueFront = -M_PI;
        startValueBack = M_PI;
        endValueBack = 0.0f;
    }    
        
    if ([firstLayerStatus isEqual:@"DOWN"] && [firstLabelShowing isEqual:@"CAPITAL"]) {
        NSLog(@"Message 40: WCFViewController: ");
        front = [[self myView] firstLayer];
        back = [[self myView] secondLayer];
        startValueFront = M_PI;;
        endValueFront = 0.0;
        startValueBack = 0.0;
        endValueBack = -M_PI;        
    }
    
    if ([firstLayerStatus isEqual:@"UP"] && [firstLabelShowing isEqual:@"CAPITAL"]) {
        NSLog(@"Message 56: WCFViewController: ");
        front = [[self myView] secondLayer];  
        back = [[self myView] firstLayer];    
        startValueFront = -M_PI;  
        endValueFront = 0.0;
        startValueBack = 0.0;
        endValueBack = M_PI;        
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
    NSLog(@"Message 8: WCFViewController: About to do THE ACTUAL FLIPPING");
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
    NSLog(@"Message 3: WCFViewController: I am in animationDidStop");
    NSLog(@"Message 73: WCFViewController: Current country is: %@", [currentCountry countryName]);
    
    if ([[animation valueForKey:@"animationType"] isEqual:@"swipeUpAnim"]) {
        NSLog(@"Message 24: WCFViewController: isEqual swipeUpAnim executing");
        NSLog(@"Message 33: WCFViewController: Current country is: %@", [currentCountry countryName]);
        // Actually remove the card from the pack
        [[WCFCountryStore sharedStore] removeCard:currentCountry];
        // Update label
        [self refreshCountLabel];        
    }
    
    if ([[animation valueForKey:@"animationType"] isEqual:@"swipeUpAnim"] ||
        [[animation valueForKey:@"animationType"] isEqual:@"swipeLeftAnim"]) {
        NSLog(@"Message 34: WCFViewController: Swipe has ended.");
        [self showNextCard];
    }

    if ([[animation valueForKey:@"animationType"] isEqual:@"flipAnim"]) {
        NSLog(@"Message 4: WCFViewController: We are in flipStop");
        
        // reverse layer statuses
        if ([firstLayerStatus isEqual:@"UP"]) {
            [self setFirstLayerStatus:@"DOWN"];
            [self setSecondLayerStatus:@"UP"];
        } else {            
            [self setFirstLayerStatus:@"UP"];
            [self setSecondLayerStatus:@"DOWN"];
        }
    }
    
	isTransitioning = NO;
}

- (void)refreshCountLabel
{    
    NSString *myFormat;
    if ([[WCFCountryStore sharedStore] numCardsRemaining] == 1) {
        NSLog(@"Message 23: WCFViewController: One more card");
        myFormat = @"%d card remaining / %d cards total";
    } else {
        myFormat = @"%d cards remaining / %d cards total";
    }
    
    countLabel.text = [NSString stringWithFormat:myFormat, [[WCFCountryStore sharedStore] numCardsRemaining],
                       [[WCFCountryStore sharedStore] numCardsTotal]];    
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
    
    // Animate the card leaving to the left 
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
    NSLog(@"Message 42: WCFViewController: showNextCard executing.");    
    
    WCFView *theView = [self myView];
    
    // Get a random card from the card that
    //  remain in the pack.
    Country *c = [[WCFCountryStore sharedStore] getRandomCardFromRemaining];
    [self setCurrentCountry:c];
   
    if ([secondLayerStatus isEqual:@"UP"]) {
        [[theView firstLabel] updateLabel:[c capital]];
        [[theView secondLabel] updateLabel:[c countryName]];
        
        [self setFirstLabelShowing:@"CAPITAL"];
        [self setSecondLabelShowing:@"COUNTRY"];
        
    } else {
        [[theView firstLabel] updateLabel:[c countryName]];
        [[theView secondLabel] updateLabel:[c capital]];
        
        [self setFirstLabelShowing:@"COUNTRY"];
        [self setSecondLabelShowing:@"CAPITAL"];        
    }    
    // Animate moving the new card in from the right 
    CALayer *country = [theView firstLayer];
    CALayer *capital = [theView secondLayer];
    CGRect bounds = [theView bounds];
    CGPoint endPoint = CGPointMake(theView.bounds.size.width / 2, theView.bounds.size.height / 2);
    NSLog(@"Message 57: WCFViewController: endPoint: x: %f y: %f", endPoint.x, endPoint.y);
    
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
    [nmcView setTag:10];
    [self.view addSubview:nmcView];
    UILabel *nmcLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 50)];
   
    [nmcLabel setText:@"No more cards!\nTap to restart game"];
    [nmcLabel setTextColor:[UIColor blackColor]];
    
    [nmcLabel setTextAlignment: NSTextAlignmentCenter];  
    
    [nmcLabel setBackgroundColor:[UIColor clearColor]];
    [nmcLabel setFont:[UIFont systemFontOfSize:16.0]];
    [nmcLabel setNumberOfLines:0];
       
    [nmcView addSubview:nmcLabel];    
}

@end
