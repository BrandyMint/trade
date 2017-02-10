module CompanyModerationWorkflow
  extend ActiveSupport::Concern

  included do
    include Workflow

    workflow do
      state :draft do
        event :submit, :transitions_to => :awaiting_review
      end
      state :awaiting_review do
        event :review, :transitions_to => :being_reviewed
      end
      state :being_reviewed do
        event :accept, :transitions_to => :accepted
        event :reject, :transitions_to => :rejected
      end
      state :accepted do
        event :review, :transitions_to => :being_reviewed
      end
      state :rejected do
        event :review, :transitions_to => :being_reviewed
      end
    end

    # validates :reject_message, presence: true, if: :new_rejected?
  end

  def workflow_state_changed_at
    case workflow_state
    when 'accepted'
      accepted_at
    when 'rejected'
      rejected_at
    when 'being_reviewed'
      being_reviewed_at
    when 'awaiting_review'
      awaiting_review_at
    else
      updated_at
    end || updated_at
  end

  def state_text
    I18n.t workflow_state, scope: [:enumerize, :defaults, :state]
  end

  def submit(moderator)
    update_attributes!(
      awaiting_review_at: Time.zone.now,
      moderator: moderator
    )
  end

  def review(moderator)
    update_attributes!(
      being_reviewed_at: Time.zone.now,
      moderator: moderator
    )
  end

  def accept(moderator)
    update_attributes!(
      accepted_at: Time.zone.now,
      moderator: moderator
    )
  end

  def reject(moderator, reject_message)
    update_attributes!(
      rejected_at: Time.zone.now,
      moderator: moderator,
      reject_message: reject_message
    )
  end
end
