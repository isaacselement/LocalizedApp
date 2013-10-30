
#import "AppDelegate.h"
#import "AppInterface.h"


@implementation AppDelegate

@synthesize tableView;


- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
	return YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (IBAction)openFiles:(id)sender {
    
    // Get file paths
    NSMutableArray* filePaths = [[NSMutableArray alloc] initWithCapacity: 0];
    OpenFilesPanel * panel = [[OpenFilesPanel alloc] init];
    panel.allowedFileTypes = @[@"strings"];
    NSInteger result = [panel runModal];
    if(result == NSOKButton) {
        filePaths = [panel filesPaths];
    }
    GLOBAL.allFilePaths = filePaths;
    
    NSLog(@"%@", GLOBAL.allFilePaths);
    
    // Get file contents
    GLOBAL.allFileContents = [LocalizeFileManager readStringsFiles: GLOBAL.allFilePaths];
    
    
    // Show table columns
    NSArray* columns = tableView.tableColumns;
    // First
    for (int i = 0; i < columns.count; i++) {
        NSTableColumn* tableColumn = [columns objectAtIndex: i];
        if (i == 0) {
            NSTableHeaderCell *columnHeaderCell = [tableColumn headerCell];
            tableColumn.identifier = KEY;
            columnHeaderCell.title = KEY;
            tableColumn.width = 200;
        } else {
            [tableView removeTableColumn: tableColumn];
        }
    }
    // Second
    for( int i = 0; i < GLOBAL.allFilePaths.count; i++){
        NSString* filePath = [GLOBAL.allFilePaths objectAtIndex: i];
        NSString* fileName = [filePath lastPathComponent];
        NSTableColumn* tableColumn = [[NSTableColumn alloc] init];
        NSTableHeaderCell *columnHeaderCell = [tableColumn headerCell];
        [tableColumn setWidth: 200];
        columnHeaderCell.title = fileName;
        tableColumn.identifier = filePath;
        [tableView addTableColumn: tableColumn];
    }
    
    [tableView reloadData];
}

- (IBAction)saveFiles:(id)sender {
    [LocalizeFileManager writeStringsFile: GLOBAL.allFileContents];
}

- (IBAction)deleteRow:(id)sender {
    if ([tableView selectedRow] == -1) {
		NSRunAlertPanel(@"Delete Error", @"No row is selected.", @"OK", nil, nil);
        return;
	}
    
    NSMutableArray* allLocalizeKeys = GLOBAL.allLocalizeKeys ;
    NSMutableDictionary* allFileContents = GLOBAL.allFileContents ;
    
    NSInteger row = [tableView selectedRow];
    NSString* deleteKey = [allLocalizeKeys objectAtIndex: row];
    [allLocalizeKeys removeObjectAtIndex: row];
    for (NSString* key in allFileContents) {
        NSMutableDictionary* content = [allFileContents objectForKey:key];
        [content removeObjectForKey: deleteKey];
    }
    
    [tableView reloadData];
}



#pragma mark - NSTableView datasource methods
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return GLOBAL.allLocalizeKeys.count + 1;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSMutableArray* allLocalizeKeys = GLOBAL.allLocalizeKeys ;
    NSMutableDictionary* allFileContents = GLOBAL.allFileContents ;
    
    if (row >= [allLocalizeKeys count]) return nil;
    
    NSString* key = [allLocalizeKeys objectAtIndex: row];
    
    NSString* identifier = tableColumn.identifier;
    if ([identifier isEqualToString: KEY]) {
        return key;
    } else {
        return [[allFileContents objectForKey: identifier] objectForKey: key];
    }
}

@end
