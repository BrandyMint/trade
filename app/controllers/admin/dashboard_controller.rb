class Admin::DashboardController < Admin::ApplicationController
  def index
    render locals: {
      goods_at_week_count: Good.where('created_at >= ?', 7.days.ago).count,
      companies_at_week_count: Company.where('created_at >= ?', 7.days.ago).count,

      transactions: transactions }
  end

  private

  def transactions
    OpenbillTransaction.ordered.includes(:to_account, :from_account).page 1
  end
end
