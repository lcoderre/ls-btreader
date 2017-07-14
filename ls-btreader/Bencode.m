//
//  Bencode.m
//  ls-btreader
//
//  Created by Laurens Coderre on 17-07-13.
//  Copyright © 2017 Laurens Coderre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bencode.h"
#import "NSString+Bencode.h"

@interface BencodeParsingResult : NSObject

@property NSString* rest;
@property id element;

- (void) setElement: (id) element Rest:(NSString*) rest;

@end


@implementation BencodeParser

+ (id) decode: (NSString*) input {
    
    @try {
        BencodeParsingResult* result = [BencodeParser parseString:input];
        
        if (result.rest && result.rest.length > 0) {
            NSException* myException = [NSException
                                        exceptionWithName:@"BencodeDecodingException"
                                        reason:@"Input is erroneous or decoding failed."
                                        userInfo:nil];
            [myException raise];
        }
        
        return result.element;
    } @catch (NSException *exception) {
        NSException* myException = [NSException
                                    exceptionWithName:@"BencodeDecodingException"
                                    reason:@"Input is erroneous or decoding failed."
                                    userInfo:nil];
        [myException raise];
    }
    
}

+ (BencodeParsingResult*) parseString: (NSString*) input{
    
    if ([input startsWith:'d']){ // dictionary
        return [BencodeParser processDictionary:input];
    } else if ([input startsWith:'l']){ // list
        return [BencodeParser processList:input];
        
    } else if ([input startsWith:'i']){
        return [BencodeParser processNumber:input];
        
    } else { // normal string
        return [BencodeParser processString:input];
    }
    
    return nil;
}

+ (BencodeParsingResult*) processDictionary: (NSString*) input {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    NSString* rest = [input rest];
    
    while (![rest startsWith:'e']) {
        NSString* key = [rest parseFirstStringValue];
        
        rest = [rest getRestAfterStringValue];
        BencodeParsingResult* localResult = [BencodeParser parseString:rest];
        NSDictionary* localDict = [[NSDictionary alloc] initWithObjectsAndKeys:localResult.element, key, nil];
        
        [dict addEntriesFromDictionary:localDict];
        
        rest = localResult.rest;
    }
    
    BencodeParsingResult* ret = [[BencodeParsingResult alloc] init];
    [ret setElement:dict Rest: [rest rest]];
    
    return ret;
    
}

+ (BencodeParsingResult*) processList: (NSString*) input {
    NSArray* array = [[NSArray alloc] init];
    NSString* rest = [input rest];
    
    while (![rest startsWith:'e']) {
        BencodeParsingResult* localResult = [BencodeParser parseString:rest];
        
        array = [array arrayByAddingObject: localResult.element];
        rest = localResult.rest;
    }
    
    BencodeParsingResult* ret = [[BencodeParsingResult alloc] init];
    if ([array count] == 1) {
        [ret setElement:array.firstObject Rest:[rest rest]];
    } else {
        [ret setElement:array Rest:[rest rest]];
    }
    
    return ret;
}

+ (BencodeParsingResult*) processNumber: (NSString*) input {
    NSNumber* intValue = [[input rest] parseFirstIntValue];
    NSString* rest = [[input rest] getRestAfterIntValue];
    
    if (!intValue) {
        NSException* myException = [NSException
                                    exceptionWithName:@"BencodeDecodingException"
                                    reason:@"Input is erroneous or Integer decoding failed"
                                    userInfo:nil];
        [myException raise];
    }
    
    BencodeParsingResult* ret = [[BencodeParsingResult alloc] init];
    [ret setElement:intValue Rest:rest];
    return ret;
}

+ (BencodeParsingResult*) processString:(NSString*) input {
    NSString* strValue = [input parseFirstStringValue];
    NSString* rest = [input getRestAfterStringValue];
    
    if (!strValue) {
        NSException* myException = [NSException
                                    exceptionWithName:@"BencodeDecodingException"
                                    reason:@"Input is erroneous or String decoding failed"
                                    userInfo:nil];
        [myException raise];
    }
    BencodeParsingResult* ret = [[BencodeParsingResult alloc] init];
    [ret setElement:strValue Rest:rest];
    return ret;

}

@end







@implementation BencodeParsingResult

- (void) setElement: (id) element Rest:(NSString*) rest {
    _rest = rest;
    _element = element;
}

@end

