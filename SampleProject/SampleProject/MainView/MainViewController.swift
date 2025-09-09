//
//  MainViewController.swift
//  SampleProject
//
//  Created by Banu on 20.08.2024.
//

import LatiFlex
import UIKit

class MainViewController: UIViewController  {

    var viewModel: MainViewModelProtocol = MainViewModel() 
        
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
        // Clear any existing events first
        LatiFlex.shared.events.removeAll()
        
        // Register event types - Demeter first as general
        LatiFlex.shared.appendEventTypes(type: "Demeter")
        LatiFlex.shared.appendEventTypes(type: "Firebase")
        LatiFlex.shared.appendEventTypes(type: "Facebook")
        LatiFlex.shared.appendEventTypes(type: "Adjust")
        LatiFlex.shared.appendEventTypes(type: "Delphoi")
        LatiFlex.shared.appendEventTypes(type: "CleverTap")
        LatiFlex.shared.appendEventTypes(type: "NewRelic")
        
        // Add Firebase events - some repetitive
        LatiFlex.shared.appendEvents(type: "Firebase", eventResult: .success(name: "screen_view", parameters: ["eventCategory": "Homepage", "screen_name": "home"]))
        LatiFlex.shared.appendEvents(type: "Firebase", eventResult: .success(name: "screen_view", parameters: ["eventCategory": "Homepage", "screen_name": "home"]))
        LatiFlex.shared.appendEvents(type: "Firebase", eventResult: .success(name: "screen_view", parameters: ["eventCategory": "Homepage", "screen_name": "home"]))
        LatiFlex.shared.appendEvents(type: "Firebase", eventResult: .success(name: "button_click", parameters: ["eventCategory": "ProductDetail", "button_name": "add_to_cart"]))
        LatiFlex.shared.appendEvents(type: "Firebase", eventResult: .success(name: "purchase", parameters: ["eventCategory": "Checkout", "total": "99.99"]))
        
        // Add Adjust events - multiple similar events
        LatiFlex.shared.appendEvents(type: "Adjust", eventResult: .success(name: "app_open", parameters: ["event": "AppOpen", "source": "notification"]))
        LatiFlex.shared.appendEvents(type: "Adjust", eventResult: .success(name: "app_open", parameters: ["event": "AppOpen", "source": "notification"]))
        LatiFlex.shared.appendEvents(type: "Adjust", eventResult: .success(name: "app_open", parameters: ["event": "AppOpen", "source": "notification"]))
        LatiFlex.shared.appendEvents(type: "Adjust", eventResult: .success(name: "app_open", parameters: ["event": "AppOpen", "source": "notification"]))
        LatiFlex.shared.appendEvents(type: "Adjust", eventResult: .success(name: "user_signup", parameters: ["event": "UserSignup", "method": "email"]))
        
        // Add Demeter events with complex grouping patterns
        
