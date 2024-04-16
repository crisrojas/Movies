### Design

- [Emre Seçer](https://dribbble.com/shots/7158704-Movie-App)

### About

> Everything should be made as simple as possible, but not simpler. —Attributed to Albert Einstein (not sure about that...)

MVVM, VIPER, VIP, Clean Architecture, dependency injection... all of these approaches eventually lead to burnout...

They claim to provide benefits for large projects, yet their advocates never define what a "large project" is, resulting in every project adopting such ~(anti-)~patterns.

This project is a playground for experimentation, marking my first step in moving away from industry madness and toward simpler, yet powerful, scalable, enjoyable, and maintainable (really, no marketing void promises) development patterns. This is my take on "Simplicity Driven Development" philosophy (which isn't really my take, but rather the SwiftUI one; you won't find much innovation here coming from me)...

### Patterns/Decisions (heavily influenced/learned by reading Jim Lai's articles)

- Encapsulation over Dependency Injection
- Prioritizing simplicity and a small codebase over testability
- Leveraging Native SDK rather than fighting against it
- Using URLSession instead of unnecessary third-party libraries (I'm looking at you, Alamofire/Moya...)
- Crafting tailored code to meet the app's needs instead of relying on unnecessary, cognitive taxing patterns & boilerplate

### Todo/WIP

- Persistence:
    - rating list
    - search/filter on locally saved lists
    - filter by category
    - pin
- Empty states components
- Search feature
- Tips
- Map Genres on backdrop cards component
- Add login
