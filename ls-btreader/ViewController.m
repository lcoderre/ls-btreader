//
//  ViewController.m
//  ls-btreader
//
//  Created by Laurens Coderre on 17-07-11.
//  Copyright © 2017 Laurens Coderre. All rights reserved.
//

#import "ViewController.h"

#import "FileReader.h"
#import "BitTorrent.h"

@interface ViewController()
@property (weak, nonatomic) NSTextView* textView;
@end


@implementation ViewController 
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(20, 20, 70, 25);
    NSButton* selectionButton = [[NSButton alloc] initWithFrame: frame];
    
    [self.view addSubview:selectionButton];
    
    [selectionButton setTitle:@"Select file"];
    [selectionButton setTarget:self];
    [selectionButton setAction:@selector(selectFile)];
    
    
    NSTextView* textView = [[NSTextView alloc] initWithFrame:CGRectMake(120, 20, 300, 400)];
    
    
    [textView setEditable:NO];
    
    [self.view addSubview:textView];
    
    self.textView = textView;
    
}

- (void) selectFile {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:YES];
    [panel setAllowsMultipleSelection:NO];
    
    NSInteger clicked = [panel runModal];
    
    if (clicked == NSFileHandlingPanelOKButton) {
        NSURL *url = [panel URL];
        
        NSString* contents = [[[FileReader alloc] init] stringContentsAtFilepath:url.path];
        
        id dict = [BencodeParser parseString:contents].element;
        
        BitTorrent* bt = [BitTorrent initWithTorrentInfoDictionary:dict];
        
        [self.textView setString:[bt availableInfos]];
    }
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}


@end
