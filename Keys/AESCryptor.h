//
//  AESCryptor.h
//  Keys
//
//  Created by Sorin Lumezeanu on 3/6/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

#ifndef AESCryptor_h
#define AESCryptor_h

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>

typedef enum{
    AES128 = 0,
    AES192 = 1,
    AES256 = 2
} AESAlgorithm;

@interface AESCryptor : NSObject

@property(readonly) int keySize;
@property(readonly) int keyDerivationRounds;
@property(readonly) int saltSize;
@property(readonly) int blockSize;

+ (id)createWithAlgorithm:(AESAlgorithm)algorithm;
- (id)init;

- (NSData*)generateSalt;
- (NSData*)generateKeyFromPassphrase:(NSString *)passphrase andSalt:(NSData*)salt;
- (NSData*)generateInitializationVector;
- (NSData*)encrypt:(NSData*)data withKey:(NSData*)key initializationVector:(NSData*)iv;
- (NSData*)decrypt:(NSData*)data withKey:(NSData*)key initializationVector:(NSData*)iv;

@end

#endif /* AESCryptor_h */
