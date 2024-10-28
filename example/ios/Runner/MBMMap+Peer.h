//
//  MBMMap+Peer.h
//  Runner
//
//  Created by Roman Laitarenko on 26.10.2024.
//

#import <MapboxCoreMaps/MBMMap_Internal.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBMMap (Peer)

- (int64_t)getPeerHandle;

@end

NS_ASSUME_NONNULL_END
