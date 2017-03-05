require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  test "если у пользователя нет компании, выводим его специальную страницу" do
    user = users(:without_company)
    login user
    good = goods :one
    get new_order_path(order: { good_id: good.id })
    assert_response :success
    assert_template 'orders/new_without_company'
  end

  test "Товар по предоплате. Компания есть, но денег нет" do
    user = users(:one)
    login user
    good = goods :one
    get new_order_path(order: { good_id: good.id })
    assert_response :success
    assert_template 'orders/new_no_money'
  end

  test "Товар по предоплате. Компания есть, деньги есть" do
    user = users(:two)
    login user
    good = goods :one
    get new_order_path(order: { good_id: good.id })
    assert_response :success
    assert_template 'orders/new'
  end

  test "Товар без предоплаты. Компания без денег" do
    user = users(:one)
    login user
    good = goods :without_price
    get new_order_path(order: { good_id: good.id })
    assert_response :success
    assert_template 'orders/new'
  end

  test "should create" do
    user = users(:one)
    login user
    good = goods :without_price
    assert_difference -> { Order.count } do
      post orders_path, params: { order: { good_id: good.id, company_id: companies(:one).id } }
    end
    assert_response :redirect
    follow_redirect!
  end

  test "заказ с блокировкой" do
    user = users(:two)
    login user
    good = goods :one
    assert_difference -> { Order.count } do
      post orders_path, params: { order: { good_id: good.id, company_id: companies(:two).id } }
    end
    assert_response :redirect
    follow_redirect!
  end
end
