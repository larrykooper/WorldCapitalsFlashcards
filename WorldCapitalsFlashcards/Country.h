//
//  Country.h
//  WorldCapitalsFlashcards
//
//  Created by Kooper, Laurence on 6/28/13.
//  Copyright (c) 2013 Kooper, Laurence. All rights reserved.
//
// A Country models a world nation.

#import <Foundation/Foundation.h>

@interface Country : NSObject

@property (nonatomic, strong) NSString *countryName;
@property (nonatomic,strong) NSString *capital;

- (id)initWithName:(NSString *)name
           capital:(NSString *)capital;

@end
