# Use handlebars.js templates with the asset pipeline and sprockets

Are your `handlebars.js` templates littering your Rails views with `script` tags? Wondering why the nifty Rails 3.1 asset pipeline streamlines all your JavaScript except for your Handlebars templates? Wouldn't it be nice to have your Handlebars templates compiled, compressed, and cached like your other JavaScript?

Yea, I think so too. That is why I wrote **handlebars_assets**. Give your Handlebars templates their own files (including partials) and have them compiled, compressed, and cached as part of the Rails 3.1 asset pipeline!

Using `sprockets` with Sinatra or another framework? **handlebars_assets** works outside of Rails too (as of v0.2.0)

# BREAKING CHANGE AS OF v0.9.0

My pull request to allow `/` in partials was pulled into Handlebars. The hack that converted partial names to underscored paths (`shared/_time` -> `_shared_time`) is no longer necessary and has been removed. You should change all the partial references in your app when upgrading from a version prior to v0.9.0.

## Version of handlebars.js

`handlebars_assets` is packaged with an 1.0.0-rc3 of `handlebars.js`. See the section on using another version if that does not work for you.

## Installation with Rails 3.1+

Load `handlebars_assets` in your `Gemfile` as part of the `assets` group

```ruby
group :assets do
  gem 'handlebars_assets'
end
```

## Installation without Rails 3.1+

`handlebars_assets` can work with earlier versions of Rails or other frameworks like Sinatra.

Load `handlebars_assets` in your `Gemfile`

```ruby
gem 'handlebars_assets'
```

Add the `HandlebarsAssets.path` to your `Sprockets::Environment` instance. This
lets Sprockets know where the Handlebars JavaScript files are and is required
for the next steps to work.

```ruby
env = Sprockets::Environment.new

require 'handlebars_assets'
env.append_path HandlebarsAssets.path
```

# Compiling your JavaScript templates in the Rails asset pipeline

Require `handlebars.runtime.js` in your JavaScript manifest (i.e. `application.js`)

```javascript
//= require handlebars.runtime
```

If you need to compile your JavaScript templates in the browser as well, you should instead require `handlebars.js` (which is significantly larger)

```javascript
//= require handlebars
```

## Precompiling

`handlebars_assets` also works when you are precompiling your assets.

### `rake assets:precompile`

