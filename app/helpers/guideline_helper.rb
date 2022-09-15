module GuidelineHelper
  def privacy_policy_option_selected(params)
    params[:permalink]== "privacy_policy" ? "selected" : ""
  end

  def terms_and_condition_option_slected(params)
    params[:permalink] == "terms&condition" ? "selected" : ""
  end

  def faq_option_selected(params)
    params[:permalink] == "faq" ? "selected" : ""
  end

  def job_lists_option_selected(params)
    params[:action] == "job_lists"  ? "selected" : ""
  end
end
