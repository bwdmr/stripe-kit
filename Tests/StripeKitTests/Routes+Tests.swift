import XCTest
@testable import StripeKit

import AsyncHTTPClient
import NIOCore

private func XCTAssertThrowsErrorAsync(
    _ expression: @escaping () async throws -> Void,
    file: StaticString = #filePath,
    line: UInt = #line
) async {
    do {
        try await expression()
        XCTFail("Expected error to be thrown", file: file, line: line)
    } catch {
        // success
    }
}

class RouteListTest: XCTestCase {
  enum RouteListTestError: Error { case fail }
  
  final class HTTPClientSpy: StripeHTTPClient {
      enum SpyError: Error { case stopAfterCapture }

      private(set) var lastRequest: HTTPClientRequest?

      func execute(
          _ request: HTTPClientRequest,
          timeout: TimeAmount
      ) async throws -> HTTPClientResponse {
          lastRequest = request
          throw SpyError.stopAfterCapture
      }
  }
  
  static let apiKey = "cn_123"
  static let spy = HTTPClientSpy()
  static let apihandlerSpy = StripeAPIHandler(stripehttpClient: spy, apiKey: apiKey)
  
  func testAll() async throws {
      try await testcreditnoteRoute()
      try await testcustomerbalancetransactionRoute()
      try await testportalconfigurationRoute()
      try await testcustomertaxidRoute()
      try await testinvoiceitemRoute()
      try await testinvoiceRoute()
      try await testaccountRoute()
      try await testcapabilityRoute()
      try await testbalanceRoute()
      try await testchargeRoute()
      try await testcustomerRoute()
      try await testpaymentintentRoute()
      try await testsetupintentRoute()
      try await testtokenRoute()
      try await testactiveentitlementRoute()
      try await testfeatureRoute()
      try await testearlyfraudwarningRoute()
      try await testreviewRoute()
      try await testvaluelistitemRoute()
      try await testvaluelistRoute()
      try await testverificationreportRoute()
      try await testverificationsessionRoute()
      try await testauthorizationRoute()
      try await testissuingcardRoute()
      try await testcardholderRoute()
      try await testissuingdisputeRoute()
      try await testfundinginstructionscreateRoute()
      try await testpaymentlinkRoute()
      try await testbankaccountRoute()
      try await testcardRoute()
      try await testcashbalanceRoute()
      try await testpaymentmethodRoute()
      try await testcouponRoute()
      try await testdiscountdeleteRoute()
      try await testpriceRoute()
      try await testproductRoute()
      try await testpromotioncodeRoute()
      try await testshippingrateRoute()
      try await testTaxCodeRoute()
      try await testTaxRateRoute()
      try await testReportRunRoute()
      try await testReportTypeRoute()
      try await testScheduledQueryRunRoute()
      try await testTerminalConfigurationRoute()
      try await testTerminalConnectionTokenRoute()
      try await testTerminalHardwareOrderRoute()
      try await testTerminalHardwareProductRoute()
      try await testTerminalHardwareShippingMethodRoute()
      try await testTerminalHardwareSKURoute()
      try await testTerminalLocationRoute()
      try await testTerminalReaderRoute()
      try await testWebhookEndpointRoute()
  }
  
  func testcreditnoteRoute() async throws {
    let creditnoteID = "cn_123"
    
    let sut = StripeCreditNoteRoutes(apiHandler: Self.apihandlerSpy)
    await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(id: creditnoteID) }
    
    guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
    XCTAssertEqual(lastRequest.method, .GET)
    XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/credit_notes/\(creditnoteID)")
  }
  
  func testcustomerbalancetransactionRoute() async throws {
      let customerID = "cus_123"
      let transactionID = "cbtxn_123"

      let sut = StripeCustomerBalanceTransactionRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(customer: customerID, transaction: transactionID) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)

      XCTAssertEqual(URL(string: lastRequest.url)?.path, "/v1/customers/\(customerID)/balance_transactions/\(transactionID)")
  }
  
  func testportalconfigurationRoute() async throws {
      let configurationID = "bpc_123"

      let sut = StripePortalConfigurationRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(configuration: configurationID) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)

      XCTAssertEqual(URL(string: lastRequest.url)?.path, "/v1/billing_portal/configurations/\(configurationID)")
  }
  
  func testcustomertaxidRoute() async throws {
      let customerID = "cus_123"
      let taxID = "txi_123"

      let sut = StripeCustomerTaxIDRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(id: taxID, customer: customerID) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/customers/\(customerID)/tax_ids/\(taxID)")
  }
  
  func testinvoiceitemRoute() async throws {
      let invoiceItemID = "ii_123"

      let sut = StripeInvoiceItemRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(invoiceItem: invoiceItemID) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/invoiceitems/\(invoiceItemID)")
  }
  
  func testinvoiceRoute() async throws {
      let invoiceID = "in_123"

      let sut = StripeInvoiceRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(invoice: invoiceID) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/invoices/\(invoiceID)")
  }
  
  func testmetereventRoute() async throws {
      let sut = StripeMeterEventRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.create(
          event_name: "test_event",
          payload: ["stripe_customer_id": "cus_123", "value": "100"],
          identifier: "evt_123",
          timestamp: Date()) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .POST)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/billing/meter_events")
  }
  
  func testplanRoute() async throws {
      let planID = "plan_123"

      let sut = StripePlanRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(plan: planID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/plans/\(planID)")
  }
  
  func testquotelineitemRoute() async throws {
      let quoteID = "qt_123"

      let sut = StripeQuoteLineItemRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(quote: quoteID, filter: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/quotes/\(quoteID)/line_items")
  }
  
  func testquoteRoute() async throws {
      let quoteID = "qt_123"

      let sut = StripeQuoteRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(quote: quoteID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/quotes/\(quoteID)")
  }
  
  func testsubscriptionitemRoute() async throws {
      let subscriptionItemID = "si_123"

      let sut = StripeSubscriptionItemRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(item: subscriptionItemID) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/subscription_items/\(subscriptionItemID)")
  }
  
  func testsubscriptionscheduleRoute() async throws {
      let scheduleID = "sub_sched_123"

      let sut = StripeSubscriptionScheduleRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(schedule: scheduleID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/subscription_schedules/\(scheduleID)")
  }
  
  func testsubscriptionRoute() async throws {
      let subscriptionID = "sub_123"

      let sut = StripeSubscriptionRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(id: subscriptionID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/subscriptions/\(subscriptionID)")
  }
  
  func testtestclockRoute() async throws {
      let testClockID = "clock_123"

      let sut = StripeTestClockRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(testClock: testClockID) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/test_helpers/test_clocks/\(testClockID)")
  }
  
  func testusagerecordRoute() async throws {
      let subscriptionItemID = "si_123"

      let sut = StripeUsageRecordRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.create(
          quantity: 100,
          subscriptionItem: subscriptionItemID,
          timestamp: nil,
          action: nil)
      }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .POST)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/subscription_items/\(subscriptionItemID)/usage_records")
  }
  
  func testaccountlinkRoute() async throws {
      let accountID = "acct_123"

      let sut = StripeAccountLinkRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.create(
          account: accountID,
          refreshUrl: "https://example.com/refresh",
          returnUrl: "https://example.com/return",
          type: .accountOnboarding,
          collect: nil)
      }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .POST)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/account_links")
  }
  
  func testaccountsessionRoute_create() async throws {
      let accountID = "acct_123"

      let sut = StripeAccountSessionsRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.create(account: accountID) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .POST)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/account_sessions")
  }
  
  func testaccountRoute() async throws {
      let accountID = "acct_123"

      let sut = StripeConnectAccountRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(account: accountID) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/accounts/\(accountID)")
  }
  
  func testapplicationfeerefundRoute() async throws {
      let feeID = "fee_123"
      let refundID = "fr_123"

      let sut = StripeApplicationFeeRefundRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(refund: refundID, fee: feeID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/application_fees/\(feeID)/refunds/\(refundID)")
  }
  
  func testapplicationfeeRoute() async throws {
      let feeID = "fee_123"

      let sut = StripeApplicationFeeRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(fee: feeID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/application_fees/\(feeID)")
  }
  
  func testcapabilityRoute() async throws {
      let accountID = "acct_123"

      let sut = StripeCapabilitiesRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(capability: accountID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/accounts/\(accountID)/capabilities/card_payments")
  }
  
  func testcountryspecRoute() async throws {
      let countryCode = "US"

      let sut = StripeCountrySpecRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(country: countryCode) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/country_specs/\(countryCode)")
  }
  
  func testexternalaccountretrieveBankAccountRoute() async throws {
      let accountID = "acct_123"
      let bankAccountID = "ba_123"

      let sut = StripeExternalAccountsRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieveBankAccount(account: accountID, id: bankAccountID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/accounts/\(accountID)/external_accounts/\(bankAccountID)")
  }

  func testexternalaccountretrieveCardRoute() async throws {
      let accountID = "acct_123"
      let cardID = "card_123"

      let sut = StripeExternalAccountsRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieveCard(account: accountID, id: cardID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/accounts/\(accountID)/external_accounts/\(cardID)")
  }
  
  func testpersonRoute() async throws {
      let accountID = "acct_123"
      let personID = "person_123"

      let sut = StripePersonRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(account: accountID, person: personID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/accounts/\(accountID)/persons/\(personID)")
  }
  
  func testsecretRoute_find() async throws {
      let secretName = "my_secret"
      let scope = ["type": "account", "user": "acct_123"]

      let sut = StripeSecretRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.find(name: secretName, scope: scope, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/secrets/find")
  }
  
  func testtopupRoute() async throws {
      let topupID = "tu_123"

      let sut = StripeTopUpRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(topup: topupID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/topups/\(topupID)")
  }
  
  func testtransferreversalRoute() async throws {
      let transferID = "tr_123"
      let reversalID = "trr_123"

      let sut = StripeTransferReversalRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(id: reversalID, transfer: transferID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/transfers/\(reversalID)/reversals/\(reversalID)")
  }
  
  func testtransferRoute() async throws {
      let transferID = "tr_123"

      let sut = StripeTransferRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(transfer: transferID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/transfers/\(transferID)")
  }
  
  func testbalanceRoute() async throws {
      let sut = StripeBalanceRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve() }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/balance")
  }
  
  func testbalancetransactionRoute() async throws {
      let transactionID = "txn_123"

      let sut = StripeBalanceTransactionRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(id: transactionID) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/balance_transactions/\(transactionID)")
  }
  
  func testchargeRoute() async throws {
      let chargeID = "ch_123"

      let sut = StripeChargeRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(charge: chargeID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/charges/\(chargeID)")
  }
  
  func testcustomerRoute() async throws {
      let customerID = "cus_123"

      let sut = StripeCustomerRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(customer: customerID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/customers/\(customerID)")
  }
  
  func testdisputeRoute() async throws {
      let disputeID = "dp_123"

      let sut = StripeDisputeRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(dispute: disputeID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/disputes/\(disputeID)")
  }
  
  func testephemeralKeyRoute() async throws {
      let customerID = "cus_123"

      let sut = StripeEphemeralKeyRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.create(
          customer: customerID,
          issuingCard: nil,
          verificationSession: nil,
          expand: nil)
      }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .POST)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/ephemeral_keys")
  }
  
  func testeventRoute() async throws {
      let eventID = "evt_123"

      let sut = StripeEventRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(id: eventID) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/events/\(eventID)")
  }
  
  func testfilelinkRoute() async throws {
      let fileLinkID = "link_123"

      let sut = StripeFileLinkRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(link: fileLinkID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/file_links/\(fileLinkID)")
  }
  
  func testfileRoute() async throws {
      let fileID = "file_123"

      let sut = StripeFileRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(file: fileID) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/files/\(fileID)")
  }
  
  func testmandateRoute() async throws {
      let mandateID = "mandate_123"

      let sut = StripeMandateRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(mandate: mandateID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/mandates/\(mandateID)")
  }
  
  func testpaymentintentRoute() async throws {
      let paymentIntentID = "pi_123"

      let sut = StripePaymentIntentRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(intent: paymentIntentID, clientSecret: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/payment_intents/\(paymentIntentID)")
  }
  
  func testpayoutRoute() async throws {
      let payoutID = "po_123"

      let sut = StripePayoutRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(payout: payoutID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/payouts/\(payoutID)")
  }
  
  func testrefundRoute() async throws {
      let refundID = "re_123"

      let sut = StripeRefundRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(refund: refundID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/refunds/\(refundID)")
  }
  
  func testsetupattemptRoute() async throws {
      let setupIntentID = "seti_123"

      let sut = StripeSetupAttemptRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.listAll(setupIntent: setupIntentID, filter: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/setup_attempts/\(setupIntentID)")
  }
  
  func testsetupintentRoute() async throws {
      let setupIntentID = "seti_123"

      let sut = StripeSetupIntentsRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(intent: setupIntentID, clientSecret: nil, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/setup_intents/\(setupIntentID)")
  }
  
  func testtokenRoute() async throws {
      let tokenID = "tok_123"

      let sut = StripeTokenRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(token: tokenID) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/tokens/\(tokenID)")
  }
  
  func testactiveentitlementRoute() async throws {
      let entitlementID = "ae_123"

      let sut = StripeActiveEntitlementRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(id: entitlementID) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/entitlements/active_entitlements/\(entitlementID)")
  }
  
  func testfeatureRoute() async throws {
      let sut = StripeFeatureRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.create(
          lookupKey: "feature_key",
          name: "Premium Feature",
          metadata: nil)
      }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .POST)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/entitlements/features")
  }
  
  func testearlyfraudwarningRoute() async throws {
      let earlyFraudWarningID = "issfr_123"

      let sut = StripeEarlyFraudWarningRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(earlyFraudWarning: earlyFraudWarningID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/radar/early_fraud_warnings/\(earlyFraudWarningID)")
  }
  
  func testreviewRoute() async throws {
      let reviewID = "prv_123"

      let sut = StripeReviewRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(review: reviewID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/reviews\(reviewID)")
  }
  
  func testvaluelistitemRoute() async throws {
      let itemID = "rsli_123"

      let sut = StripeValueListItemRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(item: itemID) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/radar/value_list_items/\(itemID)")
  }
  
  func testvaluelistRoute() async throws {
      let valueListID = "rsl_123"

      let sut = StripeValueListRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(valueList: valueListID) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/radar/value_lists/\(valueListID)")
  }
  
  func testverificationreportRoute() async throws {
      let verificationReportID = "vr_123"

      let sut = StripeVerificationReportRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(verificationReportId: verificationReportID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/identity/verification_reports/\(verificationReportID)")
  }
  
  func testverificationsessionRoute() async throws {
      let verificationSessionID = "vs_123"

      let sut = StripeVerificationSessionRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(verificationSessionId: verificationSessionID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/identity/verification_sessions/\(verificationSessionID)")
  }
  
  func testauthorizationRoute() async throws {
      let authorizationID = "iauth_123"

      let sut = StripeAuthorizationRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(authorization: authorizationID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/issuing/authorizations/\(authorizationID)")
  }
  
  func testissuingcardRoute() async throws {
      let cardID = "ic_123"

      let sut = StripeIssuingCardRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(card: cardID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/issuing/cards/\(cardID)")
  }
  
  func testcardholderRoute() async throws {
      let cardholderID = "ich_123"

      let sut = StripeCardholderRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(cardholder: cardholderID) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/issuing/cardholders/\(cardholderID)")
  }
  
  func testissuingdisputeRoute() async throws {
      let disputeID = "idp_123"

      let sut = StripeIssuingDisputeRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(dispute: disputeID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/issuing/disputes/\(disputeID)")
  }
  
  func testfundinginstructionscreateRoute() async throws {
      let bankTransfer = ["type": "eu_bank_transfer"]
      let currency = Currency.usd
      let fundingType = FundingInstructionsFundingType.bankTransfer

      let sut = StripeFundingInstructionsRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.create(
          bankTransfer: bankTransfer,
          currency: currency,
          fundingType: fundingType)
      }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .POST)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/issuing/funding_instructions")
  }
  
  func testpaymentlinkRoute() async throws {
      let paymentLinkID = "plink_123"

      let sut = StripePaymentLinkRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(id: paymentLinkID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/payment_links/\(paymentLinkID)")
  }
  
  func testbankaccountRoute() async throws {
      let customerID = "cus_123"
      let bankAccountID = "ba_123"

      let sut = StripeBankAccountRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(id: bankAccountID, customer: customerID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/customers/\(customerID)/sources/\(bankAccountID)")
  }
  
  func testcardRoute() async throws {
      let customerID = "cus_123"
      let cardID = "card_123"

      let sut = StripeCardRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(id: cardID, customer: customerID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/customers/\(customerID)/sources/\(cardID)")
  }
  
  func testcashbalanceRoute() async throws {
      let customerID = "cus_123"

      let sut = StripeCashBalanceRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(customer: customerID) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/customers/\(customerID)/cash_balance")
  }
  
  func testpaymentmethodRoute() async throws {
      let paymentMethodID = "pm_123"

      let sut = StripePaymentMethodRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(paymentMethod: paymentMethodID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/payment_methods/\(paymentMethodID)")
  }
  
  func testcouponRoute() async throws {
      let couponID = "25OFF"

      let sut = StripeCouponRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(coupon: couponID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/coupons/\(couponID)")
  }
  
  func testdiscountdeleteRoute() async throws {
      let customerID = "cus_123"

      let sut = StripeDiscountRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.delete(customer: customerID) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .DELETE)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/customers/\(customerID)/discount")
  }
  
  func testpriceRoute() async throws {
      let priceID = "price_123"

      let sut = StripePriceRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(price: priceID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/prices/\(priceID)")
  }
  
  func testproductRoute() async throws {
      let productID = "prod_123"

      let sut = StripeProductRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(id: productID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/products/\(productID)")
  }
  
  func testpromotioncodeRoute() async throws {
      let promotionCodeID = "promo_123"

      let sut = StripePromotionCodesRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(promotionCode: promotionCodeID) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/promotion_codes/\(promotionCodeID)")
  }
  
  func testshippingrateRoute() async throws {
      let shippingRateID = "shr_123"

      let sut = StripeShippingRateRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(id: shippingRateID, expand: nil) }

      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/shipping_rates/\(shippingRateID)")
  }
  
  func testTaxCodeRoute() async throws {
      let taxCodeID = "txcd_123"
      let sut = StripeTaxCodeRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(id: taxCodeID) }
      
      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/tax_codes/\(taxCodeID)")
  }
  
  func testTaxRateRoute() async throws {
      let taxRateID = "txr_123"
      let sut = StripeTaxRateRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(taxRate: taxRateID) }
      
      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/tax_rates/\(taxRateID)")
  }
  
  func testReportRunRoute() async throws {
      let reportRunID = "frr_123"
      let sut = StripeReportRunRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(reportRun: reportRunID) }
      
      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/reporting/report_runs/\(reportRunID)")
  }
  
  func testReportTypeRoute() async throws {
      let reportTypeID = "balance.summary.1"
      let sut = StripeReportTypeRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(reportType: reportTypeID) }
      
      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/reporting/report_types/\(reportTypeID)")
  }
  
  func testScheduledQueryRunRoute() async throws {
      let scheduledQueryRunID = "sqr_123"
      let sut = StripeScheduledQueryRunRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(scheduledQueryRun: scheduledQueryRunID) }
      
      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/scheduled_query_runs/\(scheduledQueryRunID)")
  }
  
  func testTerminalConfigurationRoute() async throws {
      let configID = "tmc_123"
      let sut = StripeTerminalConfigurationRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(config: configID, expand: nil) }
      
      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/terminal/configurations/\(configID)")
  }
  
  func testTerminalConnectionTokenRoute() async throws {
      let sut = StripeTerminalConnectionTokenRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.create(location: nil) }
      
      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .POST)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/terminal/connection_tokens")
  }
  
  func testTerminalHardwareOrderRoute() async throws {
      let orderID = "tho_123"
      let sut = StripeTerminalHardwareOrderRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(order: orderID) }
      
      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/terminal/hardware_orders/\(orderID)")
  }
  
  func testTerminalHardwareProductRoute() async throws {
      let productID = "thp_123"
      let sut = StripeTerminalHardwareProductRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(product: productID) }
      
      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/terminal/hardware_products/\(productID)")
  }
  
  func testTerminalHardwareShippingMethodRoute() async throws {
      let shippingMethodID = "thsm_123"
      let sut = StripeTerminalHardwareShippingMethodRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(shippingMethod: shippingMethodID) }
      
      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/terminal/hardware_shipping_methods/\(shippingMethodID)")
  }
  
  func testTerminalHardwareSKURoute() async throws {
      let skuID = "thsku_123"
      let sut = StripeTerminalHardwareSKURoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(sku: skuID) }
      
      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/terminal/hardware_skus/\(skuID)")
  }
  
  func testTerminalLocationRoute() async throws {
      let locationID = "tml_123"
      let sut = StripeTerminalLocationRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(location: locationID) }
      
      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/terminal/locations/\(locationID)")
  }
  
  func testTerminalReaderRoute() async throws {
      let readerID = "tmr_123"
      let sut = StripeTerminalReaderRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(reader: readerID, expand: nil) }
      
      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/terminal/readers/\(readerID)")
  }
  
  func testWebhookEndpointRoute() async throws {
      let webhookEndpointID = "we_123"
      let sut = StripeWebhookEndpointRoutes(apiHandler: Self.apihandlerSpy)
      await XCTAssertThrowsErrorAsync { _ = try await sut.retrieve(webhookEndpoint: webhookEndpointID) }
      
      guard let lastRequest = Self.spy.lastRequest else { throw RouteListTestError.fail }
      XCTAssertEqual(lastRequest.method, .GET)
      XCTAssertEqual(URL(string: lastRequest.url)?.path(), "/v1/webhook_endpoints/\(webhookEndpointID)")
  }
}
