module ApplicationHelper

  def feedback_url
    desc = "Please-add-your-feedback-here.\n\n\n\n\n---debugging-info---\n#{Base64.encode64 params.to_json}"
    "mailto:support@eyc3.com?" + { subject: "Email Signature", body: desc }.to_query
  end

end

