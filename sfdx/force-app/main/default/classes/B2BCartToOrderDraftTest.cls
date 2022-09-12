@isTest
public class B2BCartToOrderDraftTest {
    @testSetup static void setup() {
        Account testAccount = new Account(Name='TestAccount');
        insert testAccount;
        WebStore testWebStore = new WebStore(Name='TestWebStore', DefaultLanguage='en_US');
        insert testWebStore;
        
        Account account = [SELECT Id FROM Account WHERE Name='TestAccount' LIMIT 1];
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
    }
    
    @isTest static void testWhenCartToOrderSuccessStatusIsReturned() {
        Test.startTest();
        B2BCartToOrderDraft.B2BCartToOrderDraftRequest cartToOrderRequest = new B2BCartToOrderDraft.B2BCartToOrderDraftRequest();
        List<B2BCartToOrderDraft.B2BCartToOrderDraftRequest>  lCartToOrderRequest = new   List<B2BCartToOrderDraft.B2BCartToOrderDraftRequest>();

        CartCheckoutSession cartCheckoutSession  = [SELECT Id FROM CartCheckoutSession WHERE Name = 'TestSession' LIMIT 1];
        WebCart webCart = [SELECT Id FROM WebCart WHERE Name='Cart' LIMIT 1];

        cartToOrderRequest.checkoutSessionId = cartCheckoutSession.Id;
        cartToOrderRequest.cartId = webCart.Id;
        lCartToOrderRequest.add(cartToOrderRequest);

        List<Id> orderIds = B2BCartToOrderDraft.cartToOrder(lCartToOrderRequest);
        Order order = [SELECT Id FROM Order LIMIT 1];
        System.assertEquals(order.Id, orderIds[0]);
        Test.stopTest();
    }
}