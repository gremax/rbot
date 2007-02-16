DEFAULT_FONTS = ['rectangles', 'smslant']
MAX_WIDTH=68

class FigletPlugin < Plugin
  def initialize
    super
    @figlet_path = "/usr/bin/figlet"

    # check that figlet actually has the font installed
    for fontname in DEFAULT_FONTS
      # check if figlet can render this font properly
      if system("#{@figlet_path} -f #{fontname} test test test")
        @figlet_font = fontname
        break
      end
    end
    
    # set the commandline params
    @figlet_params = ['-k', '-w', MAX_WIDTH.to_s]

    # add the font from DEFAULT_FONTS to the cmdline (if figlet has that font)
    @figlet_params += ['-f', @figlet_font] if @figlet_font

  end

  def help(plugin, topic="")
    "figlet <message> => print using figlet"
  end

  def figlet(m, params)
    message = params[:message].to_s
    if message =~ /^-/
      m.reply "the message can't start with a - sign"
      return
    end

    # collect the parameters to pass to safe_exec
    exec_params = [@figlet_path] + @figlet_params + [message]

    # run figlet
    m.reply Utils.safe_exec(*exec_params)
  end

end

plugin = FigletPlugin.new
plugin.map "figlet *message"
