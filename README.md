# Moneybox iOS Technical Challenge - Noam Efergan

## Summary

I've taken the brief at "face value", and have created the dummy app as requested in the criteria. The app is built for iOS 15+, using 100% UIKit, and has all of the features requested.

### Notable Points

- The app is built using the MVVM design pattern, with a Coordinator pattern for navigation.
- Every screen has a ViewModel, and every ViewModel has a unit test.
- In addition, every screen has a snapshot test, for each state that it might be in.
- There's a jazzy little Lottie animation, because ✨why not?✨

### Tooling

- The first thing i've done, is add SwiftFormat to the project. i find that tooling like this helps to keep the codebase clean and consistent.
- I've also added a GitHub to run SwiftFormat on every push to `master`, to ensure that the codebase stays clean. In a real project, this would run on every PR.
- I've added a GitHub action to run the unit tests on every push to `master`, to ensure that the codebase stays stable. In a real project, this would run on every PR.

### What I would do next

- Offline mode! I would add a local database to store the user's data, so that they can still see their account balance when they're offline. a new fetch would overwrite this, but it would be a nice touch.
- I would add a `UIRefreshControl` to the `AccountViewController`, so that the user can pull to refresh the data.
- I think accessibility is really important, and I would like to add some more accessibility features to the app.
- I would add some more animations to the app, to make it feel more alive.

### Summary

I've had a lot of fun building this app, and I hope you enjoy looking through the code. I'm looking forward to hearing your feedback, positive or negative. Thanks for the opportunity!
