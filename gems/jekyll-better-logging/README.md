# Jekyll Better Logging

Jekyll Better logging solves a fundamental problem with Jekyll's logger.  It doesn't use a Mutex, and it's not thread safe.  This logger solves that problem by switching Jekyll's own logger to use the built in Logger, which does have a Mutex and is thread safe, so your logs never come out without a new line, and never come out, out of order.
