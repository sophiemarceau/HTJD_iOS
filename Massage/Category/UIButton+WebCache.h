
//  WXMovie
//


//

#import <UIKit/UIKit.h>
#import "SDWebImageCompat.h"
#import "SDWebImageManager.h"

@interface UIButton (WebCache)<SDWebImageManagerDelegate>

- (void)setImageWithURL:(NSURL *)url;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)cancelCurrentImageLoad;


@end
