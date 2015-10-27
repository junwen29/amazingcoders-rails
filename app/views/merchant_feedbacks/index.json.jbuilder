json.array!(@merchant_feedbacks) do |merchant_feedback|
  json.extract! merchant_feedback, :id
  json.url merchant_feedback_url(merchant_feedback, format: :json)
end
