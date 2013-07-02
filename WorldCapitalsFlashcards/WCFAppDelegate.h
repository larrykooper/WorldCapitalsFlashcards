//
//  WCFAppDelegate.h
//  WorldCapitalsFlashcards
//
//  Created by Kooper, Laurence on 6/27/13.
//  Copyright (c) 2013 Kooper, Laurence. All rights reserved.
//
// Controls the WCF App.

#import <UIKit/UIKit.h>

@class WCFViewController;

@interface WCFAppDelegate : UIResponder <UIApplicationDelegate>

@property (weak, nonatomic) IBOutlet WCFViewController *viewController;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
