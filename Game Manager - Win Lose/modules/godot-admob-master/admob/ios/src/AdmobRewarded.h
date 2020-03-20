#import "app_delegate.h"
#import <GoogleMobileAds/GADRewardBasedVideoAdDelegate.h>
#import "AdmobBanner.h"

@interface AdmobRewarded: NSObject <GADRewardBasedVideoAdDelegate> {
    AdmobBanner *admobBanner;
    bool initialized;
    bool isReal;
    int instanceId;
    ViewController *rootController;
}

- (void)initialize:(BOOL)is_real: (int)instance_id: (AdmobBanner *)banner;
- (void)loadRewardedVideo:(NSString*)rewardedId;
- (void)showRewardedVideo;

@end
