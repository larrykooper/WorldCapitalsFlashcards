//
//  WCFViewController.m
//  WorldCapitalsFlashcards
//
//  Created by Kooper, Laurence on 6/27/13.
//  Copyright (c) 2013 Kooper, Laurence. All rights reserved.
//
// Code from Gary Myers
// http://www.mycodestudio.com/blog/2011/01/10/coreanimation/

#import "WCFViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WCFView.h"

@implementation WCFViewController

#pragma mark - Initialization Code

 - (void)loadView
{
    NSLog(@"loadView was called.");
    [self setView:[[WCFView alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
    [[self myView] setMyController:self];
}

#pragma mark - Animation code 

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
    //[swipeAnimation setDuration:aDuration];
    return swipeAnimation;    
}

// Flip code should be here, in the controller 
- (void)flip
{
    // If we are currently transitioning, ignore any further taps on the
    // card until we are done
	if (isTransitioning) {
		return;
    }
    
    CALayer *front;
    CALayer *back;    
    CGFloat startValueFront, endValueFront, startValueBack, endValueBack;
    
    if (![[self myView] isFlipped]) {
        front = [[self myView] countryLayer];
        back = [[self myView] capitalLayer];
        startValueFront = 0.0f;
        endValueFront = -M_PI;
        startValueBack = M_PI;
        endValueBack = 0.0f;
    } else {
        front = [[self myView] capitalLayer];
        back = [[self myView] countryLayer];
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
    
    // We set the delegate to find out when the animation has stopped 
    frontAnimation.delegate = self;
    [CATransaction begin];
    [front addAnimation:frontAnimation forKey:@"flip"];
    [back addAnimation:backAnimation forKey:@"flip"];
    [CATransaction commit];
	
}

- (void)removeCard
{
    if (isTransitioning) {
        return;
    }
    CAAnimationGroup *removeCard = [CAAnimationGroup animation]; // create instance
    [removeCard setDuration:1.0];
    CALayer *first = [[self myView] countryLayer];
    CALayer *second = [[self myView] capitalLayer];
    
    CGFloat endPointY = 0.0 - (cardHeight / 2.0);
    
    CGPoint startPoint = CGPointMake([first position].x, [first position].y);
    CGPoint endPoint = CGPointMake([first position].x, endPointY);
    
    CAAnimation *firstAnimation = [self swipeAnimationWithDuration:1.0
                                                        startPoint:startPoint
                                                          endPoint:endPoint];
    
    CAAnimation *secondAnimation = [self swipeAnimationWithDuration:0.5f
                                                         startPoint:startPoint
                                                           endPoint:endPoint];
    
    [removeCard setAnimations:[NSArray arrayWithObjects:firstAnimation, secondAnimation, nil]];
    
    [removeCard setDelegate:self];
    [first setPosition:endPoint];
    [second setPosition:endPoint];
    [first addAnimation:removeCard forKey:@"removeCard"];
    //[first lkhere]
    // I was going to set the textlayer to nil to destroy it
    // But on second thought, I would like to recycle it
    // See Evernote 
//    [CATransaction begin];
//    [first addAnimation:firstAnimation forKey:@"swipe"];
//    [second addAnimation:secondAnimation forKey:@"swipe"];
//    [CATransaction commit];
   
    
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
    // This currently works for both animations, the flip and the swipe.
    NSLog(@"animationDidStop has been called.");
    NSLog(@"%@ finished: %d", animation, flag);
    NSLog(@"value for key: %@", [animation valueForKey:@"id"]);
    if ([[animation valueForKey:@"id"] isEqual:@"flip"]) {
        [[self myView] setIsFlipped:![[self myView] isFlipped]];
    
    }
    if ([[animation valueForKey:@"id"] isEqual:@"swipe"]) {
        [self showNextCard];
    }
    	
	isTransitioning = NO;
}
             
- (WCFView *)myView
{
    return (WCFView *)[self view];
}

// Called when user rotates the device
- (BOOL)shouldAutorotate
{
    //NSLog(@"shouldAutorotate was called.");
    [[self myView] rotateMe];
    return YES;
}

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad was called.");    
    
    // Set swipe instrs
    
    UILabel *instrsLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 320, 300, 30)];
    [self.view addSubview:instrsLabel];
    
    instrsLabel.text = @"Swipe up: remove card\nSwipe left: try card again later";
    instrsLabel.textColor = [UIColor blackColor];
    
    instrsLabel.textAlignment = NSTextAlignmentLeft;
    instrsLabel.backgroundColor = [UIColor clearColor];
    instrsLabel.font = [UIFont systemFontOfSize:12.0];
    instrsLabel.numberOfLines = 0;

}

- (void)tryAgainLater
{
    NSLog(@"tryAgainLater was called.");
}

- (void)showNextCard
{
    NSLog(@"showNextCard executing.");
    // This needs to get a random country from the countries that
    //  user has NOT removed from pack yet.
    WCFView *theView = [self myView];
    CALayer *country = [theView countryLayer];
    CALayer *capital = [theView capitalLayer];
    CGRect bounds = [theView bounds];
    CGPoint endPoint = [theView center];
    
    CGFloat startPointX =  bounds.size.width + (cardWidth / 2.0);
    
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
    [country addAnimation:countryAnimation forKey:@"newcard"];
    [capital addAnimation:capitalAnimation forKey:@"newcard"];
    [CATransaction commit];
    
    
    
   
    //CATextLayer *countryTextLayer = [[self myView] makeLabel:@"Egypt"];
    //[[[self myView] countryLayer] addSublayer:countryTextLayer];
}

@end
