//
//  BitTorrent.m
//  ls-btreader
//
//  Created by Laurens Coderre on 17-07-13.
//  Copyright © 2017 Laurens Coderre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BitTorrent.h"


@implementation BitTorrent

+ (BitTorrent*) initWithTorrentInfoDictionary: (NSDictionary*) dict {
    BitTorrent* bt = [[BitTorrent alloc] init];
    
    bt.torrentInfo = dict;
    return bt;
}

- (NSArray*) urlTrackers {
    NSArray* announceList = [self.torrentInfo objectForKey:@"announce-list"];
    
    if (announceList != nil) {
        return announceList;
    } else {
        NSString* announce = [self.torrentInfo objectForKey:@"announce"];
        if (announce != nil) {
            return [NSArray arrayWithObject:announce];
        }
    }
    
    return nil;
}

- (NSString*) torrentName {
    NSDictionary* infoDict = [self.torrentInfo objectForKey:@"info"];
    
    if (infoDict != nil) {
        NSString* name = [infoDict objectForKey:@"name"];
        
        if (name != nil) {
            return name;
        }
    }
    
    return nil;
}

- (NSDate*) creationDate {
    NSNumber* creationTimestamp = [self.torrentInfo objectForKey:@"creation date"];
    
    if (creationTimestamp != nil) {
        
        NSDate* creationDate = [NSDate dateWithTimeIntervalSince1970:creationTimestamp.doubleValue];
        
        if (creationDate != nil) {
            return creationDate;
        }
    }
    
    return nil;
}


- (NSString*) createdBy {
    NSString* createdBy = [self.torrentInfo objectForKey:@"created by"];
    
    if (createdBy != nil) {
        return createdBy;
    }
    
    return nil;
}


- (NSNumber *) pieceLength {
    NSDictionary* infoDict = [self.torrentInfo objectForKey:@"info"];
    
    if (infoDict != nil) {
        NSNumber* pieceLength = [infoDict objectForKey:@"piece length"];
        
        if (pieceLength != nil) {
            return pieceLength;
        }
    }
    
    return nil;
}

- (NSArray *) pieces {
    NSDictionary* infoDict = [self.torrentInfo objectForKey:@"info"];
    
    if (infoDict != nil) {
        NSString* bigPiece = [infoDict objectForKey:@"pieces"];
        
        if (bigPiece != nil) {
            
            NSArray* pieces = [[NSArray alloc] init];
            
            for (int i=0; i< bigPiece.length / 20; i++) {
                NSString* chunk = [[bigPiece substringFromIndex: i * 20] substringToIndex: 20];
                
                // Not sure if we want to display as HEX...
//                const char *utf8 = [chunk UTF8String];
//                
//                NSMutableString *hex = [NSMutableString string];
//                while ( *utf8 ) [hex appendFormat:@"%02X" , *utf8++ & 0x00FF];
                
                pieces = [pieces arrayByAddingObject:chunk];
            }
            
            return pieces;
        }
    }
    
    return nil;
}

- (NSArray *) files {
    NSDictionary* infoDict = [self.torrentInfo objectForKey:@"info"];
    
    if (infoDict != nil) {
        NSArray* files = [infoDict objectForKey:@"files"];
        
        if (files != nil) {
            return files;
        }
    }
    
    return nil;
}

@end
