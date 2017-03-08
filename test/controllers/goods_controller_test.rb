require 'test_helper'

class GoodsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    login users(:one)
    get new_good_path
    assert_response :success
  end

  test "should create one" do
    login users(:one)
    assert_difference -> { Good.count } do
      post goods_path, params: { good: { title: '123', prepayment_required: false, category_id: categories(:one).id, company_id: companies(:one).id } }
    end
    assert_response :redirect
  end

  test 'should get index' do
    get goods_path
    assert_response :success
  end

  test 'should get good' do
    good = goods(:one)
    get good_path good
    assert_response :success
  end

  test 'should edit good' do
    login users(:one)
    get edit_good_path goods(:one)
    assert_response :success
  end

  test 'should update good' do
    login users(:one)
    patch good_path(goods(:one)), params: { good: { title: '123' } }
    assert_redirected_to good_path goods(:one)
  end

  test 'should destroy good' do
    login users(:one)
    delete good_path goods :one
    assert_redirected_to user_goods_path
  end
end
