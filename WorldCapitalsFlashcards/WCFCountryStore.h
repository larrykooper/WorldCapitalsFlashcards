//
//  WCFCountryStore.h
//  WorldCapitalsFlashcards
//
//  Created by Kooper, Laurence on 6/28/13.
//  Copyright (c) 2013 Kooper, Laurence. All rights reserved.
//
// A store object for the Country. Handles external access.

#import <Foundation/Foundation.h>

@interface WCFCountryStore : NSObject
{
    NSMutableArray *allCountries;
}

+ (WCFCountryStore *)sharedStore;

- (NSArray *)allCountries;

- (BOOL)loadAllCountries;

//- (void)removeCard:  LKHERE

@end
