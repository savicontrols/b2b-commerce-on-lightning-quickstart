@isTest
public class SalesforceAdapterTest {

    @isTest
    public static void testprocessRequestAuthorize() {
        Test.startTest();
        SalesforceAdapter adapter = new SalesforceAdapter();
        commercepayments.AuthorizationRequest authRequest = new commercepayments.AuthorizationRequest(100);
        authRequest.currencyIsoCode = 'USD';
        authRequest.additionalData = new Map <String, String>{
            'token' => 'testToken'
        };
        commercepayments.paymentGatewayContext gatewayContext = new commercepayments.paymentGatewayContext(authRequest, commercepayments.RequestType.Authorize);
        commercepayments.GatewayResponse response = adapter.processRequest(gatewayContext);
        Test.stopTest();
    }

    @isTest
    public static void testProcessRequestTokinezation() {
    Test.startTest();
    SalesforceAdapter adapter = new SalesforceAdapter();
    commercepayments.PaymentMethodTokenizationRequest paymentRequest = new commercepayments.PaymentMethodTokenizationRequest('paymentGatewayId');
    commercepayments.CardPaymentMethodRequest cardPaymentMethodRequest = new commercepayments.CardPaymentMethodRequest(commercepayments.CardCategory.CreditCard);
    paymentRequest.address = new commercepayments.AddressRequest('street', 'city', 'state', 'country', 'postalCode');
    paymentRequest.cardPaymentMethod = cardPaymentMethodRequest;
    paymentRequest.cardPaymentMethod.cardHolderName = 'TEST CARDHOLDER NAME';
    commercepayments.paymentGatewayContext gatewayContext = new commercepayments.paymentGatewayContext(paymentRequest, commercepayments.RequestType.Tokenize);

    commercepayments.GatewayResponse response = adapter.processRequest(gatewayContext);
    Test.stopTest();
    }

    @isTest
    public static void testProcessRequestSale() {
    Test.startTest();
    SalesforceAdapter adapter = new SalesforceAdapter();
    commercepayments.SaleRequest saleRequest = new commercepayments.SaleRequest(100);
    saleRequest.comments = 'comments';
    saleRequest.currencyIsoCode = 'USD';
    commercepayments.paymentGatewayContext gatewayContext = new commercepayments.paymentGatewayContext(saleRequest, commercepayments.RequestType.Sale);

    commercepayments.GatewayResponse response = adapter.processRequest(gatewayContext);
    Test.stopTest();
    }

    @isTest
    public static void testProcessRequestCapture() {
    Test.startTest();
    SalesforceAdapter adapter = new SalesforceAdapter();
    commercepayments.CaptureRequest captureRequest = new commercepayments.CaptureRequest(100, 'authTestId');
    commercepayments.paymentGatewayContext gatewayContext = new commercepayments.paymentGatewayContext(captureRequest, commercepayments.RequestType.Capture);

    commercepayments.GatewayResponse response = adapter.processRequest(gatewayContext);
    Test.stopTest();
    }

    @isTest
    public static void testProcessRequestReferencedRefund() {
    Test.startTest();
    SalesforceAdapter adapter = new SalesforceAdapter();
    commercepayments.ReferencedRefundRequest referencedRefundRequest = new commercepayments.ReferencedRefundRequest(100, 'testId');
    commercepayments.paymentGatewayContext gatewayContext = new commercepayments.paymentGatewayContext(referencedRefundRequest, commercepayments.RequestType.ReferencedRefund);

    commercepayments.GatewayResponse response = adapter.processRequest(gatewayContext);
    Test.stopTest();
    }
}
