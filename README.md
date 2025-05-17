# Glimpse Calendar

Glimpse Calendar is a modern iOS calendar application designed to provide a fresh perspective on your schedule. With its unique carousel-based interface, Glimpse allows you to visualize your day at a glance while maintaining focus on what matters most.

![Glimpse Calendar Logo](https://via.placeholder.com/150?text=Glimpse)

## 👁️‍🗨️ Overview

Glimpse Calendar is built with SwiftUI and leverages the latest iOS features to create an intuitive, visually appealing calendar experience. The app represents a departure from traditional grid-based calendars, instead focusing on a dynamic, interactive view of your schedule.

Key architectural components:
- **SwiftUI**: Modern declarative UI framework
- **SwiftData**: Persistent storage for calendar events
- **EventKit**: Integration with iOS system calendars

## ✨ Features

- **Unique Carousel Interface**: Navigate through days with an intuitive carousel that brings the selected day into focus
- **Active/Inactive States**: Calendar rows dynamically expand when selected, providing detailed information about your schedule
- **Event Management**: Create, edit, and delete events directly within the app
- **Apple Calendar Integration**: Sync with your existing Apple Calendar events
- **Modern Design**: Clean, minimalist aesthetic with attention to visual hierarchy and usability

## 🔧 Requirements

- iOS 18.0+
- iPadOS 18.0+
- Xcode 16.0+
- Swift 5.0+

## 📱 Screenshots

<table>
  <tr>
    <td><img src="https://via.placeholder.com/250x500?text=Main+View" alt="Main Calendar View"/></td>
    <td><img src="https://via.placeholder.com/250x500?text=Event+Details" alt="Event Details"/></td>
    <td><img src="https://via.placeholder.com/250x500?text=Add+Event" alt="Add Event Screen"/></td>
  </tr>
</table>

## 🚀 Installation

1. Clone this repository
```bash
git clone https://github.com/yourusername/GlimpseCalendar.git
```

2. Open the project in Xcode
```bash
cd GlimpseCalendar
open GlimpseCalendar/GlimpseCalendar.xcodeproj
```

3. Build and run the application on your device or simulator

## 💡 What Makes Glimpse Unique

Glimpse Calendar reimagines how users interact with their schedule through several innovative approaches:

1. **Focus-Based UI**: Unlike traditional calendar apps that show an entire month at once, Glimpse uses a carousel system that emphasizes the current day while keeping context of surrounding days.

2. **Interactive Expansion**: Calendar rows transform when selected, expanding to show detailed event information without requiring navigation to a separate screen.

3. **Efficient Information Architecture**: The app employs visual hierarchy to distinguish between active and inactive days, allowing users to quickly process their schedule.

4. **Performance Optimizations**: Intelligent caching of calendar data and efficient rendering techniques ensure smooth animations and transitions even with complex schedules.

5. **Thoughtful UX Details**: Small touches like animated transitions, intuitive gestures, and contextual visual cues create a delightful user experience.

## 🧠 Technical Highlights

- **Calendar Factory**: A sophisticated system for generating and managing calendar data structures
- **Carousel Implementation**: Custom carousel views with physics-based animations
- **Efficient EventKit Integration**: Smart caching system for system calendar events
- **SwiftData Implementation**: Clean modeling of event data with modern persistence

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE.md) file for details.

## 🙏 Acknowledgements

- [Swift Collections](https://github.com/apple/swift-collections) for efficient data structures
- Apple's SwiftUI and SwiftData frameworks
