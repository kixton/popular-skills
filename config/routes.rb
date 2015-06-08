Rails.application.routes.draw do
  root 'main#index'
  get 'jobs' => 'main#jobs', as: :jobs
  get 'summary' => 'main#summary', as: :summary
end
