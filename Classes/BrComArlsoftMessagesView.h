/**
 * MIT License
 * Copyright (c) 2014-present
 * ArlSoft Tecnologia <contato@arlsoft.com.br>
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

#import "TiUIView.h"
#import "JSQMessagesViewController.h"
#import "BrComArlsoftMessagesViewProxy.h"
#import "JSQMessagesBubbleImageFactory.h"
#import "JSQMessages.h"

@interface BrComArlsoftMessagesView : TiUIView <JSQMessagesCollectionViewDataSource,
JSQMessagesCollectionViewDelegateFlowLayout,
UITextViewDelegate> {

@private
    UIView *view;
    JSQMessagesViewController *controller;

    KrollCallback *messageDataForIndex;
    KrollCallback *messageDataCount;

    KrollCallback *cellAvatarCustomization;
    KrollCallback *cellTimestampCustomization;
    KrollCallback *cellSenderNameCustomization;
    KrollCallback *cellBubbleCustomization;
    
    NSMutableDictionary *avatars;
    UIImage *emptyAvatar;
    UIImage *notFoundAvatar;
    UIImageView *systemBubbleImageView;
    UIImageView *incomingBubbleImageView;
    UIImageView *outgoingBubbleImageView;
}

//Unused settings...
@property (nonatomic, readwrite, assign) BOOL showTypingIndicator;
@property (nonatomic, readwrite, assign) BOOL showLoadEarlierMessagesHeader;

//Global settings...
@property (copy, nonatomic) NSString *sender;
@property (copy, nonatomic) NSString *defaultIncomingAvatar;
@property (copy, nonatomic) NSString *defaultOutgoingAvatar;
@property (copy, nonatomic) NSString *loadingAvatar;
@property (copy, nonatomic) NSString *unableToLoadAvatar;
@property (nonatomic, readwrite, assign) BOOL playMessageSentSound;
@property (nonatomic, readwrite, assign) BOOL playMessageReceivedSound;

//Global customization...
@property (copy, nonatomic) UIColor *backgroundColor;

//Bubble customization...
@property (nonatomic, readwrite, assign) BOOL showBubbles;
@property (copy, nonatomic) NSString *bubbleKind;
@property (copy, nonatomic) UIColor *outgoingBubbleColor;
@property (copy, nonatomic) UIColor *incomingBubbleColor;
@property (copy, nonatomic) UIColor *incomingTextColor;
@property (copy, nonatomic) UIColor *outgoingTextColor;
@property (nonatomic, readwrite, assign) NSTextAlignment incomingTextAlignment;
@property (nonatomic, readwrite, assign) NSTextAlignment outgoingTextAlignment;
@property (copy, nonatomic) UIFont *bubbleFont;

//Input bar customization...
@property (nonatomic, readwrite, assign) BOOL showInputBar;
@property (copy, nonatomic) UIColor *inputBarBackgroundColor;
@property (nonatomic, readwrite, assign) CGFloat inputBarDefaultHeight;
@property (copy, nonatomic) UIColor *buttonNormalColor;
@property (copy, nonatomic) UIColor *buttonHighlightedColor;
@property (copy, nonatomic) UIColor *buttonDisabledColor;
@property (nonatomic, readwrite, assign) BOOL buttonWithSolidColor;

//Input field customization...
@property (copy, nonatomic) UIColor *inputFieldBackgroundColor;
@property (copy, nonatomic) UIColor *inputFieldBorderColor;
@property (copy, nonatomic) UIColor *inputFieldTextColor;
@property (copy, nonatomic) UIFont *inputFieldFont;
@property (copy, nonatomic) UIColor *inputFieldPlaceHolderTextColor;
@property (copy, nonatomic) NSString *inputFieldPlaceHolderText;

//Accessory button customization...
@property (nonatomic, readwrite, assign) BOOL showAccessoryButton;
@property (copy, nonatomic) NSString *customAccessoryButton;
@property (nonatomic, readwrite, assign) CGFloat accessoryButtonWidth;
@property (nonatomic, readwrite, assign) BOOL accessoryButtonEnabled;

//Send button customization...
@property (nonatomic, readwrite, assign) BOOL showSendButton;
@property (copy, nonatomic) NSString *customSendButton;
@property (nonatomic, readwrite, assign) CGFloat sendButtonWidth;

//Avatar customization...
@property (nonatomic, readwrite, assign) BOOL showOutgoingAvatar;
@property (nonatomic, readwrite, assign) BOOL showIncomingAvatar;
@property (nonatomic, readwrite, assign) CGFloat avatarSize;
@property (copy, nonatomic) UIImage *avatarOverlay;
@property (copy, nonatomic) UIColor *textAvatarBackgroundColor;
@property (copy, nonatomic) UIColor *textAvatarColor;
@property (copy, nonatomic) UIFont *textAvatarFont;

//Timestamp customization...
@property (nonatomic, readwrite, assign) BOOL showTimestamp;
@property (nonatomic, readwrite, assign) CGFloat timestampHeight;
@property (copy, nonatomic) UIColor *timestampColor;
@property (copy, nonatomic) UIFont *timestampFont;
@property (copy, nonatomic) UIFont *timestampPrefixFont;

//Sender name customization...
@property (nonatomic, readwrite, assign) BOOL showSenderName;
@property (nonatomic, readwrite, assign) CGFloat senderNameHeight;
@property (copy, nonatomic) UIColor *senderNameColor;
@property (copy, nonatomic) UIFont *senderNameFont;

//System message customization...
@property (nonatomic, readwrite, assign) BOOL showSystemTimestamp;
@property (nonatomic, readwrite, assign) BOOL showSystemBubbles;
@property (copy, nonatomic) NSString *systemBubbleKind;
@property (copy, nonatomic) UIColor *systemBubbleColor;
@property (copy, nonatomic) UIColor *systemTextColor;
@property (nonatomic, readwrite, assign) NSTextAlignment systemTextAlignment;
@property (copy, nonatomic) UIFont *systemBubbleFont;

- (void)finishSendingMessage;
- (void)finishReceivingMessage;
- (void)scrollToBottomAnimated:(BOOL)animated;

- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (void)viewDidDisappear:(BOOL)animated;

- (void)finishLoadEarlierMessages:(NSInteger)index;
- (void)reloadAvatar:(NSString*)avatar;

+(void)myLog:(NSString*) format, ...;

@end