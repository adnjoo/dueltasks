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
    slug = sanitize_slug(params[:slug])
    file_path = Rails.root.join("app", "views", "posts", "#{slug}.md")

    if File.exist?(file_path)
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, extensions = {})
      @post = markdown.render(File.read(file_path))
    else
      redirect_to blog_path, alert: "Post not found."
    end
  rescue Errno::ENOENT
    redirect_to blog_path, alert: "Post not found."
  end

  private

  def sanitize_slug(slug)
    # Only allow alphanumeric, hyphens, and underscores in slugs
    slug.gsub(/[^0-9a-z\-_]/i, "")
  end
end
