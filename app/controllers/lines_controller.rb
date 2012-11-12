class LinesController < ApplicationController
  before_filter :lookup_line

  def index
    @lines = Line.all
  end

  def show
    @queuer = Queuer.new
  end

  def new
    @line = Line.new
  end

  def create
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
    redirect_to :root, notice: "Your line has been deleted"
  end

  protected

  def lookup_line
    if params[:id]
      @line= Line.find(params[:id])
    else
      @line = Line.new(params[:line])
    end
  end
end
