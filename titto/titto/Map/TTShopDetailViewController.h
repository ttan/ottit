//
//  TTShopDetailViewController.h
//  Map
//
//  Created by Paolo Ladisa on 3/28/13.
//  Copyright (c) 2013 Titto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTFoursquareManager.h"
#import "TTHeaderImageView.h"
#import <MessageUI/MessageUI.h>


@interface TTShopDetailViewController : UIViewController<TTFoursquareManagerDelegate,MFMailComposeViewControllerDelegate,UIScrollViewDelegate>
{
    NSDictionary * _infoDict;

    IBOutlet TTHeaderImageView * headerImageView;

    IBOutlet UIScrollView * scrollView;

    IBOutlet UILabel * shadowLabel;
    IBOutlet UIView * contentView;

    IBOutlet UILabel * indirizzoLabel;
    IBOutlet UILabel * cittaLabel;
    IBOutlet UILabel * orarioAperturaLabel;

    IBOutlet UILabel * lunediLabel;
    IBOutlet UILabel * martediLabel;
    IBOutlet UILabel * mercolediLabel;
    IBOutlet UILabel * giovediLabel;
    IBOutlet UILabel * venerdiLabel;
    IBOutlet UILabel * sabatoLabel;
    IBOutlet UILabel * domenicaLabel;

    IBOutlet UILabel * orarioLunediLabel;
    IBOutlet UILabel * orarioMartediLabel;
    IBOutlet UILabel * orarioMercolediLabel;
    IBOutlet UILabel * orarioGiovediLabel;
    IBOutlet UILabel * orarioVenerdiLabel;
    IBOutlet UILabel * orarioSabatoLabel;
    IBOutlet UILabel * orarioDomenicaLabel;

    IBOutlet UILabel * emailLabel;
    IBOutlet UIButton * emailContentLabel;

    IBOutlet UIButton * predefinedButton;
    
    IBOutlet UILabel * noConnectionLabel;
    
    IBOutlet UIImageView * starImageView;
    
    MFMailComposeViewController *mailer ;

}

@property (nonatomic,strong)NSDictionary * infoDict;

-(IBAction)predefinedButtonAction:(id)sender;
-(IBAction)openMail:(id)sender;
@end
