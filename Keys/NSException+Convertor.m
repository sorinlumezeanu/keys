//
//  NSException+Convertor.m
//  Keys
//
//  Created by Sorin Lumezeanu on 3/8/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

#import "NSException+Convertor.h"

@implementation NSException (Convertor)

- (NSError*)convertToNSError
{
    NSMutableDictionary *errorUserInfo = [NSMutableDictionary dictionary];
    
    //if ([self name] != nil)
        [errorUserInfo setValue:[self name] forKey:@"name"];
    //if ([self reason] != nil)
        [errorUserInfo setValue:[self reason] forKey:@"reason"];
    //if ([self userInfo] != nil)
        [errorUserInfo setValue:[self userInfo] forKey:@"userInfo"];
    
    return [NSError errorWithDomain:@"" code:0 userInfo:errorUserInfo];
}

@end

