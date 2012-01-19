module ApplicationHelper

  # Returns a title on a per-pages basis
  def title
    base_title = "Snoopy"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

end
