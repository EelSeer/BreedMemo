**BreedMemo**

Memorization assistance app for dog lovers. The app is intended to be a game in which players are presented with images of dogs and try to guess as many as possible in a row from a set of options randomly fetched from a list of breeds. A counter keeps track of successful guesses and should play some kind of animation or graphic when a streak of appropriate size is reached.

**Installation**
There's no prebuilt distributable. Just fetch, build and run locally.

**Architecture**
The application makes use of a rough Clean Architecture pattern, which I used to demonstrate splitting responsibilities within clearly defined boundaries and to provide a simple guide to extending the app further. Layers are:

Data Layer: Fetching data from remotes and/or storing and retrieving it locally. Our data layer just contains a repository that fetches remote content presently.

Domain Layer: Stores business logic, acts as intermediary between presentation layer and data. In our case this 'GuessUseCase' model is responsible for generating puzzle models.

Presentation Layer: Traditionally holds View Models which can then be consumed by relevant UI components. In SwiftUI, the 'View' struct itself is both the View and ViewModel simultaneously. While there are arguments for having a distinct ViewModel entity, I think it's unnecessary for SwiftUI apps of this nature, since it can cause problems for views that want to make use of a variety of SwiftUI annotations and other constructs. Using a distinct ViewModel entity could be more applicable if your view stack is comprised of multiple frameworks that have to work in tandem.

The presentation layer also contains a simple component (PawBox).

A small dependency injection system is used that lazily loads objects as required.

**Outstanding Features/Issues**

- Add Tests for the GuessUseCase
- Naive error handling (we're not displaying useful messages or data to the user here)
- No animation/prize for guessing enough dogs correctly.
- No local storage of user's score, could use SwiftData (or even just userdefaults.)
- Loading new puzzles after a successful/failed
- No preloading or caching of dogs and dog images, or locally stored images for preview / testing / debugging
- Could use a real DI framework
- Add a splash screen and initial menu that makes use of NavigationStack to present content.
- Split each layer into a distinct module.
