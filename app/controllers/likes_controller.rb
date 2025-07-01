# app/controllers/likes_controller.rb

class LikesController < ApplicationController
  before_action :authenticate_user! # مطمئن می‌شویم که کاربر لاگین کرده باشد

 def create
    @quote = Quote.find(params[:quote_id]) # پیدا کردن گلچین
    @like = @quote.likes.build(user: current_user) # ایجاد لایک برای کاربر فعلی

    if @like.save
      redirect_to quotes_path, notice: "گلچین با موفقیت لایک شد." # تغییر اینجا: redirect_to quotes_path
    else
      redirect_to quotes_path, alert: "شما قبلاً این گلچین را لایک کرده‌اید." # تغییر اینجا: redirect_to quotes_path
    end
 end


  def destroy
    @quote = Quote.find(params[:quote_id]) # پیدا کردن گلچین
    @like = @quote.likes.find_by(user: current_user) # پیدا کردن لایک کاربر فعلی برای این گلچین

    if @like&.destroy # اگر لایک وجود داشت، آن را حذف کن
      redirect_to quotes_path, notice: "لایک شما با موفقیت حذف شد." # تغییر اینجا: redirect_to quotes_path
    else
      redirect_to quotes_path, alert: "لایک یافت نشد یا شما اجازه حذف آن را ندارید." # تغییر اینجا: redirect_to quotes_path
    end
  end

  
end
