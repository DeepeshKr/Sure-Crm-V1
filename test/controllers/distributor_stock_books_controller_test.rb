require 'test_helper'

class DistributorStockBooksControllerTest < ActionController::TestCase
  setup do
    @distributor_stock_book = distributor_stock_books(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:distributor_stock_books)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create distributor_stock_book" do
    assert_difference('DistributorStockBook.count') do
      post :create, distributor_stock_book: { 10,2: @distributor_stock_book.10,2, 10,2: @distributor_stock_book.10,2, 10,2: @distributor_stock_book.10,2, 10,2: @distributor_stock_book.10,2, book_date: @distributor_stock_book.book_date, closing_qty: @distributor_stock_book.closing_qty, closing_value: @distributor_stock_book.closing_value, corporate_id: @distributor_stock_book.corporate_id, list_barcode: @distributor_stock_book.list_barcode, opening_qty: @distributor_stock_book.opening_qty, opening_value: @distributor_stock_book.opening_value, prod: @distributor_stock_book.prod, product_list_id: @distributor_stock_book.product_list_id, product_master_id: @distributor_stock_book.product_master_id, product_variant_id: @distributor_stock_book.product_variant_id, return_qty: @distributor_stock_book.return_qty, return_value: @distributor_stock_book.return_value, sold_qty: @distributor_stock_book.sold_qty, sold_value: @distributor_stock_book.sold_value }
    end

    assert_redirected_to distributor_stock_book_path(assigns(:distributor_stock_book))
  end

  test "should show distributor_stock_book" do
    get :show, id: @distributor_stock_book
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @distributor_stock_book
    assert_response :success
  end

  test "should update distributor_stock_book" do
    patch :update, id: @distributor_stock_book, distributor_stock_book: { 10,2: @distributor_stock_book.10,2, 10,2: @distributor_stock_book.10,2, 10,2: @distributor_stock_book.10,2, 10,2: @distributor_stock_book.10,2, book_date: @distributor_stock_book.book_date, closing_qty: @distributor_stock_book.closing_qty, closing_value: @distributor_stock_book.closing_value, corporate_id: @distributor_stock_book.corporate_id, list_barcode: @distributor_stock_book.list_barcode, opening_qty: @distributor_stock_book.opening_qty, opening_value: @distributor_stock_book.opening_value, prod: @distributor_stock_book.prod, product_list_id: @distributor_stock_book.product_list_id, product_master_id: @distributor_stock_book.product_master_id, product_variant_id: @distributor_stock_book.product_variant_id, return_qty: @distributor_stock_book.return_qty, return_value: @distributor_stock_book.return_value, sold_qty: @distributor_stock_book.sold_qty, sold_value: @distributor_stock_book.sold_value }
    assert_redirected_to distributor_stock_book_path(assigns(:distributor_stock_book))
  end

  test "should destroy distributor_stock_book" do
    assert_difference('DistributorStockBook.count', -1) do
      delete :destroy, id: @distributor_stock_book
    end

    assert_redirected_to distributor_stock_books_path
  end
end
