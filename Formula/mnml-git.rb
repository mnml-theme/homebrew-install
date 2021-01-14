class MnmlGit < Formula
  THEME = name.demodulize.titlecase.split.first.downcase.freeze
  INI = "#{THEME}.ini".freeze

  desc "Minimal theme for git"
  homepage "https://github.com/#{THEME}-theme/git"
  url "#{homepage}/trunk", using: :svn
  version "1.0.0"
  license "MIT"

  def install
    doc.install_metafiles
    prefix.install INI
  end

  def caveats
    <<~EOS
      To activate #{THEME}, run:
        git config --global include.path #{opt_prefix/INI}
        git config --global format.pretty #{THEME}

      or directly, with:
        git log --format=#{THEME}
    EOS
  end

  test do
    message = "Test"
    ini = opt_prefix/INI
    system <<~EOS
      git init
      git commit --allow-empty -m #{message}
      git config include.path #{ini}
    EOS
    config = shell_output "git config pretty.#{THEME}"
    assert_match config, ini.readlines.second

    log = shell_output "git log --format=#{THEME}"
    assert_match(/^\h{7} #{message}/, log)
  end
end
