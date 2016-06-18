class CmdCanonicalizer
  def canonicalize(cmd)
    set_initial_values()
    args = cmd.split()
    first_cmd = args.first
    args, command = process_command(args, "")
    opts, long_opts, remaining_args = process_arguments(args, [], [], [])
    if @commands_which_i_can_strip_slashes.include?(first_cmd)
      command = strip_final_slash(command)
    end
    return compose_command(command, opts, long_opts, remaining_args)
  end

private
  def set_initial_values()
    @end_processing_regex = /^--$/
    @is_opt_regex = /^-\w\w*$/
    @is_long_opt_regex = /^--[\w-]*$/
    @is_bundled_opt = /^-\w\w\w*$/
    @is_not_command = /^-.*$/
    @commands_which_i_can_strip_slashes = ['ls']
  end

  def process_command(args, command)
    if args.size > 0
      if not args[0].match(@is_not_command)
        arg = args.shift
        command += " " + arg
        args, command = process_command(args, command.strip)
      end
    end
    return args, command
  end

  def compose_command(command, opts, long_opts, remaining_args)
    commands = []
    commands.push(command)
    if opts.size > 0
      commands.push(opts.sort.join(" "))
    end
    if long_opts.size > 0
      commands.push(long_opts.sort.join(" "))
    end
    if remaining_args.size > 0
      commands.push(remaining_args.join(" "))
    end
    return commands.join(" ").strip
  end

  def process_arguments(args, opts, long_opts, remaining_args)
    if args.size > 0
      arg = args.shift
      if arg.match(@end_processing_regex)
        remaining_args.push(*args)
        return opts, long_opts, remaining_args
      elsif arg.match(@is_long_opt_regex)
        long_opts.push(arg)
        opts, long_opts, remaining_args = process_arguments(args, opts, long_opts, remaining_args)
      elsif arg.match(@is_opt_regex)
        lopts = process_option(arg)
        opts.push(*lopts)
        opts, long_opts, remaining_args = process_arguments(args, opts, long_opts, remaining_args)
      else
        remaining_args.push(arg)
        opts, long_opts, remaining_args = process_arguments(args, opts, long_opts, remaining_args)
      end
    end
    return opts, long_opts, remaining_args
  end

  def strip_final_slash(arg)
    return arg.chomp('/')
  end

  def process_option(opt)
    args = []
    if opt.match(@is_bundled_opt)
      args = opt.split(//)
      args.shift # discard the -
      args.map! { |i| "-" + i }
    else
      args.push(opt)
    end
    return args
  end

  def self.option?(arg)
    result = !!(arg.match(@is_option_regex))
    return result
  end

end
