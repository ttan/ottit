//
//  TTSettingsViewController.h
//  titto
//
//  Created by Paolo Ladisa on 4/6/13.
//  Copyright (c) 2013 titto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface TTSettingsViewController : UIViewController<MFMailComposeViewControllerDelegate>{
    
    IBOutlet UILabel * impostazioniLabel;

    IBOutlet UILabel * negozioLabel;
    IBOutlet UILabel * negozioPreferitoLabel;
    IBOutlet UIButton * cambiaNegozioButton;

    IBOutlet UILabel * accessoFacebookLabel;
    IBOutlet UILabel * accessoUserLabel;
    IBOutlet UIButton * logoutButton;

    IBOutlet UIButton * termsButton;

    IBOutlet UILabel * copyLabel;
    IBOutlet UILabel * srlLabel;

    IBOutlet UILabel * viaLabel;
    IBOutlet UILabel * cittaLabel;
    IBOutlet UILabel * piLabel;

    IBOutlet UILabel * telLabel;
    IBOutlet UIButton * sitoButton;
    IBOutlet UIButton * emailButton;

    MFMailComposeViewController *mailer ;

}

-(IBAction)cambiaNegozio:(id)sender;
-(IBAction)fbLogout:(id)sender;

-(IBAction)openSite:(id)sender;
-(IBAction)openMail:(id)sender;

-(IBAction)openTerms:(id)sender;

@end
