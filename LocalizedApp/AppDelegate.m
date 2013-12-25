
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
    
    [tableView setAllowsMultipleSelection: YES];
    
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
    NSIndexSet* selectedIndexSet = [tableView selectedRowIndexes];
    if (selectedIndexSet.count == 0) {
		NSRunAlertPanel(@"Delete Error", @"No row is selected.", @"OK", nil, nil);
        return;
	}
    
    
    NSMutableArray* allLocalizeKeys = GLOBAL.allLocalizeKeys ;
    NSMutableDictionary* allFileContents = GLOBAL.allFileContents ;
    
    // first
    /*int (as commented, unreliable across different platforms)*/
    NSUInteger currentIndex = [selectedIndexSet firstIndex];
    while (currentIndex != NSNotFound) {
        //use the currentIndex
        NSString* deleteKey = [allLocalizeKeys objectAtIndex: currentIndex];
        for (NSString* key in allFileContents) {
            NSMutableDictionary* content = [allFileContents objectForKey:key];
            [content removeObjectForKey: deleteKey];
        }
        //increment
        currentIndex = [selectedIndexSet indexGreaterThanIndex: currentIndex];
        
    }
    
    // second
    [allLocalizeKeys removeObjectsAtIndexes: selectedIndexSet];
    
    [tableView deselectAll:nil];
    [tableView reloadData];
}

- (IBAction)duplicateRow:(id)sender {
    NSUInteger selectedRow = [tableView selectedRow];
    
    NSMutableArray* allLocalizeKeys = GLOBAL.allLocalizeKeys ;
    NSMutableDictionary* allFileContents = GLOBAL.allFileContents ;
    
    NSString* selectedKey = [allLocalizeKeys objectAtIndex: selectedRow];
    NSMutableDictionary* contents = [NSMutableDictionary dictionary];
    for (NSString* filePath in allFileContents) {
        NSString* content = [allFileContents[filePath] objectForKey: selectedKey];
        [contents setObject: content forKey:filePath];
    }
    
    NSString* newKey = [@"zCopy " stringByAppendingString:selectedKey];
    [GLOBAL addKeyInAllFileContents:newKey contents:contents];
    
    [tableView deselectAll:nil];
    [tableView reloadData];
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:allLocalizeKeys.count-1];
    [tableView selectRowIndexes:indexSet byExtendingSelection:NO];
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
