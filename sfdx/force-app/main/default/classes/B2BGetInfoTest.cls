@IsTest
public class B2BGetInfoTest {
    @testSetup static void setup() {
        Account testAccount = new Account(Name='TestAccount');
        insert testAccount;
        Contact testContact = new Contact(AccountId = testAccount.Id, LastName = 'TestContact');
        insert testContact;
        WebStore testWebStore = new WebStore(Name='TestWebStore', DefaultLanguage='en_US');
        insert testWebStore;
        
        Account account = [SELECT Id FROM Account WHERE Name='TestAccount' LIMIT 1];
        Contact contact = [SELECT Id FROM Contact WHERE Name='TestContact' LIMIT 1];
        WebStore webStore = [SELECT Id FROM WebStore WHERE Name='TestWebStore' LIMIT 1];
        WebCart cart = new WebCart(Name='Cart', WebStoreId=webStore.Id, AccountId=account.Id);
        insert cart;
        
        CartDeliveryGroup cartDeliveryGroup = new CartDeliveryGroup(CartId=cart.Id, Name='Default Delivery', DeliverToName = 'st. First Avenu');
        insert cartDeliveryGroup;

        Product2 p2 = new Product2(Name='Test Product',isActive=true);
        insert p2;

        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pricebookId, Product2Id=p2.Id, UnitPrice=99, isActive=true);
        insert pbe;
        
        CartItem cartItem = new CartItem(CartId=cart.Id, Sku='SKU_Test1', SalesPrice=10.00, Quantity=3.0, Type='Product', Name='TestProduct', CartDeliveryGroupId=cartDeliveryGroup.Id, Product2Id = p2.Id, ListPrice = 7.00);
        insert cartItem;

        CartCheckoutSession cartCheckoutSession = new CartCheckoutSession(Name = 'TestSession', State = 'Pending', WebCartId = cart.Id);
        insert cartCheckoutSession;

        Profile profile = [SELECT Id FROM Profile WHERE Name='B2B Storefront Registered Users' LIMIT 1];
        User user = new User(Alias='buyer', Email='buyer@example.com', LastName='Buyer',
                TimeZoneSidKey='GMT', LocaleSidKey='en_US', Username='buyer@example.com',
                EmailEncodingKey='UTF-8', ProfileId=profile.Id, LanguageLocaleKey='en_US',
                ContactId=contact.Id);
        insert user;
    }

    @isTest
    public static void testGetProduct() {
        Account account = [SELECT Id FROM Account WHERE Name='TestAccount' LIMIT 1];
        Profile pAdmin = [SELECT id, Name FROM Profile where name = 'System Administrator' ].get(0);  
        User cu = [SELECT Id FROM User WHERE UserName = 'buyer@example.com' LIMIT 1];
        User au = [SELECT Id FROM User WHERE ProfileId = :pAdmin.Id LIMIT 1];
        NetworkMember membership = [SELECT NetworkID, MemberID FROM NetworkMember WHERE memberID = :cu.Id LIMIT 1];
        Id communityId = membership.NetworkID;
        Product2 p2  = [SELECT Id FROM Product2 LIMIT 1];
        
        Test.startTest();
        System.debug('account.Id==>' + account.Id);
        System.debug('communityId==>' + communityId);
        System.debug('p2.Id==>' + p2.Id);
        System.debug('au==>' + au);
        // System.debug(B2BGetInfo.getProduct(communityId, p2.Id, account.Id));
        Test.stopTest();
    }


    @isTest
    public static void testCheckProductIsInStock() {
        Product2 p2  = [SELECT Id FROM Product2 LIMIT 1];
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetInventoryResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.startTest();
        // Associate the callout with a mock response.
        Test.setMock(HttpCalloutMock.class, mock);
        B2BGetInfo.checkProductIsInStock(p2.Id);
        Test.stopTest();
    }
    
}
