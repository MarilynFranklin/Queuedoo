class QueuersController < ApplicationController

  before_filter :lookup_queuer, :authenticate_user!
  before_filter :lookup_line, except: [:show]
  before_filter :lookup_next_in_line, only: [:skip, :processed]

  def index
    guests = current_user.guests.scoped
    if @guest = guests.find_by_formatted_number(@queuer.format_number(params[:look_up]))
      if @guest.line
        redirect_to @line, alert: "That guest is already in line"
      else
        render 'lines/show'
      end
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
    if @queuer.process!
      if @next_up
        @next_up.text("It's your turn!")
        flash[:notice] = "Successfully Processed! #{@next_up.name} has been texted"
      else
        flash[:notice] = "Successfully Processed!"
      end
      redirect_to @line
    end
  end

  def skip
    @queuer.skip!
    @next_up.text("It's your turn!")
    redirect_to @line, notice: "#{@next_up.name} has been texted"
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

  def lookup_next_in_line
    @next_up = @queuer.next_in_line
  end

end
