class QueuersController < ApplicationController

  before_filter :lookup_queuer, :authenticate_user!
  before_filter :lookup_line, except: [:show]

  def index
    guests = current_user.guests.scoped
    if @guest = guests.find_by_formatted_number(@queuer.format_number(params[:look_up]))
      render 'lines/show'
    else
      redirect_to @line, alert: "Could not find a previous guest with that number"
    end
  end

  def create
    @queuer.line = @line
    @queuer.user = current_user
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
      @next_up.text("It's your turn!") if @next_up
      redirect_to @line, notice: "Processed. The next person in line has been texted"
    end
  end

  def skip
    @queuer.skip!
    redirect_to @line
  end

  def update
    if @queuer.update_attributes(params[:queuer])
      if params[:queuer][:line_id]
        @queuer.line = @line
        @queuer.processed = "false"
        @queuer.place_in_line = @line.next_spot
        @queuer.save!
        redirect_to @line, notice: "#{@queuer.name} has been added to the line"
      else
        redirect_to [@line, @queuer], notice: "Profile has been updated"
      end
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
