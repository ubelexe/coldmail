class LettersController < ApplicationController
  before_action :set_letter, only: [ :show, :update, :edit, :destroy, :completed, :running, :sleeping ]
  before_action :new_letter, only: [ :new, :create ]
  before_action :aasm_transitions, only: [ :edit, :update, :completed, :sleeping, :running ]
  before_action :aasm_states, only: [:index]
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, with: :invalid_letter

  def index
    @letters = current_user.letters

    @monthly_letters = @letters.where(created_at: Time.now.beginning_of_month .. Time.now)
    @monthly_letters = @monthly_letters.group(:aasm_state).count


    @letters = @letters.search_by_fields(params[:q]) if params[:q].present?
    flash[:notice] = t(:letters_not_found) if @letters.empty?

    @letters = @letters.where(aasm_state: params[:aasm_state]) if params[:aasm_state].present?
    if params[:date].present? && Hash[(params[:date].permit(:start_date, :end_date))].all? { |k,v| v.present? }
#    if params[:date].present? && params[:date][:start_date].present? && params[:date][:end_date].present?
      @letters = @letters.where(created_at: (params[:date][:start_date]..params[:date][:end_date]))
    end
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @letter.save
      redirect_to letter_path(@letter)
    else
      render 'new'
    end
  end

  def update
    if @letter.update(letter_params)
      redirect_to letter_path(@letter)
    else
      render 'edit'
    end
  end

  def destroy
    if @letter.running?
      flash[:notice] = t(:can_not_del)
      redirect_to letter_path(@letter)
    else
      @letter.destroy
      redirect_to letters_path
    end
  end

  def completed
    @letter.done!
    redirect_to letter_path(@letter)
  end

  def running
    @letter.run!
    redirect_to letter_path(@letter)
  end

  def sleeping
    @letter.sleep!
    redirect_to letter_path(@letter)
  end

  def email
    @letter = Letter.all.find_by(email: params[:q])
  end

  private

  def letter_params
    params[:letter].present? ? params.require(:letter).permit(:url_site, :email, :comment, :aasm_state) : {}
  end

  def set_letter
    @letter = current_user.letters.find(params[:id])
  end

  def new_letter
    @letter = current_user.letters.build(letter_params)
  end

  def invalid_letter
    logger.error "Attempt to access invalid letter #{params[:id]}"
    redirect_to letters_path
  end

  def aasm_transitions
    @aasm_state = @letter.aasm.states(:permitted => true).map(&:name)
  end

  def aasm_states
    @aasm_all_states = Letter.new.aasm.states.map(&:name)
  end
end
