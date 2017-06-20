class CatsController < ApplicationController

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = selected_cat
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def edit
    @cat = selected_cat
    render :edit
  end

  def create
    @cat = Cat.new(cat_params)
    # fail
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def update
    @cat = selected_cat

    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  private
  def selected_cat
    Cat.find(params[:id])
  end

  def cat_params
    params.require(:cat).permit(:birth_date, :color, :name, :sex, :description)
  end
end
