//
//  AESCryptor.m
//  Keys
//
//  Created by Sorin Lumezeanu on 3/6/16.
//  Copyright © 2016 Sorin Lumezeanu. All rights reserved.
//

#import "AESCryptor.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>

@implementation AESCryptor : NSObject

- (id)init
{
    if (self = [super init])
    {
        [self configureWithAlgorithm:AES128];
        return self;
    }
    
    return nil;
}

+ (id)createWithAlgorithm:(AESAlgorithm)algorithm;
{
    AESCryptor *instance = [[AESCryptor alloc] init];
    [instance configureWithAlgorithm:algorithm];
    return instance;
}

- (void)configureWithAlgorithm:(AESAlgorithm)algorithm
{
    switch (algorithm)
    {
        case AES128:
            _keySize = kCCKeySizeAES128;            // 16 bytes
            _blockSize = kCCBlockSizeAES128;        // 16 bytes
            _saltSize = 8;                          // 8 bytes
            _keyDerivationRounds = 10000;           // takes ~80ms on an iPhone 4
            break;
            
        case AES192:
            _keySize = kCCKeySizeAES192;            // 24 bytes
            _blockSize = kCCBlockSizeAES128;        // 16 bytes  (only kCCBlockSizeAES128 supported)
            _saltSize = 8;                          // 8 bytes
            _keyDerivationRounds = 10000;           // takes ~80ms on an iPhone 4
            
        case AES256:
            _keySize = kCCKeySizeAES256;            // 32 bytes
            _blockSize = kCCBlockSizeAES128;        // 16 bytes (only kCCBlockSizeAES128 supported)
            _saltSize = 8;                          // 8 bytes
            _keyDerivationRounds = 10000;           // takes ~80ms on an iPhone 4
    }
}

- (NSData*)generateSalt
{
    return [self generateRandomDataOfLength:self.saltSize];
}

- (NSData*)generateInitializationVector
{
    return [self generateRandomDataOfLength:self.blockSize];
}

- (NSData*)generateKeyFromPassphrase:(NSString *)passphrase andSalt:(NSData*)salt
{
    NSData* passphraseData = [passphrase dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *derivedKey = [NSMutableData dataWithLength:self.keySize];
    
    int result = CCKeyDerivationPBKDF(kCCPBKDF2,
                                      passphraseData.bytes,
                                      passphraseData.length,
                                      salt.bytes,
                                      salt.length,
                                      kCCPRFHmacAlgSHA256,
                                      self.keyDerivationRounds,
                                      derivedKey.mutableBytes,
                                      derivedKey.length);
    if (result != kCCSuccess)
    {
        NSLog(@"Unable to generate AES key.");
        return nil;
    }

    return derivedKey;
}

- (NSData*)encrypt:(NSData*)data withKey:(NSData*)key initializationVector:(NSData*)iv
{
    size_t outLength;
    NSMutableData *cipherData = [NSMutableData dataWithLength:data.length + self.blockSize];
    
    CCCryptorStatus
    result = CCCrypt(kCCEncrypt,                // operation
                     kCCAlgorithmAES,        // algorithm
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
    NSMutableData *cleartextData = [NSMutableData dataWithLength:data.length + self.blockSize];
    
    CCCryptorStatus
    result = CCCrypt(kCCDecrypt,
                     kCCAlgorithmAES,
                     kCCOptionPKCS7Padding,
                     key.bytes,
                     key.length,
                     iv.bytes,
                     data.bytes,
                     data.length,
                     cleartextData.mutableBytes,
                     cleartextData.length,
                     &outLength);
    
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

