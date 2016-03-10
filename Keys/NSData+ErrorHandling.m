//
//  NSData+ErrorHandling.m
//  Keys
//
//  Created by Sorin Lumezeanu on 3/8/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

#import "NSData+ErrorHandling.h"
#import "NSException+Convertor.h"

@implementation NSData (ErrorHandling)

- (NSData *)trySubdataWithRange:(NSRange)range error:(NSError **)error
{
    @try {
        return [self subdataWithRange:range];
    }
    @catch (NSException *exception) {
        *error = [exception convertToNSError];
    }
}

@end
