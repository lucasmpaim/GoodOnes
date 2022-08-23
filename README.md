# Good Ones

Demo project to show how to work with Camera Roll and Google Photos


## Architecture

This project has build using a MVVM architecture to control the UI and businness logic are based on Clean Architecture.


The usage of the folders:

* Config -> Store project configuration files (aka GoogleService-Info)

* Scenes               | Store aplication non-reusable screen's
* Scenes/{Name}/Domain | Bussinnes Logic, like ViewModel, Repositories, UseCases etc.
* Scenes/{Name}/View   | The screen view

* Extensions           | Some Util Extensions
* Coordinators         | Application Routing Logic
* CoreRepository       | Repositories that can't be shared by modules
* CoreCoordinator      | Coordinator logic that can be shared by modules
* UI                   | Re-usable view's that can be shared by modules
* GridFeature          | Grid logic that can be re-usable by any content provider


## Improvements

- [ ] Better handling of DarkMode
- [ ] Better UX to display Vision Information
- [ ] Decouple Use Case's to make it testable
- [ ] Better abstraction btw Camera Roll and Google Photos to re-use the same ViewModel
- [ ] Unit Tests


* Another good reference of my work:
https://github.com/lucasmpaim/flickr-app
