#import "../../PS.h"
#import <Flipswitch/FSSwitchDataSource.h>
#import <Flipswitch/FSSwitchPanel.h>

CFStringRef const kKeyboardClicksKey = isiOS10Up ? CFSTR("keyboard-audio") : CFSTR("keyboard");
CFStringRef const kPrefsSound = CFSTR("com.apple.preferences.sounds");
CFStringRef const kPrefsSoundNotification = CFSTR("com.apple.preferences.sounds.changed");
NSString *const kSwitchIdentifier = @"com.PS.KeyboardClicks";

@interface KeyboardClicksSwitch : NSObject <FSSwitchDataSource>
@end

static void PreferencesChanged(){
    [[FSSwitchPanel sharedPanel] stateDidChangeForSwitchIdentifier:kSwitchIdentifier];
}

@implementation KeyboardClicksSwitch

- (id)init {
    if (self == [super init])
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)PreferencesChanged, kPrefsSoundNotification, NULL, CFNotificationSuspensionBehaviorCoalesce);
    return self;
}

- (void)dealloc {
    CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(), self, kPrefsSoundNotification, NULL);
    [super dealloc];
}

- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier {
    Boolean keyExist;
    Boolean enabled = CFPreferencesGetAppBooleanValue(kKeyboardClicksKey, kPrefsSound, &keyExist);
    if (!keyExist)
        return FSSwitchStateOn;
    return enabled ? FSSwitchStateOn : FSSwitchStateOff;
}

- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier {
    if (newState == FSSwitchStateIndeterminate)
        return;
    CFBooleanRef enabled = newState == FSSwitchStateOn ? kCFBooleanTrue : kCFBooleanFalse;
    CFPreferencesSetAppValue(kKeyboardClicksKey, enabled, kPrefsSound);
    CFPreferencesAppSynchronize(kPrefsSound);
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), kPrefsSoundNotification, nil, nil, YES);
}

@end
