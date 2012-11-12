class QueuersController < ApplicationController
  def create
    @line = Line.find(params[:line_id])
    @queuer = Queuer.new(params[:queuer])
    @queuer.line = @line
    @queuer.save
    redirect_to @line
    flash[:notice] = "You have added someone to the line"
  end
end
