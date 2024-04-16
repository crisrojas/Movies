### About


> Everything should be made as simple as possible, not more —Some german scientific (not sure about that)

MVVM, VIPER, Clean Architecture, dependency injection...all of those paths eventually led to burnout...

They claim to provide benefits for big projects, yet advocates never define what a "big project" is, and as a result every project ends adopting such ~anti~patterns.

This project is a playground for experimentation, is my first step on walking towards defining simpler development patterns, my take on a "Simplicity Driven Development" philosophy...

### Patterns/Decisions (heavily influenced/learned by reading Jim Lai articles)
 
- Encapsulation over DI
- Simplicity and small codebase over testability
- Levarage Native SDK over fighting it
- Manual implementation over third-party libs when it makes sense (looking at you Alamofire...)
- Tailored code to the app needs instead of unneeded boilerplate

### Todo/WIP

- Persistence:
    - rating list
    - search/filter on saved lists
    - filter by category
    - pin
- Empty states
- search filter
- Tips
- Genres on carousell
