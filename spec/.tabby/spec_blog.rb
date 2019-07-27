class SpecBlog < Tabby::Base
  basedir "~/Dev/Blog"

  tab "jekyll" do
    exec "jekyll --auto --server"
  end

  tab "sass" do
    exec "sass --watch public/css/main.sass:public/css/main.css"
  end
end
