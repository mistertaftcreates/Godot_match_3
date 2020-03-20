#import <GoogleMobileAds/GADInterstitial.h>
#import "app_delegate.h"
#import "AdmobBanner.h"

@interface AdmobInterstitial: NSObject <GADInterstitialDelegate> {
    AdmobBanner *admobBanner;
    GADInterstitial *interstitial;
    bool initialized;
    bool isReal;
    int instanceId;
    ViewController *rootController;
}

- (void)initialize:(BOOL)is_real: (int)instance_id: (AdmobBanner *)banner;
- (void)loadInterstitial:(NSString*)interstitialId;
- (void)showInterstitial;

@end
