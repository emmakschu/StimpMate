class StimpsController < ApplicationController

  # Index shows 10 most recent stimps with graph
  def index
    @stimps = Stimp.all.order(created_at: :desc).limit(10)
    `python /home/michael/pvSQLscripts/graph2017.py`
  end
  
  # Show displays the desired particular measurement
  def show
    @stimp = Stimp.find(params[:id])
  end
  
  # New allows creation of a new DB entry (#duh)
  def new
    @stimp = Stimp.new
  end
  
  # Create makes the new DB entry
  def create
    @stimp = Stimp.new(stimp_params)

    @stimp.weather = `cd /home/michael/weather && ./weather KC29`

    # Different rules whether entering three vals per direction or only one
    if @stimp.entries == 3

      # Begin rules for three entries per direction

      @total_forward = @stimp.forward1 + @stimp.forward2 + @stimp.forward3
      @total_backward = @stimp.backward1 + @stimp.backward2 + @stimp.backward3
      @total_left = @stimp.left1 + @stimp.left2 + @stimp.left3
      @total_right = @stimp.right1 + @stimp.right2 + @stimp.right3
      @total_distance = @total_forward + @total_backward + @total_left + @total_right
      @stimp.raw_speed = @total_distance / 144.0
    
      @stimp.adj_speed = ( @total_forward * @total_backward * (@total_left + @total_right) + @total_left * @total_right * (@total_forward + @total_backward) ) / ( 36.0 * (@total_forward + @total_backward) * (@total_left + @total_right) )
    
      raw_mean = @total_distance / 12.0
      @stimp.std_dev = ( (@stimp.forward1 - raw_mean)**2 + (@stimp.forward2 - raw_mean)**2 + (@stimp.forward3 - raw_mean)**2 + (@stimp.backward1 - raw_mean)**2 + (@stimp.backward2 - raw_mean)**2 + (@stimp.backward3 - raw_mean)**2 + (@stimp.left1 - raw_mean)**2 + (@stimp.left2 - raw_mean)**2 + (@stimp.left3 - raw_mean)**2 + (@stimp.right1 - raw_mean)**2 + (@stimp.right2 - raw_mean)**2 + (@stimp.right3 - raw_mean)**2 ) / 12.0
    

      # Check whether entry saved to DB or not
      if @stimp.save
	redirect_to @stimp
      else
        render 'new'
      end

    # Begin rules for entering only one value per direction
    else
      @total_distance = @stimp.forward1 + @stimp.backward1 + @stimp.left1 + @stimp.right1
      @stimp.raw_speed = @total_distance / 48.0
      @stimp.adj_speed = ( @stimp.forward1 * @stimp.backward1 * (@stimp.left1 + @stimp.right1) + @stimp.left1 * @stimp.right1 * (@stimp.forward1 + @stimp. backward1) ) / ( 12.0 * (@stimp.forward1 + @stimp.backward1 ) * (@stimp.left1 + @stimp.right1) )
      raw_mean = @total_distance / 4.0
      @stimp.std_dev = ( (@stimp.forward1 - raw_mean)**2 + (@stimp.backward1 - raw_mean)**2 + (@stimp.left1 - raw_mean)**2 + (@stimp.right1 - raw_mean)**2 ) / 12.0

      # Check whether saved successfully or not
      if @stimp.save
        redirect_to @stimp
      else
	render 'new'
      end

    end
  end
  
  #
  # Begin definitions for viewing by course and soil type
  # Each has a Model definition based on SQL where-statements
  # and calls a Python script to generate the appropriate graph
  # 
  def woodsNative
    @stimps = Stimp.woodsNative()
    `python /home/michael/pvSQLscripts/graphWoodsNative.py`
  end

  def woodsSand
    @stimps = Stimp.woodsSand()
    `python /home/michael/pvSQLscripts/graphWoodsSand.py`
  end

  def prairieNative
    @stimps = Stimp.prairieNative()
    `python /home/michael/pvSQLscripts/graphPrairieNative.py`
  end

  def prairieSand
    @stimps = Stimp.prairieSand()
    `python /home/michael/pvSQLscripts/graphPrairieSand.py`
  end

  def lakesNative
    @stimps = Stimp.lakesNative()
    `python /home/michael/pvSQLscripts/graphLakesNative.py`
  end

  def lakesSand
    @stimps = Stimp.lakesSand()
    `python /home/michael/pvSQLscripts/graphLakesSand.py`
  end


  # Go private and define stimp parameters
  private
    def stimp_params
      params.require(:stimp).permit(:course, :soilType, :green, :mower, :roller,
		:forward1, :forward2, :forward3, :backward1, :backward2, :backward3,
		:left1, :left2, :left3, :right1, :right2, :right3, :raw_speed, :verticut,
		:adj_speed, :std_dev, :notes, :weather, :created_at, :updated_at, :entries)
    end
end
