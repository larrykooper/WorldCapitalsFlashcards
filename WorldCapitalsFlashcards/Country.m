//
//  Country.m
//  WorldCapitalsFlashcards
//
//  Created by Kooper, Laurence on 6/28/13.
//  Copyright (c) 2013 Kooper, Laurence. All rights reserved.
//

#import "Country.h"

@implementation Country

@synthesize countryName, capital;

- (id)initWithName:(NSString *)name
           capital:(NSString *)cap
{
    self = [super init];
    
    if (self) {    
        [self setCountryName:name];
        [self setCapital:cap];
    }
    return self;
}

- (id)init
{
    return [self initWithName:@"Country" capital:@"None"];
}

@end
