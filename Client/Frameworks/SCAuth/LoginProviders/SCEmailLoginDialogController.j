/*
 * SCEmailLoginDialogController.j
 * SCAuth
 *
 * Created by Saikat Chakrabarti on April 7, 2010.
 *
 * See LICENSE file for license information.
 * 
 */

@import <AppKit/CPWindowController.j>
@import "../AccountValidators/SCEmailAccountValidator.j"
@import "SCLoginDialogController.j"

var DefaultLoginDialogController = nil;
@implementation SCEmailLoginDialogController : SCLoginDialogController{ }

- (void)awakeFromCib
{
    [super awakeFromCib];
    _accountValidator = SCEmailAccountValidator;
    [_userLabel setStringValue:"E-mail:"];
    [_userLabel sizeToFit];
    [_userLabel setFrameOrigin:CGPointMake([_userField frame].origin.x - 4.0 - [_userLabel frame].size.width,
                                           [_userField frame].origin.y + 4.0)];
    [_userCheckSpinner setFrameOrigin:CGPointMake([_userLabel frame].origin.x - [_userCheckSpinner frame].size.width - 3.0,
                                                  [_userLabel frame].origin.y + 2.0)];
}

- (void)_setErrorMessageText:(CPString)anErrorMessage
{
    anErrorMessage = [anErrorMessage stringByReplacingOccurrencesOfString:@"username" withString:@"e-mail address"];
    anErrorMessage = [anErrorMessage stringByReplacingOccurrencesOfString:@"Username" withString:@"E-mail address"];
    [super _setErrorMessageText:anErrorMessage];
}

+ (SCLoginDialogController)defaultController
{
    if (!DefaultLoginDialogController) 
        DefaultLoginDialogController = [self newLoginDialogController];
    return DefaultLoginDialogController;
}

/* @ignore */
- (void)_loginUser:(CPString)username password:(CPString)password
{
    var shouldRemember = ([_rememberMeButton state] === CPOnState);
    var loginObject = {'user' : {'email' : username, 'password' : password, 'remember' : shouldRemember}};
    var request = [CPURLRequest requestWithURL:[[CPBundle mainBundle] objectForInfoDictionaryKey:@"SCAuthLoginURL"] || @"/session/"];

    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[CPString JSONFromObject:loginObject]];
    _loginConnection = [_connectionClass connectionWithRequest:request
                                                       delegate:self];
    _loginConnection.username = username;
}

/* @ignore */
- (void)_registerUser:(CPString)username password:(CPString)password
{
    var shouldRemember = ([_rememberMeButton state] === CPOnState);
    var registerObject = {'user' : {'email' : username, 'password' : password, 'remember' : shouldRemember}};
    var request = [CPURLRequest requestWithURL:[[CPBundle mainBundle] objectForInfoDictionaryKey:@"SCAuthRegistrationURL"] || @"/user/"];

    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[CPString JSONFromObject:registerObject]];
    _registrationConnection = [_connectionClass connectionWithRequest:request
                                                             delegate:self];
    _registrationConnection.username = username;
}

@end
