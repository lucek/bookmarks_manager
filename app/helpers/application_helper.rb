module ApplicationHelper
  def flash_class(level)
    case level.to_sym
      when :success then "alert alert-success"
      when :error then "alert alert-danger"
    end
  end
end
