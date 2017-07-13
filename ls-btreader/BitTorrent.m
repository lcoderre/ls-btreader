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
    
    NSLog(@"THROW? No announce or announce-list in torrent info dictionary");
    return nil;
}

- (NSString*) torrentName {
    NSDictionary* infoDict = [self.torrentInfo objectForKey:@"info"];
    
    if (infoDict != nil) {
        NSString* name = [infoDict objectForKey:@"name"];
        
        if (name != nil) {
            return name;
        } else {
            NSLog(@"THROW? No 'name' key-value in 'info' dictionary");
        }
    } else {
        NSLog(@"THROW? No 'info' dictionary");
    }
    
    return nil;
}

- (NSDate*) creationDate {
    NSNumber* creationTimestamp = [self.torrentInfo objectForKey:@"creation date"];
    
    if (creationTimestamp != nil) {
        
        NSDate* creationDate = [NSDate dateWithTimeIntervalSince1970:creationTimestamp.doubleValue];
        
        if (creationDate != nil) {
            return creationDate;
        } else {
            NSLog(@"THROW? Could not make a NSDate from value %@", creationTimestamp);
        }
    } else {
        NSLog(@"THROW? No 'creation date' key-value");
    }
    
    return nil;
}


- (NSString*) createdBy {
    NSString* createdBy = [self.torrentInfo objectForKey:@"created by"];
    
    if (createdBy != nil) {
        return createdBy;
    } else {
        NSLog(@"THROW? No 'created by' key-value");
    }
    
    return nil;
}


- (NSNumber *) pieceLength {
    NSDictionary* infoDict = [self.torrentInfo objectForKey:@"info"];
    
    if (infoDict != nil) {
        NSNumber* pieceLength = [infoDict objectForKey:@"piece length"];
        
        if (pieceLength != nil) {
            return pieceLength;
        } else {
            NSLog(@"THROW? No 'piece length' key-value in 'info' dictionary");
        }
    } else {
        NSLog(@"THROW? No 'info' dictionary");
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
        } else {
            NSLog(@"THROW? No 'pieces' key-value in 'info' dictionary");
        }
    } else {
        NSLog(@"THROW? No 'info' dictionary");
    }
    
    return nil;
}

- (NSArray *) files {
    NSDictionary* infoDict = [self.torrentInfo objectForKey:@"info"];
    
    if (infoDict != nil) {
        NSArray* files = [infoDict objectForKey:@"files"];
        
        if (files != nil) {
            return files;
        } else {
            NSLog(@"THROW? No 'files' key-value in 'info' dictionary");
        }
    } else {
        NSLog(@"THROW? No 'info' dictionary");
    }
    
    return nil;
}

- (NSString*) availableInfos {
    NSString* ret = @"";
    
    NSString* torrentName = [self torrentName];
    if (torrentName != nil) {
        ret = [ret stringByAppendingString:[NSString stringWithFormat:@"Name: %@", torrentName]];
    }
    ret = [ret stringByAppendingString:@"\n\n"];
    
    NSDate* creationDate = [self creationDate];
    if (creationDate != nil) {
        ret = [ret stringByAppendingString:[NSString stringWithFormat:@"Created on: %@", creationDate]];
    } else {
        ret = [ret stringByAppendingString:[NSString stringWithFormat:@"Created on: -"]];
    }
    ret = [ret stringByAppendingString:@"\n\n"];
    
    
    NSArray* urlTrackers = [self urlTrackers];
    if (urlTrackers != nil) {
        NSString* content = [NSString stringWithFormat:@"URL Trackers: \n"];
        content = [content stringByAppendingString:[urlTrackers componentsJoinedByString:@"\n"]];
        ret = [ret stringByAppendingString:content];
    }
    ret = [ret stringByAppendingString:@"\n\n"];
    
    NSArray* filesArray = [self files];
    if (filesArray != nil) {
        NSString* content = [NSString stringWithFormat:@"Files: \n"];
        NSArray* formattedFilesArray = [[NSArray alloc] initWithObjects:@"", nil];
        for (NSDictionary* fileDict in filesArray) {
            formattedFilesArray = [formattedFilesArray arrayByAddingObject:[fileDict valueForKey:@"path"]];
        }
        content = [content stringByAppendingString:[formattedFilesArray componentsJoinedByString:@"\n-> "]];
        ret = [ret stringByAppendingString:content];
    }
    ret = [ret stringByAppendingString:@"\n\n"];
    
    
    NSNumber* pieceLength = [self pieceLength];
    if (pieceLength != nil) {
        NSString* content = [NSString stringWithFormat:@"Piece length: %@", pieceLength];
        ret = [ret stringByAppendingString:content];
    } else {
        ret = [ret stringByAppendingString:@"Piece length: -"];
    }
    ret = [ret stringByAppendingString:@"\n\n"];
    
    return ret;
}

@end
