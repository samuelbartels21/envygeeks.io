---
author: envygeeks
slug: code-challenge-12
date: Wed, 05 Jul 2017 00:00:00 -0500
title: "Challenge #12"
tags: [
  code-challenge
]
---

[1]: https://amazon.com
[2]: https://discuss.codecademy.com/t/challenge-top-score-sorter/148011
[3]: https://repl.it/JOfH/latest
[4]: https://repl.it/JOfP/latest

> This week's challenge was reported to have been asked in interviews at Amazon

I've never been asked this kind of question.  I've never interviewed at
[Amazon][1] though.  If that's the kind of question you are going to ask, let me
go ahead and give you an answer ahead of time. [Discussion][1], [Repl.it
(Javascript)][2], [Repl.it (Ruby)][3] -- ***Yes even as an experienced
programmer I still use CodeAcadamy for fun and practice. You should too, just
not the paid version.***

<!-- MORE -->

## Ruby

```ruby
max = 10000000; scores = [874300, 879200, 1172100, 1141800, 933900,
1170500, 1064500, 1190000, 1050200, 1090400, 1062800, 1061700, 1218000,
1177200, 1190200, 1110100, 1158400, 985600, 1047200, 1049100, 1138600,
1068000, 1127700, 1144800, 1195100]

def score_settler(array, max)
  return [] if array.size == 0

  gt = []
  pivot = array[0]
  lt = []

  # for i in 1..(array.size - 1)
  1.upto(array.size - 1).each do |i|
    next if array[i] > max
    gt.unshift(array[i]) and next if array[i] > pivot
    lt.unshift(array[i])
  end

  lt = score_settler(lt, max)
  gt = score_settler(gt, max)
  gt | lt.unshift(
    pivot
  )
end

score_settler(scores, max)
# => [1218000, 1195100, 1190200, 1190000, 1177200, 1172100, 1170500,
# 1158400, 1144800, 1141800, 1138600, 1127700, 1110100, 1090400, 1068000,
# 1064500, 1062800, 1061700, 1050200, 1049100, 1047200, 985600, 933900,
# 879200, 874300]
```

## JavaScript

```javascript
let max = 10000000, scores = [874300, 879200, 1172100, 1141800, 933900,
1177200, 1190200, 1110100, 1158400, 985600, 1047200, 1049100, 1138600,
1170500, 1064500, 1190000, 1050200, 1090400, 1062800, 1061700, 1218000,
1068000, 1127700, 1144800, 1195100]

function scoreSettler(array, max) {
  if (array.length === 0) return [];

  let gt = [];
  let pivot = array[0];
  let lt = [];
  let i;

  for (i = 1; i < array.length; i++) {
    if (array[i] < max) {
      if (array[i] > pivot) {
        gt.unshift(array[i]); continue;
      }

      lt.unshift(array[i]);
    }
  }

  lt = scoreSettler(lt, max);
  gt = scoreSettler(gt, max);
  return gt.concat(pivot,
    lt
  );
}

console.log(scoreSettler(scores, max))
```
