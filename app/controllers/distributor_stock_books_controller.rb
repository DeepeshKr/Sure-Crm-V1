class DistributorStockBooksController < ApplicationController
  before_action :set_distributor_stock_book, only: [:show, :edit, :update, :destroy]

  # GET /distributor_stock_books
  # GET /distributor_stock_books.json
  def index
    @distributor_stock_books = DistributorStockBook.all
  end

  # GET /distributor_stock_books/1
  # GET /distributor_stock_books/1.json
  def show
  end

  # GET /distributor_stock_books/new
  def new
    @distributor_stock_book = DistributorStockBook.new
  end

  # GET /distributor_stock_books/1/edit
  def edit
  end

  # POST /distributor_stock_books
  # POST /distributor_stock_books.json
  def create
    @distributor_stock_book = DistributorStockBook.new(distributor_stock_book_params)

    respond_to do |format|
      if @distributor_stock_book.save
        format.html { redirect_to @distributor_stock_book, notice: 'Distributor stock book was successfully created.' }
        format.json { render :show, status: :created, location: @distributor_stock_book }
      else
        format.html { render :new }
        format.json { render json: @distributor_stock_book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /distributor_stock_books/1
  # PATCH/PUT /distributor_stock_books/1.json
  def update
    respond_to do |format|
      if @distributor_stock_book.update(distributor_stock_book_params)
        format.html { redirect_to @distributor_stock_book, notice: 'Distributor stock book was successfully updated.' }
        format.json { render :show, status: :ok, location: @distributor_stock_book }
      else
        format.html { render :edit }
        format.json { render json: @distributor_stock_book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /distributor_stock_books/1
  # DELETE /distributor_stock_books/1.json
  def destroy
    @distributor_stock_book.destroy
    respond_to do |format|
      format.html { redirect_to distributor_stock_books_url, notice: 'Distributor stock book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_distributor_stock_book
      @distributor_stock_book = DistributorStockBook.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def distributor_stock_book_params
      params.require(:distributor_stock_book).permit(:corporate_id, :product_master_id, :product_variant_id, :product_list_id, :prod, :opening_qty, :opening_value, :10,2, :sold_qty, :sold_value, :10,2, :return_qty, :return_value, :10,2, :closing_qty, :closing_value, :10,2, :book_date, :list_barcode)
    end
end
