module DateHelper
  def formatted_date(date_string)
    return "No date available" if date_string.blank?

    Date.parse(date_string).strftime("%B %d, %Y")
  rescue ArgumentError
    "Invalid date"
  end
end
