//
//  BencodeParser.h
//  ls-btreader
//
//  Created by Laurens Coderre on 17-07-11.
//  Copyright © 2017 Laurens Coderre. All rights reserved.
//

#ifndef BencodeParser_h
#define BencodeParser_h

#import "NSString+Bencode.h"


@interface BencodeParsingResult : NSObject

@property NSString* rest;
@property id element;
//@property NSString* type;

- (void) setElement: (id) element Rest:(NSString*) rest;

@end


@implementation BencodeParsingResult

- (void) setElement: (id) element Rest:(NSString*) rest {
    _rest = rest;
    _element = element;
//    _type = type;
}

//- (id) initWith

@end





@interface BencodeParser : NSObject

+ (BencodeParsingResult*) parseString: (NSString*) input;

@end

@implementation BencodeParser

+ (BencodeParsingResult*) parseString: (NSString*) input{

    
//    unichar firstChar = [input characterAtIndex:0];
    
    if ([input startsWith:'d']){ // dictionary
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
        
        
    } else if ([input startsWith:'l']){ // list
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
        
    } else if ([input startsWith:'i']){ // integer
        NSLog(@"has to implement");
        
    } else { // normal string
        NSString* strValue = [input parseFirstStringValue];
        NSString* rest = [input getRestAfterStringValue];
        
        
        BencodeParsingResult* ret = [[BencodeParsingResult alloc] init];
        [ret setElement:strValue Rest:rest];
        return ret;
    }
    
    return [[BencodeParsingResult alloc] init];
}



@end


#endif /* BencodeParser_h */
