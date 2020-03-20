#import "AdmobBanner.h"
#include "reference.h"

@implementation AdmobBanner

- (void)dealloc {
    bannerView.delegate = nil;
    [bannerView release];
    [super dealloc];
}

- (void)initialize:(BOOL)is_real: (int)instance_id {
    isReal = is_real;
    initialized = true;
    instanceId = instance_id;
    rootController = [AppDelegate getViewController];
}


- (void) loadBanner:(NSString*)bannerId: (BOOL)is_on_top {
    NSLog(@"Calling loadBanner");
    
    isOnTop = is_on_top;
    
    if (!initialized) {
        return;
    }
    

    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (bannerView == nil) {
        if (orientation == 0 || orientation == UIInterfaceOrientationPortrait) { //portrait
            bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
        }
        else { //landscape
            bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape];
        }
        
        if(!isReal) {
            bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
        }
        else {
            bannerView.adUnitID = bannerId;
        }

        bannerView.delegate = self;
        bannerView.rootViewController = rootController;
        

        [self addBannerViewToView:bannerView:is_on_top];
    }
    
    GADRequest *request = [GADRequest request];
    [bannerView loadRequest:request];
    
}


- (void)addBannerViewToView:(UIView *_Nonnull)bannerView: (BOOL)is_on_top{
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [rootController.view addSubview:bannerView];
    if (@available(ios 11.0, *)) {
        [self positionBannerViewFullWidthAtSafeArea:bannerView:is_on_top];
    } else {
        [self positionBannerViewFullWidthAtView:bannerView:is_on_top];
    }
}



- (void)positionBannerViewFullWidthAtSafeArea:(UIView *_Nonnull)bannerView: (BOOL)is_on_top  NS_AVAILABLE_IOS(11.0) {
    UILayoutGuide *guide = rootController.view.safeAreaLayoutGuide;
    
    if (is_on_top) {
        [NSLayoutConstraint activateConstraints:@[
            [guide.leftAnchor constraintEqualToAnchor:bannerView.leftAnchor],
            [guide.rightAnchor constraintEqualToAnchor:bannerView.rightAnchor],
            [guide.topAnchor constraintEqualToAnchor:bannerView.topAnchor]
        ]];
    } else {
        [NSLayoutConstraint activateConstraints:@[
            [guide.leftAnchor constraintEqualToAnchor:bannerView.leftAnchor],
            [guide.rightAnchor constraintEqualToAnchor:bannerView.rightAnchor],
            [guide.bottomAnchor constraintEqualToAnchor:bannerView.bottomAnchor]
        ]];
    }
}


- (void)positionBannerViewFullWidthAtView:(UIView *_Nonnull)bannerView: (BOOL)is_on_top {
    
    [rootController.view addConstraint:[NSLayoutConstraint constraintWithItem:bannerView
                                                                    attribute:NSLayoutAttributeLeading
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:rootController.view
                                                                    attribute:NSLayoutAttributeLeading
                                                                   multiplier:1
                                                                     constant:0]];
    [rootController.view addConstraint:[NSLayoutConstraint constraintWithItem:bannerView
                                                                    attribute:NSLayoutAttributeTrailing
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:rootController.view
                                                                    attribute:NSLayoutAttributeTrailing
                                                                   multiplier:1
                                                                     constant:0]];
    
    if (is_on_top) {
        [rootController.view addConstraint:[NSLayoutConstraint constraintWithItem:bannerView
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:rootController.topLayoutGuide
                                                                        attribute:NSLayoutAttributeTop
                                                                       multiplier:1
                                                                         constant:0]];
        
    } else {
        [rootController.view addConstraint:[NSLayoutConstraint constraintWithItem:bannerView
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:rootController.bottomLayoutGuide
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:0]];
    }
}

- (void)showBanner {
    NSLog(@"Calling showBanner");
    
    if (bannerView == nil || !initialized) {
        return;
    }
    
    [bannerView setHidden:NO];
}

- (void) hideBanner {
    NSLog(@"Calling hideBanner");
    if (bannerView == nil || !initialized) {
        return;
    }
    [bannerView setHidden:YES];
}
- (void) disableBanner {
    NSLog(@"Calling disableBanner");
    if (bannerView == nil || !initialized) {
        return;
    }
 
    [bannerView setHidden:YES];
    [bannerView removeFromSuperview];
    adUnitId = bannerView.adUnitID;
    bannerView = nil;
}
 
- (void) enableBanner {
    NSLog(@"Calling enableBanner");
    if (!initialized) {
        return;
    }
 
    if (bannerView == nil) {
        [self loadBanner:adUnitId:isOnTop];
    }
    [bannerView setHidden:NO];
}

- (void) resize {
    NSLog(@"Calling resize");
    NSString* currentAdUnitId = bannerView.adUnitID;
    [self hideBanner];
    [bannerView removeFromSuperview];
    bannerView = nil;
    [self loadBanner:currentAdUnitId:isOnTop];
}

- (int) getBannerWidth {
    return bannerView.bounds.size.width;
}

- (int) getBannerHeight {
    return bannerView.bounds.size.height;
}



/// Tells the delegate an ad request loaded an ad.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"adViewDidReceiveAd");
    Object *obj = ObjectDB::get_instance(instanceId);
    obj->call_deferred("_on_admob_ad_loaded");
}

/// Tells the delegate an ad request failed.
- (void)adView:(GADBannerView *)adView
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
    Object *obj = ObjectDB::get_instance(instanceId);
    obj->call_deferred("_on_admob_network_error");
}

/// Tells the delegate that a full screen view will be presented in response
/// to the user clicking on an ad.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillPresentScreen");
}

/// Tells the delegate that the full screen view will be dismissed.
- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillDismissScreen");
}

/// Tells the delegate that the full screen view has been dismissed.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewDidDismissScreen");
}

/// Tells the delegate that a user click will open another app (such as
/// the App Store), backgrounding the current app.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    NSLog(@"adViewWillLeaveApplication");
}


@end
