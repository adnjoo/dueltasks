module ApplicationHelper
  def flash_class_for(key)
    case key
    when "notice"
      "bg-green-100 text-green-800 border-green-200"
    when "alert"
      "bg-red-100 text-red-800 border-red-200"
    when "error"
      "bg-yellow-100 text-yellow-800 border-yellow-200"
    else
      "bg-blue-100 text-blue-800 border-blue-200"
    end
  end

  def meta_tags(title: APP_TITLE, description: APP_DESCRIPTION, image: SCREENSHOT_LINK, url: DOMAIN, twitter_card: TWITTER_CARD)
    safe_join([
      tag.meta(name: "description", content: description),
      tag.meta(name: "twitter:title", content: title),
      tag.meta(name: "twitter:description", content: description),
      tag.meta(name: "twitter:image", content: twitter_card),
      tag.meta(name: "twitter:card", content: "summary_large_image"),
      tag.meta(name: "twitter:creator", content: X_AT),
      tag.meta(name: "twitter:site", content: X_AT),
      tag.meta(property: "og:title", content: title),
      tag.meta(property: "og:type", content: "website"),
      tag.meta(property: "og:url", content: url),
      tag.meta(property: "og:image", content: image),
      tag.meta(property: "og:description", content: description),
      tag.meta(property: "og:site_name", content: APP_NAME)
    ])
  end
end
