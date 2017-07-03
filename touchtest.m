#import <Cocoa/Cocoa.h>

static const NSTouchBarItemIdentifier kGroupButton = @"com.trevorbentley.group";
static const NSTouchBarItemIdentifier kButton1 = @"com.trevorbentley.b1";
static const NSTouchBarItemIdentifier kButton2 = @"com.trevorbentley.b2";

extern void DFRElementSetControlStripPresenceForIdentifier(NSString *, BOOL);
extern void DFRSystemModalShowsCloseBoxWhenFrontMost(BOOL);

@interface NSTouchBarItem ()
+ (void)addSystemTrayItem:(NSTouchBarItem *)item;
@end

@interface NSTouchBar ()
+ (void)presentSystemModalFunctionBar:(NSTouchBar *)touchBar systemTrayItemIdentifier:(NSString *)identifier;
@end

@interface AppDelegate : NSObject <NSApplicationDelegate,NSTouchBarDelegate>
@end

NSTouchBar *_groupTouchBar;

@implementation AppDelegate

- (NSTouchBar *)groupTouchBar {
    if (!_groupTouchBar) {
        NSTouchBar *groupTouchBar = [[NSTouchBar alloc] init];
        groupTouchBar.defaultItemIdentifiers = @[ kButton1, kButton2 ];
        groupTouchBar.delegate = self;
        _groupTouchBar = groupTouchBar;
    }
    return _groupTouchBar;
}

-(void)setGroupTouchBar: (NSTouchBar*)bar {
    _groupTouchBar = bar;
}

- (void)button:(id)sender {
    NSLog(@"button");
}

- (void)present:(id)sender {
    [NSTouchBar presentSystemModalFunctionBar:self.groupTouchBar
                     systemTrayItemIdentifier:kGroupButton];
}

- (NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar
       makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier
{
    NSCustomTouchBarItem *item = nil;
    if ([identifier isEqualToString:kButton1]) {
        item = [[NSCustomTouchBarItem alloc] initWithIdentifier:kButton1];
        item.view = [NSButton buttonWithTitle:@"B1" target:self action:@selector(button:)];
    }
    else if ([identifier isEqualToString:kButton2]) {
        item = [[NSCustomTouchBarItem alloc] initWithIdentifier:kButton2];
        item.view = [NSButton buttonWithTitle:@"Quit" target:[NSApplication sharedApplication] action:@selector(terminate:)];
    }
    return item;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    DFRSystemModalShowsCloseBoxWhenFrontMost(YES);
    NSCustomTouchBarItem *item = [[NSCustomTouchBarItem alloc] initWithIdentifier:kGroupButton];
    item.view = [NSButton buttonWithTitle:@"\U0001F4A9\U0001F4A9" target:self action:@selector(present:)];
    [NSTouchBarItem addSystemTrayItem:item];
    DFRElementSetControlStripPresenceForIdentifier(kGroupButton, YES);
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [_groupTouchBar release];
    _groupTouchBar = nil;
}
@end

int main(){
    [NSAutoreleasePool new];
    [NSApplication sharedApplication];
    AppDelegate *del = [[AppDelegate alloc] init];
    [NSApp setDelegate: del];
    [NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];
    [NSApp run];
    return 0;
}
