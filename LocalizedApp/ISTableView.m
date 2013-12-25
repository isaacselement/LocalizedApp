#import "ISTableView.h"
#import "AppInterface.h"

@interface ISTableView () {
    NSInteger editingRow ;
    NSInteger editingColumn ;
}

@end

@implementation ISTableView


- (BOOL)textShouldEndEditing:(NSText *)textObject {
    NSString* changedText = [textObject.string copy];
    
    NSMutableArray* allLocalizeKeys = GLOBAL.allLocalizeKeys ;
    NSString* editingKey = [allLocalizeKeys objectAtIndex: editingRow];
    
    // modified key
    if (editingColumn == 0) {
        NSString* changedKey = changedText;
        BOOL isSuccess = [GLOBAL changeKeyInAllFileContents: editingKey newKey:changedKey];
        if (! isSuccess) {
            NSRunAlertPanel(@"Error", @"Duplicated key", @"OK", nil, nil);
        }
        
    // modified content
    } else {
        
        NSString* changedContent = changedText;
        NSTableColumn* tableColumn = [self.tableColumns objectAtIndex: editingColumn];
        [GLOBAL changeContentInFile: tableColumn.identifier newContent:changedContent forKey:editingKey];
    }
    
    editingRow = editingColumn = -1;
    return YES;
}

- (void)textDidEndEditing:(NSNotification *)notification {
    [self reloadData];
}

- (void)editColumn: (NSInteger)column row:(NSInteger)row withEvent:(NSEvent *)theEvent select:(BOOL)select {
    [super editColumn:column row:row withEvent:theEvent select:select];
	if ([self selectedRow] == -1) {
		NSRunAlertPanel(@"Editor Error", @"No row is selected.", @"OK", nil, nil);
        return;
	}
    
    NSMutableArray* allLocalizeKeys = GLOBAL.allLocalizeKeys ;
    
    // add new key and new contents
    if (row >= allLocalizeKeys.count) {
        NSLog(@"Editing in New row");
        [GLOBAL addNewKeyInAllFileContents];
    }
    
    
    NSTableColumn* tableColumn = [self.tableColumns objectAtIndex: column];
    
    NSString* editingKey = [allLocalizeKeys objectAtIndex: row];
    
    NSLog(@"editColumn (%d, %d)", (int)row , (int)column);
    
    NSString* identifiction = tableColumn.identifier;
    NSLog(@"identification %@ , key %@", identifiction, editingKey);
    
    
    editingRow = row;
    editingColumn = column;
}



@end
