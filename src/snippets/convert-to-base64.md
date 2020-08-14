---
author: envygeeks
title: 'Convert a file to base64'
date: 2020-08-13T00:00:00-05:00
tags:
  - macos
  - snippet
  - linux
---

Extracting a file as base64 is particularly useful when you want to put data
directly into a CSS file, or if you wish to send some data to somebody without
it potentially breaking their messenger.

```shell
base64 -i file.txt | pbcopy
```

```shell
openssl base64 < file.txt |
  tr -d '\n' |
  pbcopy
```

_On Linux you'll need to skip the `pbcopy`_
