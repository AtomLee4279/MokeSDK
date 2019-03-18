//
//  AMAES.m
//  AnimSDK
//
//  Created by  Yvan Hall on 2019/1/2.
//  Copyright © 2019  Yvan Hall. All rights reserved.
//

#import "AMAES.h"

#import "AMBase64.h"
//#import "AMResponseData.h"
#import <CommonCrypto/CommonCryptor.h>

static NSString *const PSW_AES_KEY      = @"anim";
static NSString *const AES_IV_PARAMETER = @"aes0123456543210";
static NSString *const V_KEY            = @"0123456789012345";

@implementation AMAES

+ (NSString *)AMCBCEncrypt:(NSString *)str {
    
    NSLog(@"AES Source String:%@\n", str);
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSData *AESData = [self AES128operation:kCCEncrypt
                                       data:data
                                        key:PSW_AES_KEY
                                         iv:AES_IV_PARAMETER];
    NSString *baseStr = [AESData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
//    LOG(@"AES key:%@\n", PSW_AES_KEY);
//    LOG(@"AES Encrypt String: %@\n", baseStr);
    return baseStr;
}

+ (NSString *)AMCBCDecrypt:(NSString *)str {
    
    NSData *baseData = [[NSData alloc]initWithBase64EncodedString:str options:0];
    
    NSData *AESData = [self AES128operation:kCCDecrypt
                                       data:baseData
                                        key:PSW_AES_KEY
                                         iv:AES_IV_PARAMETER];
    NSString *decStr = [[NSString alloc] initWithData:AESData encoding:NSUTF8StringEncoding];
    
//    LOG(@"AES key:%@\n", PSW_AES_KEY);
//    LOG(@"AES Decrypt String: %@\n", decStr);
    
    return decStr;
}

/**
 *  AES加解密算法
 *
 *  @param operation kCCEncrypt（加密）kCCDecrypt（解密）
 *  @param data      待操作Data数据
 *  @param key       key
 *  @param iv        向量
 *
 *  @return 数据
 */
+ (NSData *)AES128operation:(CCOperation)operation data:(NSData *)data key:(NSString *)key iv:(NSString *)iv {
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    // IV
    char ivPtr[kCCBlockSizeAES128 + 1];
    bzero(ivPtr, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptorStatus = CCCrypt(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                            keyPtr, kCCKeySizeAES128,
                                            ivPtr,
                                            [data bytes], [data length],
                                            buffer, bufferSize,
                                            &numBytesEncrypted);
    
    if(cryptorStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted]; 
    }
    
    free(buffer);
    return nil;
}

// 加密方法
+ (NSString*)AMECBEncrypt:(NSString*)plainText encryptKey:(NSString *)encryptkey {
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCKeySizeAES128) & ~(kCCKeySizeAES128 - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = [V_KEY UTF8String];
    const void *vinitVec = NULL;
//    LOG(@"vkey: %s", vkey);
    CCCrypt(kCCEncrypt,
            kCCAlgorithmAES128,
            kCCOptionPKCS7Padding | kCCOptionECBMode,
            vkey,
            kCCKeySizeAES128,
            vinitVec,
            vplainText,
            plainTextBufferSize,
            (void *)bufferPtr,
            bufferPtrSize,
            &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString *result = [AMBase64 stringByEncodingData:myData];
    free(bufferPtr);
//    LOG(@"encryptText: %@", result);
    return result;
}

// 解密方法
+ (NSString*)AMECBDecrypt:(NSString*)encryptText encryptKey:(NSString *)encryptkey {
    NSData *decodeData = [AMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
    size_t plainTextBufferSize = [decodeData length];
    const void *vplainText = [decodeData bytes];
    
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    bufferPtrSize = (plainTextBufferSize + kCCKeySizeAES128) & ~(kCCKeySizeAES128 - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void *vkey = [V_KEY UTF8String];
    const void *vinitVec = NULL;
    CCCrypt(kCCDecrypt,
            kCCAlgorithmAES,
            kCCOptionPKCS7Padding | kCCOptionECBMode,
            vkey,
            kCCKeySizeAES128,
            vinitVec,
            vplainText,
            plainTextBufferSize,
            (void *)bufferPtr,
            bufferPtrSize,
            &movedBytes);
    
    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                     length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    free(bufferPtr);
//    LOG(@"encryptText: %@", encryptText);
//    LOG(@"decode aes: %@", result);
    return result;
}

@end
