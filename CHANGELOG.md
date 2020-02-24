## 0.23.8 (2019-02-24)

* Update Handlebars to v4.7.3

## 0.23.7 (2019-11-20)

* Update Handlebars to v4.5.3

## 0.23.6 (2019-11-14)

* Update Handlebars to v4.5.2

## 0.23.5 (2019-09-25)

* Update Handlebars to v4.3.1

## 0.23.4 (2019-06-03)

* Update Handlebars to v4.1.2

## 0.23.3 (2019-02-20)

* Update Handlebars to v4.1.0

## 0.23.2 (2017-05-07)

* Remove requirement for MultiJSON

## 0.23.1 (2016-08-04)

* Fixes for Issue on Boot with Rails 3 and 4

## 0.23.0 (2016-01-26)

* Fixes for Railties and certain versions of Rails
* Only load if asset compilation is enabled
* Add support for Sprockets 3.x + 4.x - @tjgrathwell

## 0.22.0 (2015-11-23)

* Update Handlebars to v4.0.5

## 0.21.0 (2015-02-24)

* Update Handlebars to v4.0.2

## 0.20.2 (2015-02-24)

* Relax Sprockets Dependencies - @rounders
* Add option to CHOMP underscores on partials - @GreyKn

## 0.20.1 (2015-02-24)

* Actually revert to native HB.js

## 0.20 (2015-02-23)

* Fix issues with window object, revert to native HB.js
* Fix extension handling bug on some versions of rails

## 0.19 (2015-02-18)

* Upgrade to Handlebars v3.0
* Re-fix the issue regarding sprockets

## 0.18.1 (2015-02-18)

* Fix issue regarding sprockets versioning of assets

## 0.18 (2014-09-08)

* Update to handlebars v2.0.0 - @AlexRiedler

## 0.17.2 (2014-09-08)

* Support for Ruby v1.8 - @blainekasten

## 0.17.1 (2014-06-28)

* Fix engine initialization error on rails during assets precompile - @AlexRiedler

## 0.17 (2014-06-22)

* Massive revamp - @AlexRiedler
* Changed how sprockets is registered - @AlexRiedler
* AMD loading - @AlexRiedler, based on @pboling changes (THANKS!)
* Fix extension being too liberal issues - @langalex

## 0.16 (2014-05-27)

* README clarification - @jithugopal
* Upgrade `handlebars` to 1.3 - @neodude

## 0.15 (2013-12-06)

* Allow use of ember and other handlebars simultaneously - @rbhitchcock
* Fix multi-framework to allow hbs, hamlbars, and slimbars - @Darep
* Add `hamlbars` usage example - @mattmenefee
* README section for `multiple_frameworks` - @sorentwo
* README clarification - @panchoqv
* README cleanup - @dmarkow
* README cleanup additional - @AlexRiedler
* Upgrade `handlebars` to 1.1.2 - @sorentwo
* Fix MultiJson dependency - @AlexRiedler

## 0.14.1 (2013-06-21)

* Roll back "Register with Sprockets instead of `app.assets`" until we can get a definitive answer on what the problem really is.

## 0.14.0 (2013-06-19)

* Register with Sprockets instead of `app.assets` - @metaskills

## 0.13.0 (2013-06-02)

* Update to handlebars 1.0.0 - @lee

## 0.12.3 (2013-05-28)

* Pass scope and locals up the chain - @AlexRiedler
* Nicer rvmrc - @AlexRiedler
* Allow configure block - @AlexRiedler

## 0.12.2 (2013-05-27)

* Synchronize Sprockets engine registers with Rails - @mark-rushakoff

## 0.12.1 (2013-05-21)

* Update to handlebars 1.0.0-rc.4 - @turadg

## 0.12.0 (2013-02-17)

* Support for patching `handlebars.js`
* Make `test` the default Rake task
* Update dev env to use `haml` v4.0.0

## 0.11.0 (2013-02-15)

* Update to handlebars.js 1.0.0-rc.3 - @akshayrawat
* Add github markdown to README - @phlipper

## 0.10.0 (2013-01-29)

* Support `.slimbars` extension for Slim templates - @davidlee

## 0.9.0 (2013-01-25)

* Update to [this commit](https://github.com/wycats/handlebars.js/commit/a3376e24b1a25f72cf86d1d999bd2ea93fa4dc39) of `handlebars.js`
* The hack that converted partial names to underscored paths (`shared/_time` -> `_shared_time`) is no longer necessary and has been removed. You should change all the partial references in your app when going to v0.9.x.

## 0.8.2

* Update to [this commit](https://github.com/wycats/handlebars.js/commit/5e5f0dce9c352f490f1f1e58fd7d0f76dd006cac) of `handlebars.js`
* Fix to allow Ember.js template support when not using Rails

## 0.8.1

* Require haml directly

## 0.8.0

* Support Ember.js templates

## 0.7.2 (2012-12-25)

* Note use of `rake assets:precompile` in README
* Strip leading whitespace from compiled templates - @trkoch

## 0.7.1 (2012-12-4)

* Use edge version of `handlebars.js` ([this commit](https://github.com/wycats/handlebars.js/commit/bd0490145438e8f9df05abd2f4c25687bac81326)) to fix regression with context functions

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
