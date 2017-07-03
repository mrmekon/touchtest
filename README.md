# TouchTest - MacOS Touch Bar Control Strip daemon

Example of adding an icon to the Control Strip region of the Mac Touch Bar using
a headless/UI-less background app.  Icon is always displayed, regardless of which
app is in the foreground.

Uses a private API, not suitable for the App Store.

No XCode project, no Nib/Xib, builds from command-line.  Just the minimum
necessary to add an always-available button to the Control Strip.

Inspired by: https://github.com/a2/touch-baer

## Usage

### Build
```
$ make
```

### Build and launch
```
$ make run
```

### Kill running daemon
```
$ make kill
```

### Cleanup
```
$ make clean
```

### Design Notes

Links against private framework DFRFoundation.

Uses two DFRFoundation functions: ```DFRElementSetControlStripPresenceForIdentifier``` and ```DFRSystemModalShowsCloseBoxWhenFrontMost```

Uses private NSTouchBarItem method: ```+(void)addSystemTrayItem:(NSTouchBarItem *)item;```

Uses private NSTouchBar method: ```+(void)presentSystemModalFunctionBar:(NSTouchBar *)touchBar systemTrayItemIdentifier:(NSString *)identifier;```

Simply creates a windowless NSApplication and an NSApplicationDelegate implementing the private functions.

**MUST** execute from a mac _.app_ bundle.  The TouchBar service doesn't seem to communicate with a binary when launched outside of a bundle.  I did not investigate why.
