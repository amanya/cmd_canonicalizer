require 'cmd_canonicalizer'

describe CmdCanonicalizer do
  it 'process simple commands' do
    canonicalizer = CmdCanonicalizer.new
    canonicalized_command = canonicalizer.canonicalize('whoami')
    expect(canonicalized_command).to eq 'whoami'
  end
  it 'removes extra whitespace' do
    canonicalizer = CmdCanonicalizer.new
    canonicalized_command = canonicalizer.canonicalize('ls  -l')
    expect(canonicalized_command).to eq 'ls -l'
  end
  it 'unbundles short options' do
    canonicalizer = CmdCanonicalizer.new
    canonicalized_command = canonicalizer.canonicalize('ls -lah')
    expect(canonicalized_command).to eq 'ls -a -h -l'
  end
  it 'process subcommands' do
    canonicalizer = CmdCanonicalizer.new
    canonicalized_command = canonicalizer.canonicalize('git commit --amend')
    expect(canonicalized_command).to eq 'git commit --amend'
  end
  it 'sort options' do
    canonicalizer = CmdCanonicalizer.new
    canonicalized_command = canonicalizer.canonicalize('ls -l -a -h')
    expect(canonicalized_command).to eq 'ls -a -h -l'
  end
  it 'sort long options' do
    canonicalizer = CmdCanonicalizer.new
    canonicalized_command = canonicalizer.canonicalize('git commit --no-edit --amend')
    expect(canonicalized_command).to eq 'git commit --amend --no-edit'
  end
  it 'put short options first' do
    canonicalizer = CmdCanonicalizer.new
    canonicalized_command = canonicalizer.canonicalize('git commit --no-edit --amend -f')
    expect(canonicalized_command).to eq 'git commit -f --amend --no-edit'
  end
  it 'removes slash at the end of directory for ls' do
    canonicalizer = CmdCanonicalizer.new
    command_with_slash = canonicalizer.canonicalize('ls mydir/')
    expect(command_with_slash).to eq 'ls mydir'
  end
   it 'removes slash at the end of directory for cd' do
    canonicalizer = CmdCanonicalizer.new
    command_with_slash = canonicalizer.canonicalize('cd mydir/')
    expect(command_with_slash).to eq 'cd mydir'
  end
  it 'does not removes slash at the end of directory for other commands' do
    canonicalizer = CmdCanonicalizer.new
    command_with_slash = canonicalizer.canonicalize('cp * mydir/')
    expect(command_with_slash).to eq 'cp * mydir/'
  end
end
