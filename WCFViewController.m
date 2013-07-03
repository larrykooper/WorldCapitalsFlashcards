//
//  WCFViewController.m
//  WorldCapitalsFlashcards
//
//  Created by Kooper, Laurence on 6/27/13.
//  Copyright (c) 2013 Kooper, Laurence. All rights reserved.
//
// Code from Gary Myers
// http://www.mycodestudio.com/blog/2011/01/10/coreanimation/
// MOTHERSHIP

#import "WCFViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WCFView.h"

@implementation WCFViewController

 - (void)loadView
{
    NSLog(@"Message 5: WCFViewController.m: loadView was called.");
    [self setView:[[WCFView alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
    [[self myView] setMyController:self];
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
    NSLog(@"Message 2: I am in flip");
    // If we are currently transitioning, ignore any further taps on the
    // card until we are done
	if (isTransitioning)
		return;
    
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
    [front addAnimation:frontAnimation forKey:@"flip"];
    [back addAnimation:backAnimation forKey:@"flip"];
    [CATransaction commit];
	
}

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
    [firstAnimation setValue:@"swipeAnim" forKeyPath:@"animationType"];
    [CATransaction begin];
    [first addAnimation:firstAnimation forKey:@"swipe1"];
    [second addAnimation:secondAnimation forKey:@"swipe2"];
    [CATransaction commit];

}


- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
    NSLog(@"Message 3: WCFViewController.m: I am in animationDidStop");
    
    if ([[animation valueForKey:@"animationType"] isEqual:@"swipeAnim"]) {
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

- (void)viewDidLoad
{
    NSLog(@"Message 6: WCFViewController.m: viewDidLoad was called.");
    
    UILabel *instrsLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 340, 300, 30)];
    [self.view addSubview:instrsLabel];

    instrsLabel.text = @"Swipe up: remove card\nSwipe left: try card again later";
    instrsLabel.textColor = [UIColor blackColor];

    instrsLabel.textAlignment = NSTextAlignmentLeft;
    instrsLabel.backgroundColor = [UIColor clearColor];
    instrsLabel.font = [UIFont systemFontOfSize:12.0];
    instrsLabel.numberOfLines = 0;

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
    [firstAnimation setValue:@"swipeAnim" forKeyPath:@"animationType"];
    //[firstAnimation setRemovedOnCompletion:NO];  // This stmt only needed if you want to use animationForKey
    
    //[first lkhere]
    // I was going to set the textlayer to nil to destroy it
    // But on second thought, I would like to recycle it
    // See Evernote
    [CATransaction begin];
    [first addAnimation:firstAnimation forKey:@"swipe1"];
    [second addAnimation:secondAnimation forKey:@"swipe2"];
    [CATransaction commit];        
}

- (void)showNextCard
{
    NSLog(@"showNextCard executing.");
    // This needs to get a random country from the countries that
    //  user has NOT removed from pack yet.
    // LKHERE START
    
    
    WCFView *theView = [self myView];
    CALayer *country = [theView firstLayer];
    CALayer *capital = [theView secondLayer];
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
    [country addAnimation:countryAnimation forKey:@"newcard1"];
    [capital addAnimation:capitalAnimation forKey:@"newcard2"];
    [CATransaction commit];
    
    //CATextLayer *countryTextLayer = [[self myView] makeLabel:@"Some Country"];
    //[[[self myView] countryLayer] addSublayer:countryTextLayer];
}

@end
