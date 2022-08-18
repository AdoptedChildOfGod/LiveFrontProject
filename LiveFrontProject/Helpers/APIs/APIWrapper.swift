//
//  APIWrapper.swift
//
//  Created by Shannon Draeker on 10/22/20.
//

import Foundation

protocol APIWrapper: AnyObject {
    func apiRequest<T: Codable, A>(urlComponents: [String], queryItems: [(name: String, value: String)]?, method: HTTPMethod, jsonString: String?, errorCompletion: @escaping ResultCompletionWith<A>, successCompletion: @escaping (T) -> Void)
    func apiRequest<A>(urlComponents: [String], queryItems: [(name: String, value: String)]?, method: HTTPMethod, jsonString: String?, errorCompletion: @escaping ResultCompletionWith<A>, successCompletion: @escaping (Bool) -> Void)

    func uploadImage(_ imageData: Data, imageFieldName: String, urlComponents: [String], _ completion: @escaping ResultCompletionWith<User?>)

    func createUrlWithPathComponents(_ components: [String]) -> URL?
    func addQueryItems(to url: URL, _ items: [(name: String, value: String)]) -> URL?
    func createRequest(from url: URL, method: HTTPMethod, authToken: String?) -> URLRequest
    func addDataToBody(of request: URLRequest, jsonString: String) -> URLRequest?

    func sendAPI<T: Codable>(_ request: URLRequest, expectData: Bool, completion: @escaping ResultCompletionWith<T?>)

    func record<T: Codable>(_ error: CustomError, fromRequest request: URLRequest, with data: Data?, _ file: String, _ function: String, _ line: Int, completion: @escaping ResultCompletionWith<T>)
    func record<T: Codable>(_ error: Error, fromRequest request: URLRequest, with data: Data?, _ file: String, _ function: String, _ line: Int, completion: @escaping ResultCompletionWith<T>)
}

extension APIWrapper {
    // MARK: - Total API Wrapper

    /// A function to do almost everything in the whole process of making and sending an API request, to avoid so much duplicate code
    func apiRequest<T: Codable, A>(urlComponents: [String], queryItems: [(name: String, value: String)]? = nil, method: HTTPMethod = .get, jsonString: String? = nil, errorCompletion: @escaping ResultCompletionWith<A>, successCompletion: @escaping (T) -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return errorCompletion(.failure(.unknownError)) }

            // Make sure the user is connected to the internet before trying to make an API call
            guard Reachability().isReachable else { return completion(.failure(.noInternet)) }

            // Form the URL request with any path components and query items
            guard var finalURL = self.createUrlWithPathComponents(urlComponents) else { return errorCompletion(.failure(.invalidURL)) }
            if let queryItems = queryItems {
                guard let urlWithQueryItems = self.addQueryItems(to: finalURL, queryItems) else { return errorCompletion(.failure(.invalidURL)) }
                finalURL = urlWithQueryItems
            }

            // Create the URL request, always attempting to add the access token
            var request = self.createRequest(from: finalURL, method: method, authToken: UserDefaults.standard.string(forKey: .accessToken) ?? "")

            // Add the data to body of the URL request if applicable
            if let jsonString = jsonString {
                guard let requestWithData = self.addDataToBody(of: request, jsonString: jsonString) else { return errorCompletion(.failure(.badData)) }
                request = requestWithData
            }

