# CmdCanonicalizer

Canonicalizer for shell commands

```
> require 'cmd_canonicalizer'
> canonicalizer = CmdCanonicalizer.new
> canonicalizer.canonicalize('git commit --no-edit --amend -f')
"git commit -f --amend --no-edit"
```

