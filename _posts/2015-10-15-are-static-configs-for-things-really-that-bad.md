---
title: Are static configs for things really all that bad?
---

They say: "Don't build static configurations into software," well, in this case lets talk libraries or CLI's.  The kind you consume as a programmer.

Recently as I was working on open sourcing a CLI application that takes my concept of Docker repos and puts it into an app that anybody can consume. It soon came to me that I have some static stuff in there, stuff that one user, at one point... might want to change. Then the question came along: "how often do we even get requests for stuff like that?"

Lets take the following:

```ruby
class Repo

  # --
  # Initialize a new instance.
  # --
  def initialize(root)
    @root = root
  end

  # --
  # The config data.
  # --
  def data
    @data ||= begin
      file = File.join(@root, "opts.yml")
      File.file?(file) ? YAML.load_file(file, :safe => true) : {}
    end
  end

  # --
  # The build type.
  # --
  def build_type
    data.fetch("build_type",
      "simple"
    )
  end
end
```

A lot of that is static, stuff that can either be put into a constant so it can be configured by somebody who wants to quickly change stuff for their own style, or put into a configuration file.

Like so:

```ruby
class Repo
  DefaultBuildType = "simple"
  OptsFile = "opts.yml"

  # --
  # Initialize a new instance.
  # --
  def initialize(root)
    @root = root
  end

  # --
  # The data.
  # --
  def data
    @data ||= begin
      file = File.join(@root, OptsFile)
      File.file?(file) ? YAML.load_file(file, :safe => true) : {}
    end
  end

  # --
  # Get the build type.
  # --
  def build_type
    data.fetch("build_type",
      DefaultBuildType
    )
  end
end
```

How many people are going to step into the source and edit that? We could make it easy, however, then you need a configuration class for that... the configuration class loads the configuration file which will then check for those default values or set a default value, but is that really all that necessary?  Do people really want that much configuration, or is convention really the way software needs to go?

Those aren't really questions, they are just thoughts posed as questions since I already know what I'm going to do: I'm going to build a damn configuration class because I wouldn't want to be stuck without flexibility so I'm not going to stick you without it but at the same point I don't think some convention is bad.

This is especially true when you go look at Rails and there are 10,000 papercuts in the configuration alone.  Seriously, there is stuff that should take convention and stuff that needs configuration, should we bring up some past security problems that immediately made me think: That shit should have been configurable and off by default.  Some-bitches.
