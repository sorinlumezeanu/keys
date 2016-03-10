//
//  NSException+Convertor.h
//  Keys
//
//  Created by Sorin Lumezeanu on 3/8/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSException (Convertor)

- (NSError*)convertToNSError;

@end
