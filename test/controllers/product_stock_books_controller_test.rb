require 'test_helper'

class ProductStockBooksControllerTest < ActionController::TestCase
  setup do
    @product_stock_book = product_stock_books(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_stock_books)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_stock_book" do
    assert_difference('ProductStockBook.count') do
      post :create, product_stock_book: { closing_qty: @product_stock_book.closing_qty, closing_rate: @product_stock_book.closing_rate, closing_value: @product_stock_book.closing_value, corrections_qty: @product_stock_book.corrections_qty, corrections_rate: @product_stock_book.corrections_rate, corrections_value: @product_stock_book.corrections_value, ext_prod_code: @product_stock_book.ext_prod_code, name: @product_stock_book.name, opening_qty: @product_stock_book.opening_qty, opening_rate: @product_stock_book.opening_rate, opening_value: @product_stock_book.opening_value, product_list_id: @product_stock_book.product_list_id, product_master_id: @product_stock_book.product_master_id, purchased_qty: @product_stock_book.purchased_qty, purchased_rate: @product_stock_book.purchased_rate, purchased_value: @product_stock_book.purchased_value, returned_others_qty: @product_stock_book.returned_others_qty, returned_others_rate: @product_stock_book.returned_others_rate, returned_others_value: @product_stock_book.returned_others_value, returned_retail_qty: @product_stock_book.returned_retail_qty, returned_retail_rate: @product_stock_book.returned_retail_rate, returned_retail_value: @product_stock_book.returned_retail_value, returned_wholesale_qty: @product_stock_book.returned_wholesale_qty, returned_wholesale_rate: @product_stock_book.returned_wholesale_rate, returned_wholesale_value: @product_stock_book.returned_wholesale_value, sold_branch_qty: @product_stock_book.sold_branch_qty, sold_branch_rate: @product_stock_book.sold_branch_rate, sold_branch_value: @product_stock_book.sold_branch_value, sold_retail_qty: @product_stock_book.sold_retail_qty, sold_retail_rate: @product_stock_book.sold_retail_rate, sold_retail_value: @product_stock_book.sold_retail_value, sold_wholesale: @product_stock_book.sold_wholesale, sold_wholesale_rate: @product_stock_book.sold_wholesale_rate, sold_wholesale_value: @product_stock_book.sold_wholesale_value, stock_date: @product_stock_book.stock_date }
    end

    assert_redirected_to product_stock_book_path(assigns(:product_stock_book))
  end

  test "should show product_stock_book" do
    get :show, id: @product_stock_book
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product_stock_book
    assert_response :success
  end

  test "should update product_stock_book" do
    patch :update, id: @product_stock_book, product_stock_book: { closing_qty: @product_stock_book.closing_qty, closing_rate: @product_stock_book.closing_rate, closing_value: @product_stock_book.closing_value, corrections_qty: @product_stock_book.corrections_qty, corrections_rate: @product_stock_book.corrections_rate, corrections_value: @product_stock_book.corrections_value, ext_prod_code: @product_stock_book.ext_prod_code, name: @product_stock_book.name, opening_qty: @product_stock_book.opening_qty, opening_rate: @product_stock_book.opening_rate, opening_value: @product_stock_book.opening_value, product_list_id: @product_stock_book.product_list_id, product_master_id: @product_stock_book.product_master_id, purchased_qty: @product_stock_book.purchased_qty, purchased_rate: @product_stock_book.purchased_rate, purchased_value: @product_stock_book.purchased_value, returned_others_qty: @product_stock_book.returned_others_qty, returned_others_rate: @product_stock_book.returned_others_rate, returned_others_value: @product_stock_book.returned_others_value, returned_retail_qty: @product_stock_book.returned_retail_qty, returned_retail_rate: @product_stock_book.returned_retail_rate, returned_retail_value: @product_stock_book.returned_retail_value, returned_wholesale_qty: @product_stock_book.returned_wholesale_qty, returned_wholesale_rate: @product_stock_book.returned_wholesale_rate, returned_wholesale_value: @product_stock_book.returned_wholesale_value, sold_branch_qty: @product_stock_book.sold_branch_qty, sold_branch_rate: @product_stock_book.sold_branch_rate, sold_branch_value: @product_stock_book.sold_branch_value, sold_retail_qty: @product_stock_book.sold_retail_qty, sold_retail_rate: @product_stock_book.sold_retail_rate, sold_retail_value: @product_stock_book.sold_retail_value, sold_wholesale: @product_stock_book.sold_wholesale, sold_wholesale_rate: @product_stock_book.sold_wholesale_rate, sold_wholesale_value: @product_stock_book.sold_wholesale_value, stock_date: @product_stock_book.stock_date }
    assert_redirected_to product_stock_book_path(assigns(:product_stock_book))
  end

  test "should destroy product_stock_book" do
    assert_difference('ProductStockBook.count', -1) do
      delete :destroy, id: @product_stock_book
    end

    assert_redirected_to product_stock_books_path
  end
end
