# ls-btreader
This is a small Obj-C app reading .torrent files and displaying relevant meta info. It was done in the context of a coding challenge for a job interview.



## Technical structure

### Bencode.h/m
Reads a Bencoded string as input, and throws out a structure in memory (`NSDictionary`, `NSString`, `NSArray`, `NSNumber`)


