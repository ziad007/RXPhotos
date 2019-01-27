# RxFlickrPhotosGridSample

This is a sample project that displays Flicker photos using collectionView in swift.

It was implemented with MVVM + interactor architecture.

In this project I wanted to show how to implement photos grid in swift based on RxSwift MVVM architecture.

Summary

The communication in this architecture is between 4 components:

* ViewController
* Interactor
* Service
* ViewModel

**Interactor**: This is the “mediator” between the 3 components (Service, ViewModel, ViewController). 
It gets the input from ViewController, it fetch data from the Service and update viewModel where there is an  observer in the viewcontroller that waits for any viewmodel update to refresh the UI.

the interactor and Viewcontroller have one to one relationship.


**Service**: This layer will handle all API/Core data calls. It is initiated by the interactor. It gets the data and return them back to interactor.

**ViewModel**: The ViewModel is data and state representation for the view. 








