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

#import "JSQMessagesCollectionViewCellIncoming.h"

@implementation JSQMessagesCollectionViewCellIncoming

#pragma mark - Overrides

+ (UINib *)nib
{
    //ARLEY WAS HERE...
    NSString *className = NSStringFromClass([JSQMessagesCollectionViewCellIncoming class]);
    NSString *path = [[[NSBundle mainBundle] resourcePath]
                      stringByAppendingPathComponent:@"modules/br.com.arlsoft.messages/"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    return [UINib nibWithNibName:className bundle:bundle];
    
    //return [UINib nibWithNibName:NSStringFromClass([JSQMessagesCollectionViewCellIncoming class])
    //                      bundle:[NSBundle mainBundle]];
}

+ (NSString *)cellReuseIdentifier
{
    return NSStringFromClass([JSQMessagesCollectionViewCellIncoming class]);
}

#pragma mark - Initialization

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.messageBubbleTopLabel.textAlignment = NSTextAlignmentLeft;
    self.cellBottomLabel.textAlignment = NSTextAlignmentLeft;
}

@end
