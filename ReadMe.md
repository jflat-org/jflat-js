jflat-js
========

jFlat framework for JavaScript

## Synopsis

From JavaScript:
```
var {JFlat} = require('jflat');
var jflat = new JFlat;
console.log(jflat.dump(process.env));
```

From the command line:
```
echo '{"foo": [ "Hello", true, 42, null ], "bar bar": {}}' |
  json-to-jflat
```

## Installation
```
npm install jflat
```

## CLI Commands

These commands will be installed:

* `json-to-jflat`

  Read JSON from stdin and write jFlat to stdout.

* `yaml-to-jflat`

  Read YAML from stdin and write jFlat to stdout.
