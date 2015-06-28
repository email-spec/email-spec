Rails3Root::Application.routes.draw do
  root :to => "welcome#index"
  get "/confirm" => "welcome#confirm", :as => :confirm_account
  get "/newsletter" => "welcome#newsletter", :as => :request_newsletter
  get "/attachments" => "welcome#attachments", :as => :request_attachments
  post "/welcome/signup" => "welcome#signup"
end
