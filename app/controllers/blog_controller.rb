# app/controllers/blog_controller.rb
class BlogController < ApplicationController
  require "redcarpet"

  def index
    @posts = available_posts.map do |file_path|
      {
        title: File.basename(file_path, ".md").titleize,
        slug: File.basename(file_path, ".md")
      }
    end
  end

  def show
    slug = sanitize_slug(params[:slug])
    file_path = available_posts.find { |file| File.basename(file, ".md") == slug }

    if file_path.present?
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, extensions = {})
      @post = markdown.render(File.read(file_path))
    else
      redirect_to blog_path, alert: "Post not found."
    end
  end

  private

  # Sanitize the slug to allow only valid characters
  def sanitize_slug(slug)
    slug.gsub(/[^0-9a-z\-_]/i, "")
  end

  # List all available Markdown files
  def available_posts
    Dir.glob(Rails.root.join("app", "views", "posts", "*.md"))
  end
end
