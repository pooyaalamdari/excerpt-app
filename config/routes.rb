# config/routes.rb

Rails.application.routes.draw do
  get "home/index"
  devise_for :users # این خط مربوط به Devise است و باید حفظ شود

  get 'quotes/deleted_confirmation', to: 'quotes#deleted_confirmation', as: 'quotes_deleted_confirmation'

  # مسیردهی برای گلچین‌ها (quotes) و لایک‌ها (likes) به صورت تو در تو
  resources :quotes do
  resources :likes, only: [:create, :destroy] # این خط مسیرهای POST برای لایک و DELETE برای آنلایک را ایجاد می‌کند
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # تنظیم صفحه اصلی برنامه
    root "home#index"

end
