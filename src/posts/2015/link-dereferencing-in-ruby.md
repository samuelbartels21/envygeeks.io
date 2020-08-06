---
author: envygeeks
title: Link Dereferencing in Ruby.
date: 2015-11-15T00:00:00-06:00
tags: [
  ruby
]
---

In my years of programming Ruby I never once (or cared... or thought) about link
dereferencing until now, and then when I needed it, it didn't exist.  Of course
you can dereference the root, that's easy, I don't need you to do that for me
Ruby.  I needed to dereference the links inside of the root.  Why can't you do
that for me instead, Ruby? Even with some of that safety? It can't... then I
came up with a solution that allows me to dereference safely.

<!-- MORE -->

```ruby
class String

  # --
  # Convert a string to a Pathname
  # @return [Pathname]
  # --
  def to_pathname
    Pathname.new(self)
  end
end

class Pathname

  # --
  # Check if a path resides within a root.
  # @param [String,Pathname] path
  # @return [true,false]
  # --
  def in_path?(path)
    path_str = path.expanded_realpath.to_s if path.is_a?(self.class)
    path_str = path.to_s unless defined?(path)
    expanded_realpath.to_s.start_with?(
      path_str
    )
  end
end

module Safe
  class Copy

    # --
    # Initialize a new instance.
    # --
    def initialize(from, to)
      @to, @from = [to, from].map(&:to_pathname)
    end

    # --
    # Copy a directory with sub-dereferences.
    # --
    def directory
      FileUtils.cp_r(@from.children, @to, :dereference_root => true)
      @from.all_children.select { |file| file.symlink? }.each do |path|
        rslvd, pth = path.realpath, @to.join(path.relative_path_from(@from))
        if rslvd.in_path?(Dir.pwd) && FileUtils.rm_r(pth)
          FileUtils.cp_r(rslvd, pth)

        else
          raise Errno::EPERM, "#{rslvd} not in #{Dir.pwd}"
        end
      end
    end

    # --
    # Copy a file with de-referencing.
    # --
    def file
      if @from.symlink?
        rslvd = @from.realpath
        return FileUtils.cp(rslvd, @to) if rslvd.in_path?(Dir.pwd)
        raise Errno::EPERM, "#{rslvd} not in #{Dir.pwd}"

      else
        FileUtils.cp(@from, @to)
      end
    end
  end
end
```
