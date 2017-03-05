class Admin::LockingsController < Admin::ApplicationController
  def index
    @lockings = OpenbillLocking.order(:id)
    respond_with @lockings
  end
end
