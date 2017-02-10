class Admin::LockingsController < Admin::ApplicationController
  def index
    @lockings = OpenbillLocking.order(:id)
    respond_with @lockings
  end

  def accept
    locking = OpenbillLocking.find params[:id]
    locking.accept! current_user
    redirect_back_or_to admin_lockings_path, success: 'Средсва переданы продавцы'
  end

  def reject
    locking = OpenbillLocking.find params[:id]
    locking.reject! current_user
    redirect_back_or_to admin_lockings_path, success: 'Средсва возвращены покупателю'
  end
end
