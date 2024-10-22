module BlogHelper
  require "redcarpet"
  require "front_matter_parser"

  def build_post_data(file, for_index: false)
    parsed = FrontMatterParser::Parser.parse_file(file)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)

    post_data = {
      title: parsed.front_matter["title"],
      slug: File.basename(file, ".md"),
      image: parsed.front_matter["image"],
      date: parsed.front_matter["date"]&.to_s
    }

    if for_index
      post_data[:summary] = parsed.front_matter["summary"] || parsed.content[0..200]
    else
      post_data[:content] = markdown.render(parsed.content)
    end

    post_data
  end
end
