---
author: envygeeks
title: 'Convert a file to base64'
date: 2020-08-13T00:00:00-05:00
tags:
  - macos
  - snippet
  - linux
---

```shell
base64 -i file.txt | pbcopy
```

```shell
openssl base64 < file.txt |
  tr -d '\n' |
  pbcopy
```

_On Linux you'll need to skip the `pbcopy`_
