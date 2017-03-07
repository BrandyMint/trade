class TransactionMailer < ApplicationMailer
  def income(transaction, user)
    @transaction = transaction
    @money = humanized_money_with_symbol transaction.amount
    @company = transaction.to_account.company
    @details = transaction.details
    @url = user_transaction_url transaction
    @account_amount = humanized_money_with_symbol transaction.to_account.amount
    action_mail user
  end

  def outcome(transaction, user)
    @transaction = transaction
    @url = user_transaction_url @transaction
    @money = humanized_money_with_symbol transaction.amount
    @company = transaction.from_account.company
    @details = transaction.details
    @account_amount = humanized_money_with_symbol transaction.from_account.amount
    action_mail user
  end
end
