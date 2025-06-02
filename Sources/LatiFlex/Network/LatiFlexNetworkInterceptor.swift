import Foundation

class LatiFlexNetworkInterceptor {
    static let shared = LatiFlexNetworkInterceptor()
    
    private let mockResponsesKey = "mockResponses"
    private let mockEnabledKey = "enableMockSwitch"
    private let queue = DispatchQueue(label: "com.latiflex.networkinterceptor", qos: .userInitiated)
    
    // In-memory cache
    private var mockResponsesCache: [String: String] = [:]
    private var isMockEnabled: Bool = false
    
    // URLSession yönetimi
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 300
        config.waitsForConnectivity = true
        return URLSession(configuration: config)
    }()
    
    // Performans metrikleri
    private var requestCount: Int = 0
    private var totalResponseTime: TimeInterval = 0
    
    private init() {
        // İlk başlatmada cache'i doldur
        queue.sync {
            isMockEnabled = UserDefaults.standard.bool(forKey: mockEnabledKey)
            loadMockResponsesFromDisk()
        }
    }
    
    private func loadMockResponsesFromDisk() {
        if let data = UserDefaults.standard.data(forKey: mockResponsesKey),
           let responses = try? JSONDecoder().decode([String: String].self, from: data) {
            mockResponsesCache = responses
        }
    }
    
    private func saveMockResponsesToDisk() {
        if let data = try? JSONEncoder().encode(mockResponsesCache) {
            UserDefaults.standard.set(data, forKey: mockResponsesKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    func setMockEnabled(_ enabled: Bool) {
        queue.async {
            self.isMockEnabled = enabled
            if enabled {
                self.clearMockResponses()
            }
            UserDefaults.standard.set(enabled, forKey: self.mockEnabledKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    func isMockingEnabled() -> Bool {
        return queue.sync { isMockEnabled }
    }
    
    func saveMockResponse(_ response: String, for url: URL) {
        queue.async {
            self.mockResponsesCache[url.absoluteString] = response
            self.saveMockResponsesToDisk()
        }
    }
    
    func shouldUseMockResponse(for url: URL) -> String? {
        return queue.sync {
            guard isMockEnabled else { return nil }
            return mockResponsesCache[url.absoluteString]
        }
    }
    
    func clearMockResponses() {
        queue.async {
            self.mockResponsesCache.removeAll()
            self.saveMockResponsesToDisk()
        }
    }
    
    func removeMockResponse(for url: URL) {
        queue.async {
            self.mockResponsesCache.removeValue(forKey: url.absoluteString)
            self.saveMockResponsesToDisk()
        }
    }
    
    func interceptRequest(_ request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let startTime = Date()
        
        queue.async { [weak self] in
            guard let self = self,
                  let url = request.url else {
                DispatchQueue.main.async {
                    completion(nil, nil, NSError(domain: "com.latiflex", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
                }
                return
            }
            
            // Performans metriklerini güncelle
            self.requestCount += 1
            
            if let mockResponse = self.shouldUseMockResponse(for: url),
               let data = mockResponse.data(using: .utf8) {
                print("🎭 Using mock response for URL:", url.absoluteString)
                let response = HTTPURLResponse(url: url,
                                             statusCode: 200,
                                             httpVersion: "1.1",
                                             headerFields: nil)
                
                let endTime = Date()
                self.totalResponseTime += endTime.timeIntervalSince(startTime)
                
                DispatchQueue.main.async {
                    completion(data, response, nil)
                }
                return
            }
            
            print("🌐 Using real network request for URL:", url.absoluteString)
            self.session.dataTask(with: request) { [weak self] data, response, error in
                if let self = self {
                    let endTime = Date()
                    self.totalResponseTime += endTime.timeIntervalSince(startTime)
                }
                
                DispatchQueue.main.async {
                    completion(data, response, error)
                }
            }.resume()
        }
    }
    
    // Performans metrikleri
    var averageResponseTime: TimeInterval {
        queue.sync {
            return requestCount > 0 ? totalResponseTime / TimeInterval(requestCount) : 0
        }
    }
    
    func resetMetrics() {
        queue.async {
            self.requestCount = 0
            self.totalResponseTime = 0
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        session.invalidateAndCancel()
    }
} 