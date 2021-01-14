require "active_support/core_ext/string/inflections"

class MnmlPrompt < Formula
  THEME = name.demodulize.titlecase.split.first.downcase.freeze
  desc "Minimal Z shell prompt theme"
  homepage "https://github.com/#{THEME}-theme/prompt"
  url "#{homepage}/trunk", using: :svn
  version "1.0.0"
  license "MIT"

  uses_from_macos "zsh" => :test

  def install
    doc.install_metafiles

    zsh_prompt = "$0() {\n"
    zsh_prompt += File.read "#{THEME}.zsh"
    zsh_prompt << "}\n$0\n\n"

    zsh_prompt << "prompt_#{THEME}_preview() {\n"
    zsh_prompt += File.read "preview.zsh"
    zsh_prompt << "}\n\n"

    zsh_prompt << "prompt_#{THEME}_help() cat #{doc}/README.md"

    (zsh_function/"prompt_#{THEME}_setup").write zsh_prompt
  end

  def caveats
    <<~EOS
      To activate #{THEME}, add the following to your .zshrc:
        autoload -Uz promptinit
        promptinit
        prompt #{THEME}
    EOS
  end

  test do
    prompt = <<~EOS
      setopt prompt_subst
      autoload -U promptinit
      promptinit
      prompt -p #{THEME}
    EOS
                 ENV["ZSH_PROMPT_SYMBOL"] = "->"
    assert_match ENV["ZSH_PROMPT_SYMBOL"], shell_output("zsh -c '#{prompt}'")
  end
end
