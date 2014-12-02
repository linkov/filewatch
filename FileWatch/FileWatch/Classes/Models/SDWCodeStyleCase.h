//
//  SDWCodeStyleCase.h
//  Filewatch
//
//  Created by alex on 12/1/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDWCodeStyleCase : NSObject

@property (strong) NSString *type;
@property (strong) NSString *fileName;
@property NSRange position;
@property NSUInteger lineNumber;

@end
