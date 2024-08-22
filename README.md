

**LatiFlex** is designed to streamline the debugging process within your iOS applications. Whether you need to debug network requests, execute deeplinks, or analyze your analytic events, this tool offers a simple and efficient way to handle all these tasks directly from within your app.

## Features

- **Network Request Debugging**: Monitor and debug network requests in real-time. Get detailed insights into request headers, response bodies, and status codes.
- **Deeplink Execution**: Easily test your app's deeplinks. Just edit and add your deeplinks into the deeplinks.json file, and execute them directly from the debugger.
- **Analytics Event Debugging**: Track and debug your analytic events by adding their types and logging them into the debugger. Ensure that your analytics are firing correctly without leaving the app.
Installation
- **Create Your Own Debugging View**: You can create a new section for your internal debugging jobs. Like environment changing, copy token etc.


## Installation


### Swift Package Manager

To integrate LatiFlex into your Xcode project using Swift Package Manager, add it to the dependencies value of your  `Package.swift`:

    dependencies: [
        .package(url: "https://github.com/latifatcii/LatiFlex", from: "1.0.8")
    ]

## Usage

**Network Debugging**
Simply launch your app, and the In-App Debugging Tool will automatically start logging all network requests. Use the tool's interface to inspect requests and responses.

**Deeplink Execution**
Add your deeplinks to the deeplinks.json file.
Open the debugger and navigate to the Deeplink section.
Select and execute any deeplink to test its functionality.

**Analytics Event Debugging**
Define your analytics event types in the configuration.
Log the events using the tool's logging methods.
Open the debugger to inspect and verify the events.

## Contributing

We welcome contributions! If you find a bug or have a feature request, please open an issue. For larger changes, please fork the repository and submit a pull request.

License

This project is licensed under the MIT License - see the LICENSE file for details.

Contact

For any questions, feel free to reach out at latif.800@gmail.com
