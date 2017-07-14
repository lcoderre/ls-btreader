# ls-btreader
This is a small Obj-C app reading .torrent files and displaying relevant meta info. It was done in the context of a coding challenge for a job interview.



## Technical structure

### Bencode.h/m
`[BencodeParser decode:]` reads a "bencoded" string as input, and throws out a structure in memory (`NSDictionary`, `NSString`, `NSArray`, `NSNumber`), or a mix of all these.

### BitTorrent

`BitTorrent` is initialized from an `NSDictionary` representing the normal structure of a .torrent file. Ideally, that would be the direct output of the `[BencodeParser decode:]` above.

Once initialized, you have access to lazy-determined properties such as `torrentName`, `creationDate`, `files` and 
more.

### MetaInfoView
Inherits from NSView and takes care of displaying relevant meta info of a .torrent file

### ViewController
I did not rename the file. 

Takes care of loading the contents of a selected .torrent file, shoots it at `Bencode`, then shoots the result at `BitTorrent`, and sends that as a model to the `MetaInfoView`to refresh data.
