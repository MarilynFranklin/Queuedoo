class QueuersController < ApplicationController

  def edit
    @queuer = Queuer.find(params[:id])
    @line = Line.find(params[:line_id])
  end

  def show
    @queuer = Queuer.find(params[:id])
  end

  def create
    @line = Line.find(params[:line_id])
    @queuer = Queuer.new(params[:queuer])
    @queuer.line = @line

    if @queuer.save
      redirect_to @line
      flash[:notice] = "You have added someone to the line"
    else
      flash[:error] = @queuer.errors.full_messages.join(". ")
      render 'lines/show'
    end
  end

  def processed
    @line = Line.find(params[:line_id])
    @queuer = Queuer.find(params[:id])
    @queuer.update_attributes(processed: true)
    redirect_to @line, notice: "Processed"
  end

  def update
    @queuer = Queuer.find(params[:id])
    @line = Line.find(params[:line_id])
    if @queuer.update_attributes(params[:queuer])
      redirect_to [@line, @queuer], notice: "Profile has been updated"
    else
      flash[:error] = @queuer.errors.full_messages.join
      render :edit
    end
  end
end
