module PageHelper
  def page_title(id)
    page = Page.find_by(id:id)&.title
    page.present? ? page : "JobList"
  end
end