            // Send the API request to the server
            self.sendAPI(request) { (result: Result<T, CustomError>) in
                switch result {
                case let .success(object):
                    return successCompletion(object)
                case let .failure(error):
                    return errorCompletion(.failure(error))
                }
            }
        }
    }

    /// A function to do almost everything in the whole process of making and sending an API request when there is no data returned from the API request, to avoid so much duplicate code
    func apiRequest<A>(urlComponents: [String], queryItems: [(name: String, value: String)]? = nil, method: HTTPMethod = .get, jsonString: String? = nil, errorCompletion: @escaping ResultCompletionWith<A>, successCompletion: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return errorCompletion(.failure(.unknownError)) }

            // Make sure the user is connected to the internet before trying to make an API call
            guard Reachability().isReachable else { return completion(.failure(.noInternet)) }

            // Form the URL request with any path components and query items
            guard var finalURL = self.createUrlWithPathComponents(urlComponents) else { return errorCompletion(.failure(.invalidURL)) }
            if let queryItems = queryItems {
                guard let urlWithQueryItems = self.addQueryItems(to: finalURL, queryItems) else { return errorCompletion(.failure(.invalidURL)) }
                finalURL = urlWithQueryItems
            }

            // Create the URL request, always attempting to add the access token
            var request = self.createRequest(from: finalURL, method: method, authToken: UserDefaults.standard.string(forKey: .accessToken) ?? "")

            // Add the data to body of the URL request if applicable
            if let jsonString = jsonString {
                guard let requestWithData = self.addDataToBody(of: request, jsonString: jsonString) else { return errorCompletion(.failure(.badData)) }
                request = requestWithData
            }

            // Send the API request to the server
            self.sendAPI(request, expectData: false) { (result: Result<Bool, CustomError>) in
                switch result {
                case let .success(success):
                    return successCompletion(success)
                case let .failure(error):
                    if case .noData = error { return successCompletion(true) }
                    return errorCompletion(.failure(error))
                }
            }
        }
    }

    /// A function specifically to upload image data as a file
    func uploadImage(_ imageData: Data, imageFieldName: String, urlComponents: [String], _ completion: @escaping ResultCompletionWith<User?>) {
        // Run everything on a background thread
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return completion(.failure(.unknownError)) }

            // Make sure the user is connected to the internet before trying to make an API call
            guard Reachability().isReachable else { return completion(.failure(.noInternet)) }

            // Form the URL request with any path components
            guard let finalURL = self.createUrlWithPathComponents(urlComponents) else { return completion(.failure(.invalidURL)) }

            // Create the URL request, including the access token
            guard let authToken = UserDefaults.standard.string(forKey: .accessToken) else { return completion(.failure(.expiredToken)) }
            var request = self.createRequest(from: finalURL, method: HTTPMethod.post, authToken: authToken)

            // The set up specific for uploading an image file
            let boundary = "Boundary-\(NSUUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            let body = NSMutableData()
            body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
            body.append(NSString(format: "Content-Disposition: form-data; name=\"\(imageFieldName)\"; filename=\"testfromios.jpg\"\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            body.append(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
            body.append(imageData)
            body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
            request.httpBody = body as Data

            // Send the API request to the server
            self.sendAPI(request) { (result: Result<APIDataModel<User, Empty>, CustomError>) in
                switch result {
                case let .success(userData):
                    return completion(.success(User(from: userData)))
                case let .failure(error):
                    return completion(.failure(error))
                }
            }
        }
    }

    // MARK: - Forming URL

    /// Take in a base URL and add an arbitrary number of path components to it
    func createUrlWithPathComponents(_ components: [String]) -> URL? {
        // Form the base URL
        guard var baseURL = URL(string: APIStrings.baseURL) else { return nil }

        // Add each component
        for component in components {
            baseURL = baseURL.appendingPathComponent(component)
        }

        // Return the result
        return baseURL
    }

    /// Take in a base URL and add an arbitrary number of query items to it
    func addQueryItems(to url: URL, _ items: [(name: String, value: String)]) -> URL? {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)

        // Add each item including any that were already there
        var queryItems: [URLQueryItem] = components?.queryItems ?? []
        for item in items {
            queryItems.append(URLQueryItem(name: item.name, value: item.value))
        }

        // Return the result
        components?.queryItems = queryItems
        return components?.url
    }

    /// Encode a dictionary of keys to any into data and attach it to the body of a url request
    func addDataToBody(of request: URLRequest, jsonString: String) -> URLRequest? {
        guard let jsonData = jsonString.data(using: .utf8) else { return nil }
        var requestWithData = request
        requestWithData.httpBody = jsonData
        return requestWithData
    }

    /// Take in a URL and an http method and use it to create a URL request
    func createRequest(from url: URL, method: HTTPMethod, authToken: String? = nil) -> URLRequest {
        // Form the URL request
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)

        // Specify the http method and allow JSON returns
        request.httpMethod = method.rawValue
        request.setValue(APIStrings.jsonType, forHTTPHeaderField: APIStrings.contentType)
        request.setValue(APIStrings.jsonType, forHTTPHeaderField: APIStrings.acceptHeader)

        // Add the authorization token if provided
        if let authToken = authToken {
            request.setValue("\(APIStrings.bearer) \(authToken)", forHTTPHeaderField: APIStrings.authorization)
        }

        // Return the result
        return request
    }

    // MARK: - API Call

    /// Send a URL request to the API, check for errors, check the status code, unwrap the data, and return the result
    func sendAPI<T: Codable>(_ request: URLRequest, expectData: Bool = true, completion: @escaping ResultCompletionWith<T>) {
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            // Handle any errors
            if let error = error {
                self?.record(error, fromRequest: request, with: data, completion: completion)
                return
            }
            
            // Create the decoder
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            

            // Get the status code of the response
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                CrashlyticsHelper.log("No status code received from request \(request)")
                self?.record(CustomError.serverError, fromRequest: request, with: data, completion: completion)
                return
            }

            // Check the status code
            guard statusCode < 300 else {
                // Report the status code
                CrashlyticsHelper.log("Status code \(statusCode) for request \(request)")
                if let data = data {
                    CrashlyticsHelper.log(data.asString?.capAt(400) ?? "Problem with data")
                } else { CrashlyticsHelper.log("No data") }

                // Try to parse any error messages received from the server
                if let data = data {
                    do {
                        let apiModel = try decoder.decode(APIModel<String?>.self, from: data)
                        guard let errorMessage = apiModel.errorInfo?.errorMessage else { return completion(.failure(.serverError)) }
                        self?.record(CustomError.serverMessage(errorMessage), fromRequest: request, with: data, completion: completion)
                    } catch {
                        // This shouldn't happen
                        self?.record(CustomError.serverError, fromRequest: request, with: data, completion: completion)
                    }
                }

                // This shouldn't happen
                self?.record(CustomError.serverError, fromRequest: request, with: data, completion: completion)
                return
            }

            // If the request isn't supposed to return any data, then simply return the success
            guard expectData else { return completion(.failure(.noData)) }

            // Otherwise, try to unwrap the data
            guard let data = data else {
                self?.record(CustomError.noData, fromRequest: request, with: data, completion: completion)
                return
            }
            do {
                let decodedObject = try decoder.decode(T.self, from: data)

                // Return the success
                return completion(.success(decodedObject))
            } catch {
                self?.record(error, fromRequest: request, with: data, completion: completion)
            }
        }.resume()
    }

    /// Print, log, and return an error
    func record<T: Codable>(_ error: CustomError, _ completion: @escaping ResultCompletionWith<T>, _ file: String = #fileID, _ function: String = #function, _ line: Int = #line) {
        CrashlyticsHelper.record(error, file, function, line)
        return completion(.failure(error))
    }

    /// Print, log, and return an error
    func record<T: Codable>(_ errorMessage: String, fromRequest request: URLRequest, with data: Data?, _ file: String = #fileID, _ function: String = #function, _ line: Int = #line, completion: @escaping ResultCompletionWith<T>) {
        CrashlyticsHelper.log("Error in request \(request.url?.absoluteString ?? "UNKNOWN REQUEST"). Error message is \(errorMessage). Data was \(data?.asString?.capAt(400) ?? "missing")", file, function, line)
        return completion(.failure(.serverMessage(errorMessage)))
    }

    /// Print, log, and return an error
    func record<T: Codable>(_ error: CustomError, fromRequest request: URLRequest, with data: Data?, _ file: String = #fileID, _ function: String = #function, _ line: Int = #line, completion: @escaping ResultCompletionWith<T>) {
        CrashlyticsHelper.log("Error in request \(request.url?.absoluteString ?? "UNKNOWN REQUEST"). Data was \(data?.asString?.capAt(400) ?? "missing")", file, function, line)
        CrashlyticsHelper.record(error, file, function, line)
        return completion(.failure(error))
    }

    /// Print, log, and return an error
    func record<T: Codable>(_ error: Error, fromRequest request: URLRequest, with data: Data?, _ file: String = #fileID, _ function: String = #function, _ line: Int = #line, completion: @escaping ResultCompletionWith<T>) {
        CrashlyticsHelper.log("Error in request \(request.url?.absoluteString ?? "UNKNOWN REQUEST"). Data was \(data?.asString?.capAt(400) ?? "missing")", file, function, line)
        CrashlyticsHelper.record(error, file, function, line)
        return completion(.failure(.thrownError(error)))
    }
}
