if Jekyll.env == "development"
  require "pry"

  # --
  # This is done because on Alpine there is no support for
  # what Pry is trying to do with BusyBox `less`, so we need
  # to disable it's pager so that it works right.
  # --
  
  Pry.pager = false
end