        // Add failed events FIRST (since events are shown in reverse order)
        for _ in 1...5 {
            LatiFlex.shared.appendEvents(type: "Demeter", eventResult: .failure(NSError(domain: "DemeterError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid parameters"])))
        }
        LatiFlex.shared.appendEvents(type: "Demeter", eventResult: .failure(NSError(domain: "DemeterError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error"])))
        LatiFlex.shared.appendEvents(type: "Demeter", eventResult: .failure(NSError(domain: "DemeterError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized"])))
        
        // Now add success events (these will appear at the top when reversed)
        
        // SCENARIO 1: Events with same name but different groups (testing subtitle grouping)
        for i in 1...3 {
            LatiFlex.shared.appendEvents(type: "Demeter", eventResult: .success(name: "ProductView", parameters: ["event": "product_view", "event_group": "Discovery", "product_id": "1234\(i)", "category": "Electronics"]))
        }
        for i in 1...2 {
            LatiFlex.shared.appendEvents(type: "Demeter", eventResult: .success(name: "ProductView", parameters: ["event": "product_view", "event_group": "Recommendation", "product_id": "rec_\(i)", "source": "AI"]))
        }
        for i in 1...4 {
            LatiFlex.shared.appendEvents(type: "Demeter", eventResult: .success(name: "ProductView", parameters: ["event": "product_view", "event_group": "Search", "product_id": "search_\(i)", "query": "laptop"]))
        }
        
        // SCENARIO 2: Multiple events with exact same name and group (should group heavily)
        for _ in 1...15 {
            LatiFlex.shared.appendEvents(type: "Demeter", eventResult: .success(name: "AddToCart", parameters: ["event": "add_to_cart", "event_group": "Purchase", "source": "product_page"]))
        }
        
        // SCENARIO 3: Same event name, different groups showing user journey
        LatiFlex.shared.appendEvents(type: "Demeter", eventResult: .success(name: "UserAction", parameters: ["event": "click", "event_group": "Homepage", "element": "banner"]))
        LatiFlex.shared.appendEvents(type: "Demeter", eventResult: .success(name: "UserAction", parameters: ["event": "click", "event_group": "ProductList", "filter": "price"]))
        LatiFlex.shared.appendEvents(type: "Demeter", eventResult: .success(name: "UserAction", parameters: ["event": "click", "event_group": "ProductDetail", "button": "size_guide"]))
        
        // SCENARIO 4: Repetitive scroll events (testing large grouping)
        for _ in 1...25 {
            LatiFlex.shared.appendEvents(type: "Demeter", eventResult: .success(name: "PageScroll", parameters: ["event": "scroll", "event_group": "ProductList", "page": "products"]))
        }
        
        // SCENARIO 5: Filter events with identical parameters (heavy grouping)
        for _ in 1...12 {
            LatiFlex.shared.appendEvents(type: "Demeter", eventResult: .success(name: "FilterApplied", parameters: ["event": "filter", "event_group": "Discovery", "filter_type": "price", "value": "0-100"]))
        }
        
        // SCENARIO 6: Social events showing different platforms
        let platforms = ["WhatsApp", "WhatsApp", "WhatsApp", "Instagram", "Instagram", "Twitter", "Facebook", "Facebook"]
        for platform in platforms {
            LatiFlex.shared.appendEvents(type: "Demeter", eventResult: .success(name: "ProductShared", parameters: ["event": "share", "event_group": "Social", "platform": platform]))
        }
        
        // SCENARIO 7: Account flow with mixed groups
        LatiFlex.shared.appendEvents(type: "Demeter", eventResult: .success(name: "LoginAttempt", parameters: ["event": "login_attempt", "event_group": "Account", "method": "email"]))
        LatiFlex.shared.appendEvents(type: "Demeter", eventResult: .success(name: "LoginAttempt", parameters: ["event": "login_attempt", "event_group": "Account", "method": "email"]))
        LatiFlex.shared.appendEvents(type: "Demeter", eventResult: .success(name: "LoginSuccess", parameters: ["event": "login_success", "event_group": "Account", "user_id": "12345"]))
        
        // SCENARIO 8: Wishlist with varying patterns
        for _ in 1...8 {
            LatiFlex.shared.appendEvents(type: "Demeter", eventResult: .success(name: "WishlistAction", parameters: ["event": "wishlist_add", "event_group": "Engagement", "action": "add"]))
        }
        LatiFlex.shared.appendEvents(type: "Demeter", eventResult: .success(name: "WishlistAction", parameters: ["event": "wishlist_remove", "event_group": "Engagement", "action": "remove"]))
        
        // SCENARIO 9: Mixed single events
        LatiFlex.shared.appendEvents(type: "Demeter", eventResult: .success(name: "CheckoutStarted", parameters: ["event": "checkout_start", "event_group": "Purchase", "cart_value": "299.99"]))
        LatiFlex.shared.appendEvents(type: "Demeter", eventResult: .success(name: "PaymentMethodSelected", parameters: ["event": "payment_selected", "event_group": "Purchase", "method": "credit_card"]))
        LatiFlex.shared.appendEvents(type: "Demeter", eventResult: .success(name: "OrderCompleted", parameters: ["event": "order_complete", "event_group": "Purchase", "order_id": "ORD12345"]))
        
        // Add Delphoi events with tv003 grouping
        LatiFlex.shared.appendEvents(type: "Delphoi", eventResult: .success(name: "page_view", parameters: ["event": "PageView", "tv003": "HomePage", "tv001": "mobile"]))
        LatiFlex.shared.appendEvents(type: "Delphoi", eventResult: .success(name: "page_view", parameters: ["event": "PageView", "tv003": "HomePage", "tv001": "mobile"]))
        LatiFlex.shared.appendEvents(type: "Delphoi", eventResult: .success(name: "page_view", parameters: ["event": "PageView", "tv003": "HomePage", "tv001": "mobile"]))
        LatiFlex.shared.appendEvents(type: "Delphoi", eventResult: .success(name: "click", parameters: ["event": "Click", "tv003": "ProductDetail", "tv002": "add_button"]))
        LatiFlex.shared.appendEvents(type: "Delphoi", eventResult: .success(name: "click", parameters: ["event": "Click", "tv003": "ProductDetail", "tv002": "add_button"]))
        
        // Add some failed events
        LatiFlex.shared.appendEvents(type: "Firebase", eventResult: .failure(NSError(domain: "FirebaseError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Authentication failed"])))
        LatiFlex.shared.appendEvents(type: "Adjust", eventResult: .failure(NSError(domain: "AdjustError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error"])))
        LatiFlex.shared.appendEvents(type: "Adjust", eventResult: .failure(NSError(domain: "AdjustError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error"])))
        
        // Add CleverTap events
        LatiFlex.shared.appendEvents(type: "CleverTap", eventResult: .success(name: "App Launched", parameters: ["event": "AppLaunched", "launch_count": "5"]))
        LatiFlex.shared.appendEvents(type: "CleverTap", eventResult: .success(name: "App Launched", parameters: ["event": "AppLaunched", "launch_count": "6"]))
        LatiFlex.shared.appendEvents(type: "CleverTap", eventResult: .success(name: "Product Viewed", parameters: ["event": "ProductViewed", "product_name": "iPhone"]))
        
        // Add NewRelic events
        LatiFlex.shared.appendEvents(type: "NewRelic", eventResult: .success(name: "custom_event", parameters: ["event": "APICall", "endpoint": "/products"]))
        LatiFlex.shared.appendEvents(type: "NewRelic", eventResult: .success(name: "custom_event", parameters: ["event": "APICall", "endpoint": "/products"]))
        LatiFlex.shared.appendEvents(type: "NewRelic", eventResult: .success(name: "custom_event", parameters: ["event": "APICall", "endpoint": "/products"]))
        LatiFlex.shared.appendEvents(type: "NewRelic", eventResult: .success(name: "error_event", parameters: ["event": "ErrorOccurred", "error_type": "NetworkTimeout"]))
        
        // Add some events with exact same title and subtitle to test grouping
        for _ in 1...10 {
            LatiFlex.shared.appendEvents(type: "Firebase", eventResult: .success(name: "repetitive_event", parameters: ["eventCategory": "TestCategory", "action": "test_action"]))
        }
        
        // Add Facebook events with complex patterns
        
        // Add failed events first
        LatiFlex.shared.appendEvents(type: "Facebook", eventResult: .failure(NSError(domain: "FacebookError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid pixel ID"])))
        LatiFlex.shared.appendEvents(type: "Facebook", eventResult: .failure(NSError(domain: "FacebookError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Authentication failed"])))
        LatiFlex.shared.appendEvents(type: "Facebook", eventResult: .failure(NSError(domain: "FacebookError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error"])))
        
        // Now add success events
        for _ in 1...5 {
            LatiFlex.shared.appendEvents(type: "Facebook", eventResult: .success(name: "fb_mobile_purchase", parameters: ["event": "Purchase", "currency": "USD", "value": "29.99"]))
        }
        
        for _ in 1...3 {
            LatiFlex.shared.appendEvents(type: "Facebook", eventResult: .success(name: "fb_mobile_add_to_cart", parameters: ["event": "AddToCart", "content_id": "SKU123"]))
        }
        
        LatiFlex.shared.appendEvents(type: "Facebook", eventResult: .success(name: "fb_mobile_initiated_checkout", parameters: ["event": "InitiatedCheckout", "num_items": "3"]))
        LatiFlex.shared.appendEvents(type: "Facebook", eventResult: .success(name: "fb_mobile_rate", parameters: ["event": "Rate", "rating": "5"]))
        
        for _ in 1...4 {
            LatiFlex.shared.appendEvents(type: "Facebook", eventResult: .success(name: "fb_mobile_content_view", parameters: ["event": "ViewContent", "content_type": "product"]))
        }
        
        LatiFlex.shared.appendEvents(type: "Facebook", eventResult: .success(name: "fb_mobile_search", parameters: ["event": "Search", "search_string": "summer dress"]))
        LatiFlex.shared.appendEvents(type: "Facebook", eventResult: .success(name: "fb_mobile_search", parameters: ["event": "Search", "search_string": "winter coat"]))
        
        for _ in 1...6 {
            LatiFlex.shared.appendEvents(type: "Facebook", eventResult: .success(name: "fb_mobile_add_to_wishlist", parameters: ["event": "AddToWishlist", "content_id": "WISH123"]))
        }
        
        LatiFlex.shared.appendEvents(type: "Facebook", eventResult: .success(name: "fb_mobile_complete_registration", parameters: ["event": "CompleteRegistration", "registration_method": "email"]))

        let deeplinks = try! LocalJsonDecoder.shared.read(for: LatiFlexDeeplinksResponse.self,
                                                          withName: "Deeplinks",
                                                          bundle: .main)
        LatiFlex.shared.deeplinks = deeplinks
        
    }
   
   
    @IBAction func tappedForRequest(_ sender: Any) {
        LatiFlex.shared.show()
        viewModel.tappedForRequest()
    }
    
    @IBAction func tappedForBreakingNews(_ sender: Any) {
        LatiFlex.shared.show()
        viewModel.tappedForBreakingNews()
    }
    
}

extension MainViewController: MainViewModelDelegate {
    
}
