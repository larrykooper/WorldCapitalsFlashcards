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

 - (void)loadView
{
    NSLog(@"loadView was called.");
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

// Flip code should be here, in the controller 
- (void)flip
{
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
    [CATransaction begin];
    [front addAnimation:frontAnimation forKey:@"flip"];
    [back addAnimation:backAnimation forKey:@"flip"];
    [CATransaction commit];
	
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
    [[self myView] setIsFlipped:![[self myView] isFlipped]];	
	isTransitioning = NO;
}
                
- (WCFView *)myView
{
    return (WCFView *)[self view];
}

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
     
    // Set button
//    UIButton *tryAgainBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [tryAgainBut addTarget:self
//                  action:@selector(tryAgainLater)
//        forControlEvents:UIControlEventTouchUpInside];
//    [tryAgainBut setTitle:@"Try Again Later" forState:UIControlStateNormal];
//    tryAgainBut.frame = CGRectMake(140.0, 330.0, 150.0, 44.0);
//    [tryAgainBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [[self view] addSubview:tryAgainBut];    

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
    CATextLayer *countryTextLayer = [[self myView] makeLabel:@"Egypt"];
    [[[self myView] firstLayer] addSublayer:countryTextLayer];
}


@end
