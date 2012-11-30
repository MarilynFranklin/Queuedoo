class LinesController < ApplicationController
  before_filter :lookup_line, except: [:index]
  before_filter :authenticate_user!

  def index
    @lines = Line.where(:user_id => current_user)
  end

  def show
    @queuer = Queuer.new
  end

  def new
    @line = Line.new
  end

  def create
    @line.user = current_user
    if @line.save
      flash[:notice] = "Your line has been created"
      redirect_to @line
    else
      flash[:notice] = "Your line could not be saved. #{@line.errors.full_messages.join}"
      render 'new'
    end
  end

  def update
    if @line.update_attributes(params[:line])
      redirect_to @line
    else
      flash[:error] = @line.errors.full_messages.join
      render :edit
    end
  end

  def destroy
    @line.destroy
    redirect_to lines_path, notice: "Your line has been deleted"
  end

  def toggle_texting
    if @line.text_to_join
      @line.text_to_join = false
      @line.save!
    else
      @line.text_to_join = true
      @line.save!
    end
    redirect_to @line
  end

  protected

  def lookup_line
    if params[:id]
      @line = Line.find(params[:id])
    else
      @line = Line.new(params[:line])
    end
  end
end
