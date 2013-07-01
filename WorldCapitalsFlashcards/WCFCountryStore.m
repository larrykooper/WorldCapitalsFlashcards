//
//  WCFCountryStore.m
//  WorldCapitalsFlashcards
//
//  Created by Kooper, Laurence on 6/28/13.
//  Copyright (c) 2013 Kooper, Laurence. All rights reserved.
//

#import "WCFCountryStore.h"
#import "Country.h"

@implementation WCFCountryStore

// Will initialize the store with all countries 
+ (WCFCountryStore *)sharedStore
{
    static WCFCountryStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self loadAllCountries];
    }
    return self;
}

- (NSArray *)allCountries
{
    return allCountries;
}

- (BOOL)loadAllCountries
{
    allCountries = [[NSMutableArray alloc] init];
    
    NSArray *countries =
    [NSArray arrayWithObjects:@"Afghanistan", @"Albania", @"Algeria", @"Andorra", @"Angola",
     @"Antigua and Barbuda", @"Argentina", @"Armenia", @"Australia", @"Austria", nil];
    
    NSArray *capitals =
    [NSArray arrayWithObjects:@"Kabul", @"Tirana", @"Algiers", @"Andorra la Vella", @"Luanda",
     @"St. John's", @"Buenos Aires", @"Yerevan", @"Canberra", @"Vienna", nil];
    
    NSInteger capIndex = 0;
    for (NSString *country in countries) {
        Country *c = [[Country alloc] initWithName:country capital:[capitals objectAtIndex:capIndex]];
        capIndex++;
        [allCountries addObject:c];
    }    
    
    return YES;    
}

@end
