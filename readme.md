# hx++

Haxe utilities library for use android/ios applications using Haxe and OpenFL.

See individual `.hx` files for description and usage details.

### Components
* type extensions (array, map, string, set)
* debugging utilties (assert, macros, reflection, logging)
* react library (promise/future, signals/slots)
* network reachability library
* generic comparison library

### Installation
1. clone this repo into your OpenFL project's extensions directory
2. add `<include path="path/to/hxpp"/>` into `project.xml`

### TODO
* add MultiSet core data type
* add File utility methods
* Log.hx - add public callback to print()
* Log.hx - iOS needs to call NSLog or else logs won't appear in devices tab
* Log.hx - iOS log doesn't support ANSI colors
* Set.hx - use hash function
* Strings.hx - add FieldBuilder class to customize toString(), such as field predicate
* Strings.hx - add method to generate UUID
* make mutable subclasses to provide safe exposure of base class
* Future.hx - add Future.sequence()
