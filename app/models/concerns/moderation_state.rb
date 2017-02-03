module ModerationState
  extend ActiveSupport::Concern

  included do
    enumerize :state,
      in: %w(draft waits_review accepted rejected),
      predicates: true,
      scope: true,
      default: 'draft'

    scope :draft, -> { with_state :draft }
    scope :waits_review, -> { with_state :waits_review }
    scope :accepted, -> { with_state :accepted }
    scope :rejected, -> { with_state :rejected }

    validates :reject_message, presence: true, if: :rejected?
  end

  def done!
    update_attribute :state, 'waits_review'
  end
end
