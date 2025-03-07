# ATX Health Grades App

ATX Health Grades is a mobile app designed to help users access restaurant health inspection scores within the Austin, Texas area. Users can search for health inspection reports by restaurant name or browse nearby restaurants based on proximity/location search using the map. This app connects to the City of Austin's public health data through the Socrata Open Data API, ensuring accurate, up-to-date information directly from the city’s open database.

## Features

- **Search by Restaurant Name**: Easily find health scores by searching a restaurant's name.
- **Map-Based Browsing**: Explore nearby restaurants based on the map's center location by searching near the user location or move the map to get results for another region.
- **Health Inspection Reports**: View latest and charted historical health inspection scores for each restaurant, sourced from the City of Austin's open data platform. Charting historical data allows the user to gain insights on the improvement or decline of an establishment.
- **Dark Mode**: Use the app in dark mode so it's easier on your eyes or just for a cool vibe.
- **Favorites**: Save frequently viewed restaurants for easy access then tap a favorite to load it on the map.

## Technology Stack

- **SwiftUI**: The entire UI is built using SwiftUI, leveraging its declarative syntax for efficient and modern UI development.
- **MVVM Architecture**: The app is structured with a Model-View-ViewModel (MVVM) architecture to promote separation of concerns and ensure maintainability.
- **Combine Framework**: Real-time data updates are powered by Apple's Combine framework, enabling reactive programming patterns.
- **MapKit SwiftUI**: The interactive map leverages MapKit SwiftUI to display tappable restaurant annotations that allow the user to view more detailed information for a restaurant or toggle the favorite button.
- **Socrata Open Data API**: The City of Austin's public health data is accessed using Socrata's Open Data API, making it easy to keep health scores current and reliable.
- **Swift Concurrency**: Modern concurrency in Swift, including `async/await` and structured concurrency, is used to handle API calls and asynchronous tasks, improving app performance and responsiveness. Actors are used to ensure synchronous read and write operations to UserDefaults when persisting favorited items.
- **Unit Testing**: The app is tested with unit tests leveraging the XCTest framework to ensure data integrity, proper search string trimming, and accurate REST API request handling to maintain app quality and stability.

## Screen Caps

![radius](https://github.com/user-attachments/assets/77fd1409-3371-4c20-9add-2b93d071e028)  
![text](https://github.com/user-attachments/assets/9d6ed8d8-0d01-4a9d-9f3a-b974dde8152b)

## API Reference

The City of Austin's Open Data API (Socrata) is used to fetch restaurant health inspection reports. For more information, visit the [City of Austin's Socrata Open Data portal](https://data.austintexas.gov).

## Contributing

Contributions are welcome! If you have ideas to improve the app or find a bug, please create an issue or submit a pull request. Be sure to follow the project's coding guidelines and ensure that all new code is well-tested.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
