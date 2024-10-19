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
end
