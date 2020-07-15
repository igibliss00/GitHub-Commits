# GitHub-Commits

An iOS app in Swift to demonstrate the use case of using the local storage (Core Data) and remotely fetched data harmoniously.  The app fetches a list of git commits using GitHub's API and stores/loads in/from Core Data.

<img src="https://github.com/igibliss00/GitHub-Commits/blob/master/README_assets/1.png" width="400">

## Features

### Core Data

Some nifty tricks to remember. When manipulating elements in Data Model Inspector, you’ll sometimes find some elements missing or even all gone, especially when you have attributes selected within the Core Data editor..  When that happens, select any other files in Xcode and go back to the inspector panel.  

Another thing to remember is to make sure to manually save by cmd + S for any changes you’ve made within the Core Data editor.  Unlike the regular Swift files, the Core Data editor doesn’t save the changes automatically for you.

#### Indexed attribute

An indexed attribute is one that is optimized for fast searching. There is a cost to creating and maintaining each index, which means you need to choose carefully which attributes should be index. But when you find a particular fetch request is happening slowly, chances are it's because you need to index an attribute.

([Source](https://www.hackingwithswift.com/read/38/8/adding-core-data-entity-relationships-lightweight-vs-heavyweight-migration))
