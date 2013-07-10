//
//  WCFCountryStore.h
//  WorldCapitalsFlashcards
//
//  Created by Kooper, Laurence on 6/28/13.
//  Copyright (c) 2013 Kooper, Laurence. All rights reserved.
//
// A store object for the Country. Handles external access.

#import <Foundation/Foundation.h>
@class Country;

@interface WCFCountryStore : NSObject
{
    NSMutableArray *allCountries;
    NSMutableArray *remainingCards;
    // The stash is the ordered list of cards that the user has pushed to the left
    // It acts like a stack
    NSMutableArray *stash;
    // The stashCount is the current count of cards in the stash
    NSInteger stashCount;
}

+ (WCFCountryStore *)sharedStore;

- (NSArray *)allCountries;

- (BOOL)loadAllCountries;

- (void)removeCard:(Country *)country;

- (void)addCardToStash:(Country *)country;

- (Country *)getRandomCardFromRemaining;

- (NSInteger)numCardsRemaining;

- (NSInteger)numCardsStashed;

- (NSInteger)numCardsTotal;

- (BOOL)cardDeckEmpty;

- (void)setUpRemainingCards;

@end
