class PagesController < ApplicationController
  before_filter :set_current_location
  before_filter :load_survey_response

  BURLINGTON = Zips.find_from_zip("05401")

  def home
  end

	def zip_lookup
		lat = params[:lat].to_f
		long = params[:long].to_f
		render json: Zips.find_from_lat_long(lat, long)
	end

  def type_post
    errors = []

    if params[:zip].present?
      found_zip = set_location_from_zip params[:zip]
      if !found_zip
        errors.push "We don't think that is a Vermont zip code. Please try again!"
      end
    else
      errors.push "Please provide a zip code. We need to know where you are!"
    end

    if not params[:food_description].present? or params[:food_description].empty?
      errors.push "Please provide a description of the food."
    end

    if errors.length != 0
      # todo: preserve entered values of zip and description    
      redirect_to "/", :notice => errors.join(" ")
      return
    end

    # Create the new survey response
    @survey_response = SurveyResponse.create do |s|
      s.zip_code = params[:zip]
      s.latitude = @current_location[:latitude]
      s.longitude = @current_location[:longitude]
      s.food_description = params[:food_description]
      s.prepared = params[:answer].to_i == 1 ? true : false
    end

    session[:survey_response_uuid] = @survey_response.uuid

    if @survey_response.prepared?
      redirect_to "/opened"
    else
      redirect_to "/distress"
    end
  end

  def opened
  end

  def opened_post
    @survey_response.opened = params[:answer].to_i == 1 ? true : false
    @survey_response.save

    # If its edible, send to next step
    if @survey_response.edible?
      redirect_to "/danger-zone"
    else
      redirect_to "/results"
    end
  end

  def danger_zone
  end

  def danger_zone_post
    @survey_response.dangerous_temperature = params[:answer].to_i == 1 ? true : false
    @survey_response.save

    # If its edible, send to next step
    if @survey_response.edible?
      redirect_to "/age"
    else
      redirect_to "/results"
    end
  end

  def age
  end

  def age_post
    @survey_response.old = params[:answer].to_i == 1 ? true : false
    @survey_response.save

    # If not human consumable, redirect to results
    if @survey_response.edible?
      redirect_to "/distress"
    else
      redirect_to "/results"
    end
  end

  def distress
  end

  def distress_post
    @survey_response.distressed = params[:answer].to_i == 1 ? true : false
    @survey_response.save

    redirect_to "/results"
  end

  def results
    @foodshelf = Org.from_file( "foodshelf", 3 ).sort_by {|org| org.distance_from( @current_location ) }
    @pig = Org.from_file( "pig", 3 ).sort_by {|org| org.distance_from( @current_location ) }
    @compost = Org.from_file( "compost", 3 ).sort_by {|org| org.distance_from( @current_location ) }
  end

  private

    def set_current_location
      @current_location ||= session[:location] || BURLINGTON
    end

    def set_location_from_zip zip
      location_hash = Zips.find_from_zip(zip)
      if location_hash
        @current_location = session[:location] = location_hash
      else
        false
      end
    end

    def load_survey_response
      uuid = session[:survey_response_uuid]
      @survey_response = SurveyResponse.find_by(uuid: session[:survey_response_uuid])
    end

end
