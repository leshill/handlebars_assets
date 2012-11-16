## 0.7.0 (2012-11-16)

* Support `.hamlbars` extension and Haml

## 0.6.7 (2012-11-11)

* Support `.handlebars` extension - @BlakeWilliams

## 0.6.6 (2012-09-21)

* handlebars.js v1.0.rc.1
## 0.6.5 (2012-09-09)

* Generic options support, `HandlebarsAssets::Config.options = { data: true }` - @wyaeld

## 0.6.4 (2012-08-25)

* Fix bug with the `template\_namespace` config option - @kmayer

## 0.6.3 (2012-08-22)

* Added ability to change client-side template namespace from `HandlebarsTemplates` using `template\_namespace` config option - @spikebrehm
* Added `handlebars.js` compiler options
* Refactored tests; Config.reset! moved to tests

## 0.6.2 (2012-07-27)

* Added support for knownHelpers and knownHelperOnly compiler options
* Fixed problem with Config

## 0.6.1 (2012-07-23)

* #26 - Missing require

## 0.6.0 (yanked)

* #25 - Normalize partial names to begin with an underscore

## 0.5.0 (2012-07-10)

* #24 - Remove "templates/" from template names and expand partial paths into names - @cw-moshe
