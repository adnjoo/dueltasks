# app/controllers/blog_controller.rb
class BlogController < ApplicationController
  require "redcarpet"
  require "front_matter_parser"

  def index
    markdown_files = available_posts

    @posts = markdown_files.map do |file|
      parsed = parse_markdown_file(file)

      {
        title: parsed.front_matter["title"],
        slug: File.basename(file, ".md"),
        summary: parsed.front_matter["summary"] || parsed.content[0..200],
        date: parsed.front_matter["date"]&.to_s
      }
    end
  end

  def show
    slug = sanitize_slug(params[:slug])
    file_path = available_posts.find { |file| File.basename(file, ".md") == slug }

    if file_path.present?
      parsed = parse_markdown_file(file_path)

      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
      @post = markdown.render(parsed.content)
    else
      redirect_to blog_path, alert: "Post not found."
    end
  end

  private

  def parse_markdown_file(file)
    FrontMatterParser::Parser.parse_file(file)
  end

  def sanitize_slug(slug)
    slug.gsub(/[^0-9a-z\-_]/i, "")
  end

  def available_posts
    Dir.glob(Rails.root.join("app", "views", "posts", "*.md"))
  end
end
