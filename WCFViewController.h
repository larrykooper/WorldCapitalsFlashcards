//
//  WCFViewController.h
//  WorldCapitalsFlashcards
//
//  Created by Kooper, Laurence on 6/27/13.
//  Copyright (c) 2013 Kooper, Laurence. All rights reserved.
//
// Controller for the WCF's main view.

#import <Foundation/Foundation.h>

@interface WCFViewController : UIViewController
{
	BOOL isTransitioning;
}

- (void)flip;
- (void)removeCard;
- (void)tryCardAgainLater;

@end