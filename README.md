### Design

- [Emre Seçer](https://dribbble.com/shots/7158704-Movie-App)

### About

> Everything should be made as simple as possible, but not simpler. —Attributed to Albert Einstein (not sure about that...)

MVVM, VIPER, VIP, Clean Architecture, dependency injection... all of these approaches eventually lead to burnout...

They claim to provide benefits for large projects, yet their advocates never define what a "large project" is, resulting in every project adopting such (anti)patterns.

This project is a playground for experimentation, marking my first step in moving away from industry madness and walking toward simpler, yet powerful, scalable, enjoyable, and maintainable development patterns (really, no marketing void promises).

This is my take on "Simplicity Driven Development" philosophy (which isn't really my take, but rather the SwiftUI one...)

### Technical decisions/philosophy (heavily influenced by Jim Lai's articles)

- Encapsulation over Dependency Injection
- Prioritizing simplicity and a small codebase over testability
- Smart refactoring instead of "one VM/Presenter per view"...
- Leveraging Native SDK rather than fighting it
- Using URLSession instead of unnecessary third-party libraries (I'm looking at you, Alamofire/Moya)
- Tailored, handcrafted code over unnecessary, cognitive taxing boilerplate
- "I won't needed it and If I do I'll smartly rewrite/migrate" instead of abstracting your persistency solution away "just in case"

About that latest point, here's some advice:

- you need sync to a server?: Codable + FS
- you need local persistence only?: Codable + FS
- you need sync between devices?: CoreData/SwiftData + CloudKit

If you know before hand the answers to those questions (which you know 100% of the time regarding a project), you won't ever neeed to change your persistence solution...

Thats all. Happy coding 👋

### Todo/WIP

- Persistence:
    - rating list
    - search/filter on locally saved lists
    - filter by category
    - pin
- Error state component
- Empty states components
- Search feature
- Tips
- Map Genres on backdrop cards component
- Accessibility
- Writting tests
