//
//  WCFViewController.h
//  WorldCapitalsFlashcards
//
//  Created by Kooper, Laurence on 6/27/13.
//  Copyright (c) 2013 Kooper, Laurence. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <QuartzCore/QuartzCore.h>

@interface WCFViewController : UIViewController
{
	BOOL isTransitioning;
}

- (void)flip;
- (void)removeCard;

@end