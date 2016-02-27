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

#import "JSQMessagesToolbarButtonFactory.h"

#import "UIColor+JSQMessages.h"
#import "UIImage+JSQMessages.h"


@implementation JSQMessagesToolbarButtonFactory

static UIColor * _normalColor;
+ (void)setNormalColor:(UIColor *)color
{
    _normalColor = color;
}
+ (UIColor *)normalColor
{
    return (_normalColor == nil) ? [UIColor jsq_messageBubbleBlueColor] : _normalColor;
}

static UIColor * _highlightedColor;
+ (void)setHighlightedColor:(UIColor *)color
{
    _highlightedColor = color;
}
+ (UIColor *)highlightedColor
{
    return (_highlightedColor == nil) ? [[UIColor jsq_messageBubbleBlueColor] jsq_colorByDarkeningColorWithValue:0.1f] : _highlightedColor;
}

static UIColor * _disabledColor;
+ (void)setDisabledColor:(UIColor *)color
{
    _disabledColor = color;
}
+ (UIColor *)disabledColor
{
    return (_disabledColor == nil) ? [UIColor lightGrayColor] : _disabledColor;
}

static BOOL _withSolidColor = YES;
+ (void)setWithSolidColor:(BOOL)value
{
    _withSolidColor = value;
}
+ (BOOL)withSolidColor
{
    return _withSolidColor;
}

+ (UIButton *)defaultAccessoryButtonItem
{
    return [JSQMessagesToolbarButtonFactory imageButtonItem:@"camera"];
}

+ (UIButton *)defaultSendButtonItem
{
    return [JSQMessagesToolbarButtonFactory textButtonItem:@"Send"];
}

+ (UIButton *)textButtonItem:(NSString*)title
{
    NSString *buttonTitle = NSLocalizedString(title, @"Text for the send button on the messages view toolbar");
    
    UIButton *customButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [customButton setTitle:buttonTitle forState:UIControlStateNormal];
    [customButton setTitleColor:self.normalColor forState:UIControlStateNormal];
    [customButton setTitleColor:self.highlightedColor forState:UIControlStateHighlighted];
    [customButton setTitleColor:self.disabledColor forState:UIControlStateDisabled];
    
    customButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    customButton.contentMode = UIViewContentModeCenter;
    customButton.backgroundColor = [UIColor clearColor];
    customButton.tintColor = self.normalColor;
    
    return customButton;
}

+ (UIButton *)imageButtonItem:(NSString*)image
{
    //ARLEY WAS HERE...
    NSString *path = [[[NSBundle mainBundle] resourcePath]
                      stringByAppendingPathComponent:@"modules/br.com.arlsoft.messages/"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    NSString *imageName = [bundle pathForResource:image ofType:@"png"];
    UIImage *buttonImage = (imageName == nil) ? nil : [[UIImage alloc] initWithContentsOfFile:imageName];
    
    if (imageName == nil || buttonImage == nil){
        imageName = [[NSBundle mainBundle] pathForResource:image ofType:@"png"];
        buttonImage = (imageName == nil) ? nil : [[UIImage alloc] initWithContentsOfFile:imageName];
    }

    if (imageName == nil || buttonImage == nil){
        return nil;
    }

    UIImage *buttonNormal = [buttonImage jsq_imageMaskedWithColor:self.normalColor];
    UIImage *buttonHighlighted = [buttonImage jsq_imageMaskedWithColor:self.highlightedColor];
    UIImage *buttonDisabled = [buttonImage jsq_imageMaskedWithColor:self.disabledColor];
    
    UIButton *customButton = [[UIButton alloc] initWithFrame:CGRectZero];
    if (self.withSolidColor) {
        [customButton setImage:buttonNormal forState:UIControlStateNormal];
        [customButton setImage:buttonHighlighted forState:UIControlStateHighlighted];
        [customButton setImage:buttonDisabled forState:UIControlStateDisabled];
    } else {
        [customButton setImage:buttonImage forState:UIControlStateNormal];
    }
    
    customButton.contentMode = UIViewContentModeScaleAspectFit;
    customButton.backgroundColor = [UIColor clearColor];
    customButton.tintColor = self.normalColor;
    
    return customButton;
}

@end
