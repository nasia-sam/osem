class Booth < ActiveRecord::Base
  include ActiveRecord::Transitions

  belongs_to :conference
  has_many :booth_requests
  has_one :call_for_booths
  has_many :users, through: :booth_requests

  has_one :submitter_booth_user, -> { where(role: 'submitter') }, class_name: 'BoothRequest'
  has_one  :submitter, through: :submitter_booth_user, source: :user

  has_many :responsibles_booth_user, -> { where(role: 'responsibles') }, class_name: 'BoothRequest'
  has_many  :responsibles, through: :responsibles_booth_user, source: :user

  validates :title,
            uniqueness: { case_sensitive: false },
            presence: true

  validates :description,
            :reasoning,
            :state,
            :conference_id,
            presence: true


  state_machine initial: :submitted do
    state :submitted
    state :withdrawn
    state :to_accept
    state :accepted
    state :rejected

    event :restart do
      transitions to: :submitted, from: [:withdrawn]
    end
    event :withdrawn do
      transitions to: :withdrawn, from: [:submitted, :to_accept, :accepted]
    end
    event :to_accept do
      transitions to: :to_accept, from: [:submitted, :rejected, :accepted]
    end
    event :accept do
      transitions to: :accepted, from: [:submitted, :to_accept]
    end
    event :reject do
      transitions to: :rejected, from: [:submitted]
    end
    event :reset do
      transitions to: :submitted, from: [:to_accept, :rejected, :accepted]
    end
  end

  def transition_possible?(transition)
    self.class.state_machine.events_for(current_state).include?(transition)
  end

  def update_state(transition, notice)
    alert = ''
    begin
      send(transition)
      save
    rescue Transitions::InvalidTransition => e
      alert = "Update state failed. #{e.message}"
    end
    alert
  end

end