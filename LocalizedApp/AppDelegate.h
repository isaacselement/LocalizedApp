#import <Cocoa/Cocoa.h>


#define KEY @"Key"

@class ISTableView;

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet ISTableView *tableView;

- (IBAction)openFiles:(id)sender;
- (IBAction)saveFiles:(id)sender;
- (IBAction)deleteRow:(id)sender;

@end
