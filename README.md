# ATX Health Inspection App

ATX Health Inspection is a mobile app designed to help users access restaurant health inspection grades and scores within the Austin, Texas area. Users can search for health inspection reports by restaurant name or browse nearby restaurants based on proximity/location search using an interactive map. This app connects to the City of Austin's public health data through the Socrata Open Data API, ensuring accurate, up-to-date information directly from the city’s open database.

## Features

- **Search by Restaurant Name**: Easily find health scores and inspection details by searching a restaurant's name.
- **Map-Based Browsing**: Explore nearby restaurants based on the map center location and view inspection details for each location.
- **Health Inspection Reports**: View detailed health inspection grades and scores for each restaurant, sourced from the City of Austin's open data platform.
- **Dark Mode**: Use the app in dark mode so it's easier on your eyes or just for a cool vibe.
- **Favorites**: Save frequently viewed restaurants for easy access. (WIP)

## Technology Stack

- **SwiftUI**: The entire UI is built using SwiftUI, leveraging its declarative syntax for efficient and modern UI development.
- **MVVM Architecture**: The app is structured with a Model-View-ViewModel (MVVM) architecture to promote separation of concerns and ensure maintainability.
- **Combine Framework**: Real-time data updates are powered by Apple's Combine framework, enabling reactive programming patterns.
- **MapKit**: The interactive map leverages MapKit to display restaurant locations.
- **Socrata Open Data API**: The City of Austin's public health data is accessed using Socrata's Open Data API, making it easy to keep health scores current and reliable.
- **Swift Concurrency**: Modern concurrency in Swift, including `async/await` and structured concurrency, is used to handle API calls and asynchronous tasks, improving app performance and responsiveness.
- **Unit Testing**: The app is tested with unit tests to ensure data integrity, maintain quality, and verify UI logic through MVVM.

## API Reference

The City of Austin's Open Data API (Socrata) is used to fetch restaurant health inspection reports. For more information, visit the [City of Austin's Socrata Open Data portal](https://data.austintexas.gov).

## Contributing

Contributions are welcome! If you have ideas to improve the app or find a bug, please create an issue or submit a pull request. Be sure to follow the project's coding guidelines and ensure that all new code is well-tested.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
