class LettersController < ApplicationController
  before_action :set_letter, only: [ :show, :update, :edit, :destroy, :completed, :running, :sleeping ]
  before_action :new_letter, only: [ :new, :create ]
  before_action :aasm_transitions, only: [ :edit, :completed, :sleeping, :running ]

  rescue_from ActiveRecord::RecordNotFound, with: :invalid_letter

  def index
    if params[:q].present?
      @letters = Letter.where("email LIKE ?", "%#{params[:q]}%").or(Letter.where("url_site LIKE ?", "%#{params[:q]}%"))
      flash[:notice] = "Letters not found" if @letters.empty?
    else
      @letters = Letter.all
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
    @letter.destroy
    redirect_to letters_path
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

  private

  def letter_params
    params[:letter].present? ? params.require(:letter).permit(:url_site, :email, :comment, :aasm_state) : {}
  end

  def set_letter
    @letter = Letter.find(params[:id])
  end

  def new_letter
    @letter = Letter.new(letter_params)
  end

  def invalid_letter
    logger.error "Attempt to access invalid letter #{params[:id]}"
    redirect_to letters_path
  end

  def aasm_transitions
    @aasm_state = @letter.aasm.states(:permitted => true).map(&:name)
  end
end
