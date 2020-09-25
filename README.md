# Avatar-O-Matic

Generate random avatar images on the fly.

## How it works

The app works by stacking pieces of an avatar (such as background, mouth, eyes) to create a random avatar.

Each option defaults to a random value, but can also be explicitly set.

Inspiration - and most importantly all graphics - are taken from https://github.com/matveyco/8biticon.

## Installation

Add the following line to your Gemfile:

```ruby
gem 'avatar-o-matic'
```

And run `bundle install` from your shell.

## Getting started

Add the gem to the appropriate file and instantiate the generator.
```ruby
require 'avatar_o_matic'

generator = AvatarOMatic::Generator.new
```

### Avatar configuration

```ruby
generator.size = 96           # Defaults to 400
generator.type = :male        # Image should be of a man, defaults to random
generator.mouth = 10          # Use mouth image #10, defaults to a random value
generator.generate!           # Returns self, thus allowing chained calls
generator.save "avatar.png"
```

### Generator configuration

```ruby
AvatarOMatic::Config.image_lib = "/my/path"   # Defaults to library included in gem

# Peek around in available config:
AvatarOMatic::Generator.properties                  # Available image properties (eg mouth, eye, ...)
AvatarOMatic::Generator.types                       # Available image properties (male or female)
AvatarOMatic::Generator.options_for type, property  # Array of images for this property, of the given type
```

### Properties

All image properties are available as attributes on AvatorOMatic::Generator instances, and they all default to a random value.

  * background
  * face
  * clothes
  * head
  * eye
  * mouth

In addition these attributes are also supported:

 * type  - The image type (currently `:male` or `:female`). Good idea to set this before any other property!
 * size  - Custom size
 * image - The generated MiniMagick::Image object (nil before generate! has been invoked)

## Image Library

The `image_lib` accessor can be set before accessing options_for to supply a
custom image library. This library should have the following layout

```
  root/
  ├── female/
  │   ├── {head|mouth|...}1.png
  │   ├── {head|mouth|...}2.png
  │   └── ...
  └── male/
      ├── {head|mouth|...}1.png
      ├── {head|mouth|...}2.png
      └── ...
```
