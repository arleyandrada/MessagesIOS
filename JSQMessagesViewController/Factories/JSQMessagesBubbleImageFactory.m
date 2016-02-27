//
//  Created by Jesse Squires
//  http://www.hexedbits.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "JSQMessagesBubbleImageFactory.h"

#import "UIImage+JSQMessages.h"
#import "UIColor+JSQMessages.h"


@interface JSQMessagesBubbleImageFactory ()

+ (UIImageView *)bubbleImageViewWithColor:(UIColor *)color kind:(NSString *)kind flippedForIncoming:(BOOL)flippedForIncoming;

+ (UIImage *)jsq_horizontallyFlippedImageFromImage:(UIImage *)image;

+ (UIImage *)jsq_stretchableImageFromImage:(UIImage *)image withCapInsets:(UIEdgeInsets)capInsets;

@end



@implementation JSQMessagesBubbleImageFactory

#pragma mark - Public

+ (UIImageView *)systemMessageBubbleImageViewWithColor:(UIColor *)color kind:(NSString *)kind
{
    NSParameterAssert(color != nil);
    return [JSQMessagesBubbleImageFactory bubbleImageViewWithColor:color kind:kind flippedForIncoming:NO];
}

+ (UIImageView *)outgoingMessageBubbleImageViewWithColor:(UIColor *)color kind:(NSString *)kind
{
    NSParameterAssert(color != nil);
    return [JSQMessagesBubbleImageFactory bubbleImageViewWithColor:color kind:kind flippedForIncoming:NO];
}

+ (UIImageView *)incomingMessageBubbleImageViewWithColor:(UIColor *)color kind:(NSString *)kind
{
    NSParameterAssert(color != nil);
    return [JSQMessagesBubbleImageFactory bubbleImageViewWithColor:color kind:kind flippedForIncoming:YES];
}

#pragma mark - Private

+ (UIImageView *)bubbleImageViewWithColor:(UIColor *)color kind:(NSString *)kind flippedForIncoming:(BOOL)flippedForIncoming
{
    NSString* bubbleKind = @"bubble";
    if (kind != nil) {
        bubbleKind = [NSString stringWithFormat:@"bubble_%@", kind];
    }
    
    //ARLEY WAS HERE...
    NSString *path = [[[NSBundle mainBundle] resourcePath]
                      stringByAppendingPathComponent:@"modules/br.com.arlsoft.messages/"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    NSString *imageName = [bundle pathForResource:bubbleKind ofType:@"png"];
    UIImage *bubble = (imageName == nil) ? nil : [[UIImage alloc] initWithContentsOfFile:imageName];
    
    if (imageName == nil || bubble == nil){
        imageName = [[NSBundle mainBundle] pathForResource:bubbleKind ofType:@"png"];
        bubble = (imageName == nil) ? nil : [[UIImage alloc] initWithContentsOfFile:imageName];
    }

    //UIImage *bubble = [UIImage imageNamed:@"bubble_min"];
    
    UIImage *normalBubble = [bubble jsq_imageMaskedWithColor:color];
    UIImage *highlightedBubble = [bubble jsq_imageMaskedWithColor:[color jsq_colorByDarkeningColorWithValue:0.12f]];
    
    if (flippedForIncoming) {
        normalBubble = [JSQMessagesBubbleImageFactory jsq_horizontallyFlippedImageFromImage:normalBubble];
        highlightedBubble = [JSQMessagesBubbleImageFactory jsq_horizontallyFlippedImageFromImage:highlightedBubble];
    }
    
    // make image stretchable from center point
    CGPoint center = CGPointMake(bubble.size.width / 2.0f, bubble.size.height / 2.0f);
    UIEdgeInsets capInsets = UIEdgeInsetsMake(center.y, center.x, center.y, center.x);
    
    normalBubble = [JSQMessagesBubbleImageFactory jsq_stretchableImageFromImage:normalBubble withCapInsets:capInsets];
    highlightedBubble = [JSQMessagesBubbleImageFactory jsq_stretchableImageFromImage:highlightedBubble withCapInsets:capInsets];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:normalBubble highlightedImage:highlightedBubble];
    imageView.backgroundColor = [UIColor whiteColor];
    return imageView;
}

+ (UIImage *)jsq_horizontallyFlippedImageFromImage:(UIImage *)image
{
    return [UIImage imageWithCGImage:image.CGImage
                               scale:image.scale
                         orientation:UIImageOrientationUpMirrored];
}

+ (UIImage *)jsq_stretchableImageFromImage:(UIImage *)image withCapInsets:(UIEdgeInsets)capInsets
{
    return [image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
}

@end
