//
//  FileReader.h
//  ls-btreader
//
//  Created by Laurens Coderre on 17-07-11.
//  Copyright © 2017 Laurens Coderre. All rights reserved.
//

#ifndef FileReader_h
#define FileReader_h

@interface FileReader : NSObject

- (NSString*) stringContentsAtFilepath: (NSString*) filepath;

@end



@implementation FileReader

- (NSString*) stringContentsAtFilepath: (NSString*) filepath {
    
    // Should maybe throw warning if file size is big??
    
    NSData* fileData = [[NSFileManager defaultManager] contentsAtPath:filepath];
    NSString *readableData = [[NSString alloc] initWithData:fileData encoding:NSMacOSRomanStringEncoding];
    
    if (readableData == nil) {
        NSLog(@"THROW EXCEPTION IN stringContentsAtFilepath CUZ ITS NULL");
    }
    return readableData;
}

@end

#endif /* FileReader_h */
