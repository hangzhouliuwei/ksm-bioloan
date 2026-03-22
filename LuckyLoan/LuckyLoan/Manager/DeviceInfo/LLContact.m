//
//  LLContact.m
//  LuckyLoan
//
//  Created by hao on 2024/1/21.
//

#import "LLContact.h"
#import <ContactsUI/ContactsUI.h>

@interface LLContact() <CNContactPickerDelegate>
@end


@implementation LLContact

- (void)showContact {

    CNContactPickerViewController *contactPicker = [[CNContactPickerViewController alloc] init];
    contactPicker.delegate = self;
    contactPicker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
    [Page present:contactPicker animated:YES completion:nil];
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    
    NSString *name = [NSString stringWithFormat:@"%@%@",contactProperty.contact.familyName,contactProperty.contact.givenName];
    NSString *phone = [contactProperty.value stringValue];
    
    if (self.selectBlock) {
        self.selectBlock(@{@"phone":NotNull(phone),@"name":NotNull(name)});
    }
}

@end
