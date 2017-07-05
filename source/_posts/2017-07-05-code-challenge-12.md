---
url-id: 36d63082
id: b9c7aa06-fc98-49a1-8619-1092c4d75c18
title: "Challenge #12: July 5, 2017"
tags: [code-challenge]
---

[1]: https://discuss.codecademy.com/t/challenge-top-score-sorter/148011
[2]: https://repl.it/JOfH/latest
[3]: https://repl.it/JOfP/latest

[Discussion][1],
[Repl.it (Javascript)][2],
[Repl.it (Ruby)][3]

```ruby
max = 1000000
scores = [874300, 879200, 1172100, 1141800, 933900, 1177200, 1190200,
  1110100, 1158400, 985600, 1047200, 1049100, 1138600, 1170500, 1064500,
  1190000, 1050200, 1090400, 1062800, 1061700, 1218000, 1068000,
  1127700, 1144800, 1195100]

# --
# Defensive Version
# --
def scoreSettler1(scores, max)
  max, scores = max.to_i, [scores].flatten.compact
  raise "Max must be > 0" if max == 0

  scores.map(&:to_i).sort.reverse.delete_if do |v|
    v == 0 || v > max
  end
end

# --
# Non-Defensive Version
# --
def scoreSettler2(scores, max)
  scores.sort.reverse.delete_if do |v|
    v > max
  end
end
```

```javascript
max = 1000000
scores = [874300, 879200, 1172100, 1141800, 933900, 1177200, 1190200,
  1110100, 1158400, 985600, 1047200, 1049100, 1138600, 1170500, 1064500,
  1190000, 1050200, 1090400, 1062800, 1061700, 1218000, 1068000,
  1127700, 1144800, 1195100]

function numberSorter(a, b) {
  return b - a;
}

// --
// Flatten an Array, and compact it.
// Throws out null, undefined
// @return [Array]
// --
function compactAndFlattenArray(array, obj) {
  if (!obj) {
    obj = []
  }

  array.forEach((v) => {
    if (Array.isArray(v)) {
      compactAndFlattenArray(v, obj)
    }

    if (v) {
      obj.push(v)
    }
  })

  return obj
}

// --
// Defensive Version
// --
function scoreSettler1(scores, max) {
  max = Number(max)
  if (max == NaN) {
    throw "Max must be > 0, and a number"
  }

  return compactAndFlattenArray(scores.sort(numberSorter)).filter((v) => {
    return Number(v) != NaN && v < max
  })
}

// --
// Non-Defensive Version
// --
function scoreSettler2(scores, max) {
  return scores.sort(numberSorter).filter((v) => {
    return v < max
  })
}
```
