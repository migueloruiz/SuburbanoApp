# SuburbanoApp

This is an App for the Suburban train of the City of Meixco. Create this project as I was a user of this transport and I disliked its official app. 
[Original App](https://apps.apple.com/mx/app/mi-suburbano/id1073027758)

This is a small toy project that I use to test new ideas, architectures, patterns or technologies in an environment similar to production.

## App look and feel:


## Current Features:
* View the train map
* View the detail of each station
* Get information on how to get to each station
* Display the train card balance

## Tech description:
* Architecture: Clean Architecture for responsibility distribution and uses the Cordinator pattern to handle navigation
* Dependenci manager: Carthage
* Maps provider: Mapbox
* Database: Realm
* CrashReoports: FireBase Crashlitycs 
* Analitycs: FireBase Events
* Assets: Assets are separeted by color, images and files. Color and images uses an `.xcassets` file each one and there is a separate bundle for Resilienci files
* Targets: There are 2 targets, Development and Production

## Instalation:
1. Install [carthage](https://github.com/Carthage/Carthage#quick-start)
2. Install dependencies by runing: 

```
carthage update --platform iOS 
```

3. Tagets configurations. Add a the configuration files for Development and Production Envs, base in `Example.xcconfig`:

```
Development Path: suburbano/Configurations/Dev/Development.xcconfig
Production Path: suburbano/Configurations/Dev/Production.xcconfig
```

