//
//  NSString+Bencode.h
//  ls-btreader
//
//  Created by Laurens Coderre on 17-07-12.
//  Copyright © 2017 Laurens Coderre. All rights reserved.
//

#ifndef NSString_Bencode_h
#define NSString_Bencode_h


@implementation NSString (Bencode)

- (bool) startsWith: (unichar) character {
    if (self.length == 0){ return false; }
    
    unichar firstChar = [self characterAtIndex:0];

    return firstChar == character;
}

- (NSString*) rest {
    return [self substringFromIndex:1];
}

- (NSString*) parseFirstStringValue {
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\d+)"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error) {
        
        NSException* myException = [NSException
                                    exceptionWithName:@"BencodeDecodingException"
                                    reason:@"Could not match regex and find string length."
                                    userInfo:nil];
        [myException raise];
    }
    
    NSRange matchRange = [regex rangeOfFirstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
    
    NSString* stringLengthAsString = [self substringWithRange:matchRange];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *stringLength = [f numberFromString:stringLengthAsString];
    
    
    NSString* string = [[self substringFromIndex:matchRange.length + 1] substringToIndex:stringLength.unsignedIntegerValue];
    
    return string;
}

- (NSString*) getRestAfterStringValue {
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\d+)"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error) {
        
        NSException* myException = [NSException
                                    exceptionWithName:@"BencodeDecodingException"
                                    reason:@"Could not match regex and find string length."
                                    userInfo:nil];
        [myException raise];
    }
    
    NSRange matchRange = [regex rangeOfFirstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
    
    NSString* stringLengthAsString = [self substringWithRange:matchRange];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *stringLength = [f numberFromString:stringLengthAsString];
    
    
    NSString* string = [self substringFromIndex:matchRange.length + 1 + stringLength.unsignedIntegerValue];
    
    return string;
}



- (NSNumber*) parseFirstIntValue {
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(-?\\d+)"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    if (error) {

            NSException* myException = [NSException
                                        exceptionWithName:@"BencodeDecodingException"
                                        reason:@"Could not match integer regex to input"
                                        userInfo:nil];
            [myException raise];

    }
    
    NSRange matchRange = [regex rangeOfFirstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
    
    NSString* integerAsString = [self substringWithRange:matchRange];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *number = [f numberFromString:integerAsString];
    
    return number;
}

- (NSString*) getRestAfterIntValue {
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(-?\\d+)"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error) {
        
        NSException* myException = [NSException
                                    exceptionWithName:@"BencodeDecodingException"
                                    reason:@"Could not match integer regex to input"
                                    userInfo:nil];
        [myException raise];
        
    }
    
    NSRange matchRange = [regex rangeOfFirstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
    
    return [self substringFromIndex:matchRange.length + 1];
}


@end

#endif /* NSString_Bencode_h */
