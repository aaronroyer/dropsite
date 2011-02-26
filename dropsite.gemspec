Gem::Specification.new do |s|
  s.name = 'dropsite'
  s.version = '0.3.0'
  s.platform = Gem::Platform::RUBY

  s.description = "creates index pages in your Dropbox public directory"
  s.summary = "Dropsite creates a site of interlinked file index pages in " +
    "the Public directory of your Dropbox. The site created is minimally " +
    "invasive to your Public directory by only creating one top-level " +
    "HTML page and one folder, leaving your directories unjunked." +
    "\nBE WARNED: while I _think_ this probably works fine, it is " +
    "presently considered experimental."

  s.authors     = ["Aaron Royer"]
  s.email       = "aaronroyer@gmail.com"

  s.files           = Dir['{bin/*,lib/**/*,test/**/*}'] +
                          %w(README LICENSE dropsite.gemspec Rakefile)

  s.executables << 'dropsite'

  s.test_files = s.files.select {|path| path =~ /^test\/test_.*\.rb/}

  s.has_rdoc = true
  s.homepage = "https://rubygems.org/gems/dropsite"
  s.rdoc_options = ["--line-numbers", "--inline-source"]
  s.require_paths = %w[lib]
end
