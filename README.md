# cmd_canonicalizer [![Build Status](https://travis-ci.org/amanya/cmd_canonicalizer.png?branch=master)](https://travis-ci.org/amanya/cmd_canonicalizer)

Ruby gem to canonicalize shell commands

```
> require 'cmd_canonicalizer'
> canonicalizer = CmdCanonicalizer.new
> canonicalizer.canonicalize('git commit --no-edit --amend -f')
"git commit -f --amend --no-edit"
```

