//
//  NSData+ErrorHandling.h
//  Keys
//
//  Created by Sorin Lumezeanu on 3/8/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (ErrorHandling)

- (NSData *)trySubdataWithRange:(NSRange)range error:(NSError **)error;

@end
