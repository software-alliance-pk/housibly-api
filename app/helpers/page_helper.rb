module PageHelper
  def page_title(id)
    Page.find_by(id:id)&.title
  end
end
