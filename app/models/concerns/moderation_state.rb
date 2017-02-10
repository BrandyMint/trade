module ModerationState
  extend ActiveSupport::Concern

  included do
    enumerize :state,
      in: %w(draft awaiting_review being_reviewed accepted rejected),
      predicates: true,
      scope: true,
      default: 'draft'

    scope :draft, -> { with_state :draft }
    scope :awaiting_review, -> { with_state :awaiting_review }
    scope :being_reviewed, -> { with_state :being_reviewed }
    scope :accepted, -> { with_state :accepted }
    scope :rejected, -> { with_state :rejected }

    validates :reject_message, presence: true, if: :rejected?
  end

  def done!
    update_attribute :state, 'awaiting_review'
  end
end
