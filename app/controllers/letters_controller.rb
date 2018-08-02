class LettersController < ApplicationController
  before_action :user_letters, only: [:index, :statistic]
  before_action :all_letters, only: [:graph]
  before_action :set_letter, only: [:show, :update, :edit, :destroy, :completed, :running, :sleeping]
  before_action :new_letter, only: [:new, :create]
  before_action :aasm_transitions, only: [:edit, :update, :completed, :sleeping, :running]
  before_action :aasm_states, only: [:index, :statistic]
  before_action :half_year_statistic, only: [:statistic]
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, with: :invalid_letter

  def index
    @monthly_letters = @letters.where(created_at: Time.now.beginning_of_month .. Time.now)
    @monthly_letters = @monthly_letters.group(:aasm_state).count

    @letters = @letters.search_by_fields(params[:q]) if params[:q].present?
    flash[:notice] = t(:letters_not_found) if @letters.empty?

    @letters = @letters.where(aasm_state: params[:aasm_state]) if params[:aasm_state].present?

    if params[:date].try(:[], :start_date).present? && params[:date].try(:[], :end_date).present?
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

  def statistic
    @date_range = date_range(:yyyymm)
  end

  def graph
    months = date_range(:month_name)
    graph_data = aasm_states.map { |state| date_range(:yyyymm).map { |date| (half_year_statistic[date] || Hash.new(0))[state]} }
    datasets = aasm_states.map { |state| { label: state,
      data: graph_data[aasm_states.index(state)],
      backgroundColor: Letter::ASM_STATE_COLOR[state],
      stack: state,
      borderWidth: 2
    } }

    render json: { labels: months, datasets: datasets }
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

  def user_letters
    @letters = current_user.letters if current_user.present?
  end

  def all_letters
    @letters = Letter.all
  end

  def aasm_transitions
    @aasm_state = @letter.aasm.states(:permitted => true).map(&:name)
  end

  def aasm_states
    @aasm_states ||= Letter.new.aasm.states.map(&:name).map { |aasm_state| aasm_state.to_s }
  end

  def half_year_statistic
    return @half_year_letters if @half_year_letters.present?
    @letters = @letters.where('created_at > ?', 5.months.ago.beginning_of_month)
    sql = "TO_CHAR(created_at::timestamp, 'YYYY/MM')"
    @half_year_letters = @letters.group(sql, :aasm_state).count.inject({}) do |accum, hash|
      hash_date = hash[0][0]
      accum[hash_date] ||= Hash.new(0)
      accum[hash_date].merge!(hash[0][1] => hash[1])
      accum
    end
  end

  def date_range(format)
    @date_range = 5.downto(0).map { |num| l(Time.now.months_ago(num), format: format) }
  end
end
