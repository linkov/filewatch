//
//  SDWRecipe.h
//  Filewatch
//
//  Created by alex on 12/2/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

@class SDWRecipeCategory;

#import <Foundation/Foundation.h>

@interface SDWRecipe : NSObject

@property NSUInteger redLimit;
@property NSUInteger amberLimit;
@property NSUInteger offLimit;

@property (strong) NSString *name;
@property (strong) NSString *fileExtension;
@property (strong) NSString *regex;
@property (weak) SDWRecipeCategory *category;

@end
