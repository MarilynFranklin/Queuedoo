class QueuersController < ApplicationController

  before_filter :lookup_queuer, :authenticate_user!
  before_filter :lookup_line, except: [:show]

  def create
    @queuer.line = @line

    if @queuer.save
      redirect_to @line, notice: "You have added someone to the line"
    else
      flash[:error] = @queuer.errors.full_messages.join(". ")
      render 'lines/show'
    end
  end

  def processed
    @next_up = @queuer.next_in_line
    if @queuer.process!
      @next_up.text("It's your turn!")
      redirect_to @line, notice: "Processed. #{@next_up.name} has been texted"
    end
  end

  def skip
    @queuer.skip!
    redirect_to @line
  end

  def update
    if @queuer.update_attributes(params[:queuer])
      redirect_to [@line, @queuer], notice: "Profile has been updated"
    else
      flash[:error] = @queuer.errors.full_messages.join
      render :edit
    end
  end

  protected

  def lookup_queuer
    if params[:id]
      @queuer = Queuer.find(params[:id])
    else
      @queuer = Queuer.new(params[:queuer])
    end
  end

  def lookup_line
    @line = Line.find(params[:line_id])
  end
end
