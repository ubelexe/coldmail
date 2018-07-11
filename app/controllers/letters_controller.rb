class LettersController < ApplicationController
  before_action :set_letter, only: [ :show, :update, :edit, :destroy ]
  before_action :new_letter, only: [ :new, :create ]

  rescue_from ActiveRecord::RecordNotFound, with: :invalid_letter

  def index
    @letters = Letter.all
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

  private

  def letter_params
    params[:letter].present? ? params.require(:letter).permit(:url_site, :email, :comment) : {}
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
end
