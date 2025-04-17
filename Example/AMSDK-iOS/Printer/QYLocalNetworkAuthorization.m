//
//  QYLocalNetworkAuthorization.m
//  QYPrintSDK
//
//  Created by aimo on 2023/11/28.
//

#import "QYLocalNetworkAuthorization.h"
#import <Network/Network.h>
@interface QYLocalNetworkAuthorization()<NSNetServiceDelegate>

@property(nonatomic, strong)nw_browser_t browser;
@property(nonatomic, strong)NSNetService *service;
@end

@implementation QYLocalNetworkAuthorization
- (void)requestAuthorization {
    nw_parameters_t parameters =  nw_parameters_create();
    nw_parameters_set_include_peer_to_peer(parameters,true);
    
    nw_browser_t browser = nw_browser_create(nw_browse_descriptor_create_bonjour_service("_bonjour._tcp",NULL), parameters);
    nw_browser_set_state_changed_handler(browser, ^(nw_browser_state_t state, nw_error_t  _Nullable error) {
        switch (state) {
            case nw_browser_state_ready:
            case nw_browser_state_cancelled:{
                
            }break;
                
            default:
                break;
        }
    });
    
    
    NSNetService *service = [[NSNetService alloc] initWithDomain:@"local." type:@"_lnp._tcp." name:@"LocalNetWorkPing" port:1100];
    service.delegate = self;
    nw_browser_set_queue(browser, dispatch_get_main_queue());
    nw_browser_start(browser);
    [service publish];
    self.service =  service;
    self.browser = browser;
}

- (void)reset{
    nw_browser_cancel(self.browser);
    [self.service stop];
}

- (void)netServiceDidPublish:(NSNetService *)sender {
    NSLog(@"获取本地网络权限成功");
    [self reset];
}

@end
