class PagesController < ApplicationController
    def home
    end

    def type_post
        survey_response = {
		"is_prepared" => request.POST['answer'].to_i == 1 ? true : false
	}

        # Save to session
        session[:survey_response] = survey_response.to_json

        # If not human consumable, redirect to results
        if survey_response["is_prepared"]
            redirect_to "/opened"
        else
            redirect_to "/distress"
        end
    end

    def opened
    end

    def opened_post
	survey_response = JSON.parse( session["survey_response"] )
        survey_response["is_opened"] = request.POST['answer'].to_i == 1 ? true : false

        # Save to session
        session[:survey_response] = survey_response.to_json

        # If not human consumable, redirect to results
        if survey_response["is_opened"]
            redirect_to "/results"
        else
            redirect_to "/danger-zone"
        end
    end

    def danger_zone
    end

    def danger_zone_post
	survey_response = JSON.parse( session["survey_response"] )
        survey_response["is_dangerous"] = request.POST['answer'].to_i == 1 ? true : false

        # Save to session
        session[:survey_response] = survey_response.to_json

        # If not human consumable, redirect to results
        if survey_response["is_dangerous"]
            redirect_to "/results"
        else
            redirect_to "/age"
        end
    end

    def age
    end

    def age_post
	survey_response = JSON.parse( session["survey_response"] )
        survey_response["is_too_old"] = request.POST['answer'].to_i == 1 ? true : false

        # Save to session
        session[:survey_response] = survey_response.to_json

        # If not human consumable, redirect to results
        if survey_response["is_too_old"]
            redirect_to "/results"
        else
            redirect_to "/distress"
        end
    end

    def distress
    end

    def distress_post
	survey_response = JSON.parse( session["survey_response"] )
        survey_response["is_distressed"] = request.POST['answer'].to_i == 1 ? true : false

        # Save to session
        session[:survey_response] = survey_response.to_json

        redirect_to "/results"
    end

    def results
      @results = Org.all
    end
end
