# app/controllers/blog_controller.rb
class BlogController < ApplicationController
  include BlogHelper

  def index
    markdown_files = available_posts

    @posts = markdown_files.map do |file|
      build_post_data(file, for_index: true)
    end
  end

  def show
    slug = sanitize_slug(params[:slug])
    file_path = available_posts.find { |file| File.basename(file, ".md") == slug }

    if file_path.present?
      @post = build_post_data(file_path)
    else
      redirect_to blog_path, alert: "Post not found."
    end
  end

  private

  def sanitize_slug(slug)
    slug.gsub(/[^0-9a-z\-_]/i, "")
  end

  def available_posts
    Dir.glob(Rails.root.join("app", "views", "posts", "*.md"))
  end
end