If you are using `rake assets:precompile`, you have to re-run the `rake` command to rebuild any changed templates. See the [Rails guide](http://guides.rubyonrails.org/asset_pipeline.html#precompiling-assets) for more details.

### Heroku

If you are deploying to Heroku, be sure to read the [Rails guide](http://guides.rubyonrails.org/asset_pipeline.html#precompiling-assets) and in your `config/application.rb` set:

```ruby
config.assets.initialize_on_precompile = false
```

This avoids running your initializers when compiling assets (see the [guide](http://guides.rubyonrails.org/asset_pipeline.html#precompiling-assets) for why you would want that).

However, that does mean that you cannot set your configuration in an initializer. This [issue](https://github.com/leshill/handlebars_assets/issues/34) has a workaround, or you can set:

```ruby
config.assets.initialize_on_precompile = true
```

This will run all your initializers before precompiling assets.

## Templates directory

You should locate your templates with your other assets, for example `app/assets/javascripts/templates`. In your JavaScript manifest file, use `require_tree` to pull in the templates

```javascript
//= require_tree ./templates
```

## The template file

Write your Handlebars templates as standalone files in your templates directory. Organize the templates similarly to Rails views.

For example, if you have new, edit, and show templates for a Contact model

```
templates/
  contacts/
    new.hbs
    edit.hbs
    show.hbs
```

Your file extensions tell the asset pipeline how to process the file. Use `.hbs` to compile the template with Handlebars.

If your file is `templates/contacts/new.hbs`, the asset pipeline will generate JavaScript code

1. Compile the Handlebars template to JavaScript code
1. Add the template code to the `HandlebarsTemplates` global under the name `contacts/new`

You can then invoke the resulting template in your application's JavaScript

```javascript
HandlebarsTemplates['contacts/new'](context);
```

## The template namespace

By default, the global JavaScript object that holds the compiled templates is `HandlebarsTemplates`, but it can
be easily renamed. Another common template namespace is `JST`.  Just change the `template_namespace` configuration option
when you initialize your application.

```ruby
HandlebarsAssets::Config.template_namespace = 'JST'
```

## Ember

To compile your templates for use with [Ember.js](http://emberjs.com)
simply turn on the config option

```ruby
HandlebarsAssets::Config.ember = true
```

## `.hamlbars` and `.slimbars`

If you name your templates with the extension `.hamlbars`, you can use Haml syntax for your markup! Use `HandlebarsAssets::Config.haml_options` to pass custom options to the Haml rendering engine.

For example, if you have a file `widget.hamlbars` that looks like this:

```haml
%h1 {{title}}
%p {{body}}
```

The Haml will be pre-processed so that the Handlebars template is basically this:

```html
<h1> {{title}} </h1>
<p> {{body}} </p>
```

The same applies to `.slimbars` and the Slim gem. Use `HandlebarsAssets::Config.slim_options` to pass custom options to the Slim rendering engine.

## Partials

If you begin the name of the template with an underscore, it will be recognized as a partial. You can invoke partials inside a template using the Handlebars partial syntax:

```
Invoke a {{> path/to/_partial }}
```

## Using another version of `handlebars.js`

Occasionally you might need to use a version of `handlebars.js` other than the included version. You can set the `compiler_path` and `compiler` options to use a custom version of `handlebars.js`.

```ruby
HandlebarsAssets::Config.compiler = 'my_handlebars.js' # Change the name of the compiler file
HandlebarsAssets::Config.compiler_path = Rails.root.join('app/assets/javascripts') # Change the location of the compiler file
```

## Patching `handlebars.js`

If you need specific customizations to the `handlebars.js` compiler, you can use patch the compiler with your own JavaScript patches.

The patch file(s) are concatenated with the `handlebars.js` file before compiling. Take a look at the test for details.

```ruby
HandlebarsAssets::Config.patch_files = 'my_patch.js'
HandlebarsAssets::Config.patch_path = Rails.root.join('app/assets/javascripts') # Defaults to `Config.compiler_path`
```

# Thanks

This gem is standing on the shoulders of giants.

Thank you Yehuda Katz (@wycats) for [handlebars.js](https://github.com/wycats/handlebars.js) and lots of other code I use every day.

Thank you Charles Lowell (@cowboyd) for [therubyracer](https://github.com/cowboyd/therubyracer) and [handlebars.rb](https://github.com/cowboyd/handlebars.rb).

# Author

Hi, I'm Les Hill and I make things go.

Follow me on [Github](https://github.com/leshill) and [Twitter](https://twitter.com/leshill).


# Contributors

* Matt Burke         (@spraints)      : execjs support
*                    (@kendagriff)    : 1.8.7 compatibility
* Thorben Schröder   (@walski)        : 3.1 asset group for precompile
* Erwan Barrier      (@erwanb)        : Support for plain sprockets
* Brendan Loudermilk (@bloudermilk)   : HandlebarsAssets.path
* Dan Evans          (@danevans)      : Rails 2 support
* Ben Woosley        (@empact)        : Update to handlebars.js 1.0.0.beta.6
*                    (@cw-moshe)      : Remove 'templates/' from names
* Spike Brehm        (@spikebrehm)    : Config.template\_namespace option
* Ken Mayer          (@kmayer)        : Quick fix for template\_namespace option
* Brad Murray        (@wyaeld)        : Generic options support
* Blake Williams     (@BlakeWilliams) : .handlebars extension
* Tristan Koch       (@trkoch)        : Strip leading whitespace from compiled templates
* Brian Cardarella   (@bcardarella)   : Ember support
* David Lee          (@davidlee)      : Slim support
* Phil Cohen         (@phlipper)      : README cleanup
* Akshay Rawat       (@akshayrawat)   : Update to handlebars.js 1.0.0-rc.3

# Contributing

Pull requests are welcome! Please do not update the version number.

In a nutshell:

1. Fork
1. Create a topic branch - git checkout -b my_branch
1. Push to your branch - git push origin my_branch
1. Create a Pull Request from your branch
1. That's it!
