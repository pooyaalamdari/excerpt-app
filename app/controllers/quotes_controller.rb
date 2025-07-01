class QuotesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show] # این خط رو اضافه کنید
  before_action :set_quote, only: %i[ show edit update destroy ]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  # GET /quotes or /quotes.json
 # GET /quotes or /quotes.json
  def index
    # مقداردهی اولیه Ransack search object
    @q = Quote.ransack(params[:q])

    # استفاده از اسکوپ keywords_cont برای اجرای جستجو
    # Ransack به صورت خودکار اسکوپ keywords_cont را فراخوانی می‌کند
    # اگر params[:q][:keywords_cont] وجود داشته باشد.
    @quotes = @q.result(distinct: true)

    # مرتب‌سازی نهایی بر اساس لایک و تاریخ ایجاد (همیشه اعمال می‌شود)
    @quotes = @quotes.order(likes_count: :desc, created_at: :desc)

    # منطق "گلچین‌های من" را نیز در اینجا اعمال می‌کنیم، بعد از اعمال جستجو
    if params[:my_quotes].present? && user_signed_in?
      @quotes = @quotes.where(user: current_user) # فیلتر بر اساس کاربر فعلی
    end
  end

  # GET /quotes/1 or /quotes/1.json
  def show
  end

  # GET /quotes/new
  def new
    @quote = Quote.new
  end

  # GET /quotes/1/edit
  def edit
  end

  # POST /quotes or /quotes.json
  def create
    @quote = current_user.quotes.new(quote_params)

    # اضافه کردن تگ‌های نویسنده و کتاب از فیلدهای مربوطه
    @quote.author_list.add(quote_params[:author]) # برای نویسنده
    @quote.book_title_list.add(quote_params[:book_title]) # برای عنوان کتاب

    respond_to do |format|
      if @quote.save
        format.html { redirect_to quote_url(@quote), notice: "گلچین با موفقیت ایجاد شد." } # تغییر اینجا
        format.json { render :show, status: :created, location: @quote }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quotes/1 or /quotes/1.json
  def update

    # مطمئن شوید که اینجا هم تگ‌ها به‌روزرسانی می‌شوند
    # اگر کاربر فیلد author یا book_title را تغییر دهد
    # ابتدا تگ‌های قبلی را پاک کرده و جدید را اضافه می‌کنیم

    @quote.author_list.clear
    @quote.book_title_list.clear
    @quote.author_list.add(quote_params[:author])
    @quote.book_title_list.add(quote_params[:book_title])


    respond_to do |format|
      if @quote.update(quote_params)
        format.html { redirect_to quote_url(@quote), notice: "گلچین با موفقیت بروزرسانی شد." } # تغییر اینجا
        format.json { render :show, status: :ok, location: @quote }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /quotes/1 or /quotes/1.json
  def destroy
    @quote.destroy! # حذف گلچین

    # تغییر مسیر دهی پس از حذف: به اکشن deleted_confirmation هدایت شود
    redirect_to quotes_deleted_confirmation_path, notice: "گلچین شما با موفقیت حذف شد."
  end

  # اکشن جدید برای نمایش صفحه تأیید حذف
  def deleted_confirmation
    # این اکشن فقط برای رندر کردن ویو استفاده می‌شود، نیازی به منطق پیچیده نیست.
  end

  private
    # ... (متدهای private: set_quote, quote_params, authorize_user!) ...



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quote
      @quote = Quote.find(params[:id]) # اینجا اصلاح شد: از params.expect(:id) به params[:id]
    end
   

    # Only allow a list of trusted parameters through.
    def quote_params
      params.expect(quote: [ :content, :author, :book_title, :tag_list ])
    end


    def authorize_user!
      unless @quote.user == current_user
        redirect_to quotes_path, alert: "شما اجازه انجام این عملیات را ندارید."
      end
    end

end
