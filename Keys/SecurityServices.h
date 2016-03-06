//
//  SecurityServices.h
//  Keys
//
//  Created by Sorin Lumezeanu on 3/6/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

#ifndef SecurityServices_h
#define SecurityServices_h

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonKeyDerivation.h>

@interface SecurityServices : NSObject

- (NSData*)generateSalt;
- (NSData*)generateAESKeyFromPassphrase:(NSString *)passphrase andSalt:(NSData*)salt;
- (NSData*)generateAESInitializationVector;
- (NSData*)encrypt:(NSData*)data withKey:(NSData*)key initializationVector:(NSData*)iv;
- (NSData*)decrypt:(NSData*)data withKey:(NSData*)key initializationVector:(NSData*)iv;

@end

#endif /* SecurityServices_h */
