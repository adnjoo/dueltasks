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

  def meta_tags
    safe_join([
    # Twitter card meta tags
    tag.meta(name: "twitter:card", content: "summary_large_image"),
    tag.meta(name: "twitter:site", content: X_LINK),
    tag.meta(name: "twitter:title", content: APP_NAME),
    tag.meta(name: "twitter:description", content: APP_DESCRIPTION),
    tag.meta(name: "twitter:image", content: SCREENSHOT_LINK),

    # Open Graph meta tags
    tag.meta(property: "og:title", content: APP_TITLE),
    tag.meta(property: "og:type", content: "website"),
    tag.meta(property: "og:url", content: DOMAIN),
    tag.meta(property: "og:image", content: SCREENSHOT_LINK),
    tag.meta(property: "og:description", content: APP_DESCRIPTION),
    tag.meta(property: "og:site_name", content: APP_NAME)
    ])
  end
end
