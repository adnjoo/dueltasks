# app/helpers/notes_helper.rb
module NotesHelper
  def format_with_newlines(text)
    raw(text.gsub(/\n/, "<br>"))
  end
end
