$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
code = File.read("Readme.md")[/<!-- example colors -->\n```Ruby(.*?)```\n<!-- example -->/m, 1]
eval code
