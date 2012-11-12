class QueuersController < ApplicationController
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
end
