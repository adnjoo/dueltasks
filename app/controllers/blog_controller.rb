# app/controllers/blog_controller.rb
class BlogController < ApplicationController
  require "redcarpet"

  def index
    markdown_files = Dir.glob("app/views/posts/*.md")

    @posts = markdown_files.map do |file|
      {
        title: File.basename(file, ".md").titleize,
        slug: File.basename(file, ".md")
      }
    end
  end


  def show
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, extensions = {})
    @post = markdown.render(File.read("app/views/posts/#{params[:slug]}.md"))
  rescue Errno::ENOENT
    redirect_to blog_path, alert: "Post not found."
  end
end
