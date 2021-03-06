
#import <UIKit/UIKit.h>

@interface LXFStyledPageControl : UIControl
@property (nonatomic) UIColor *coreNormalColor, *coreSelectedColor;
@property (nonatomic) UIColor *strokeNormalColor, *strokeSelectedColor;
@property (nonatomic, assign) int currentPage, numberOfPages;
@property (nonatomic, assign) BOOL hidesForSinglePage;
@property (nonatomic, assign) int strokeWidth, diameter, gapWidth;
@end
