//
//  SecurityServices.m
//  Keys
//
//  Created by Sorin Lumezeanu on 3/6/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

#import "SecurityServices.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>

@implementation SecurityServices : NSObject

const CCAlgorithm kAlgorithm = kCCAlgorithmAES128;
const NSUInteger kAlgorithmKeySize = kCCKeySizeAES128;
const NSUInteger kAlgorithmBlockSize = kCCBlockSizeAES128;
const NSUInteger kAlgorithmIVSize = kCCBlockSizeAES128;
const NSUInteger kPBKDFSaltSize = 8;
const NSUInteger kPBKDFMilliseconds = 100;

const NSUInteger kPBKDFRounds = 10000;  // ~80ms on an iPhone 4

- (NSData*)generateSalt
{
    return [self generateRandomDataOfLength:8];
}

- (NSData*)generateAESKeyFromPassphrase:(NSString *)passphrase andSalt:(NSData*)salt
{
    NSData* passphraseData = [passphrase dataUsingEncoding:NSUTF8StringEncoding];
    
//    int rounds = CCCalibratePBKDF(kCCPBKDF2,
//                                  passphraseData.length,
//                                  salt.length,
//                                  kCCPRFHmacAlgSHA256,
//                                  kCCKeySizeAES128,
//                                  100); // how many rounds for finising in 100ms?
    int rounds = 10000;
    
    NSMutableData *derivedKey = [NSMutableData dataWithLength:kCCKeySizeAES128];
    
    int result = CCKeyDerivationPBKDF(kCCPBKDF2,
                                      passphraseData.bytes,
                                      passphraseData.length,
                                      salt.bytes,
                                      salt.length,
                                      kCCPRFHmacAlgSHA256,
                                      rounds,
                                      derivedKey.mutableBytes,
                                      derivedKey.length);
    if (result != kCCSuccess)
    {
        NSLog(@"Unable to generate AES key.");
        return nil;
    }

    return derivedKey;
    
    
//    NSMutableData *
//    derivedKey = [NSMutableData dataWithLength:kAlgorithmKeySize];
//    
//    int
//    result = CCKeyDerivationPBKDF(kCCPBKDF2,            // algorithm
//                                  passphrase.UTF8String,  // password
//                                  [passphrase lengthOfBytesUsingEncoding:NSUTF8StringEncoding],  // passwordLength
//                                  salt.bytes,           // salt
//                                  salt.length,          // saltLen
//                                  kCCPRFHmacAlgSHA1,    // PRF
//                                  kPBKDFRounds,         // rounds
//                                  derivedKey.mutableBytes, // derivedKey
//                                  derivedKey.length); // derivedKeyLen
//    
//    // Do not log password here
//    NSAssert(result == kCCSuccess,
//             @"Unable to create AES key for password: %d", result);
//    
//    return derivedKey;
}


- (NSData*)generateAESInitializationVector
{
    return [self generateRandomDataOfLength:kCCBlockSizeAES128];
}

- (NSData*)encrypt:(NSData*)data withKey:(NSData*)key initializationVector:(NSData*)iv
{
    size_t outLength;
    NSMutableData *cipherData = [NSMutableData dataWithLength:data.length + kCCBlockSizeAES128];
    
    CCCryptorStatus
    result = CCCrypt(kCCEncrypt,                // operation
                     kCCAlgorithmAES128,        // Algorithm
                     kCCOptionPKCS7Padding,     // options
                     key.bytes,                 // key
                     key.length,                // keylength
                     iv.bytes,                  // iv
                     data.bytes,                // dataIn
                     data.length,               // dataInLength,
                     cipherData.mutableBytes,   // dataOut
                     cipherData.length,         // dataOutAvailable
                     &outLength);               // dataOutMoved
    
    if (result != kCCSuccess)
    {
        NSLog(@"Unable to encrypt data");
        return nil;
    }
    
    cipherData.length = outLength;
    return cipherData;
}

- (NSData*)decrypt:(NSData*)data withKey:(NSData*)key initializationVector:(NSData*)iv
{
    size_t outLength;
    NSMutableData *cleartextData = [NSMutableData dataWithLength:data.length + kCCBlockSizeAES128];
    
    CCCryptorStatus
    result = CCCrypt(kCCDecrypt,                // operation
                     kCCAlgorithmAES128,        // Algorithm
                     kCCOptionPKCS7Padding,     // options
                     key.bytes,                 // key
                     key.length,                // keylength
                     iv.bytes,                  // iv
                     data.bytes,                // dataIn
                     data.length,               // dataInLength,
                     cleartextData.mutableBytes,   // dataOut
                     cleartextData.length,         // dataOutAvailable
                     &outLength);               // dataOutMoved
    
    if (result != kCCSuccess)
    {
        NSLog(@"Unable to decrypt data");
        return nil;
    }
    
    cleartextData.length = outLength;
    return cleartextData;
}

- (NSData*)generateRandomDataOfLength:(size_t)numberOfBytes
{
    NSMutableData *salt = [NSMutableData dataWithLength:numberOfBytes];
    
    int result = SecRandomCopyBytes(kSecRandomDefault,
                                    numberOfBytes,
                                    salt.mutableBytes);
    if (result != 0) {
        NSLog(@"Unable to generate %zu random bytes.", numberOfBytes);
        return nil;
    }
    
    return salt;
}

@end

