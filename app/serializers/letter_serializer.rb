class LetterSerializer < ActiveModel::Serializer
  attributes :id, :url_site, :email, :comment, :aasm_state, :created_at, :aasm_transitions
  belongs_to :user

  def aasm_transitions
    "#{ object.aasm.states(:permitted => true).map(&:name) }"
  end
end
