# Bayut-Assignment

Developed a sample Classifieds iOS app in Swift using XCode.

## Description

This project is developed with Clean Layered Architecture and MVVM which is satisfying the SOLID principles.

## Layers
* **Domain Layer** = Entities + Use Cases + Repositories Interfaces
* **Data Repositories Layer** = Repositories Implementations + API (Network) + Persistence DB
* **Presentation Layer (MVVM)** = ViewModels + Views

## Shortcomings
* Following TDD approach, written test cases for ViewModels (couldnn't affoard much time to it), so code coverage will not be that good. :(
* Single UITest. Again because of time constraint
* No screen is developed using Objective C
