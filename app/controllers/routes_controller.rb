require './app/helpers.rb'

class RoutesController < ApplicationController
  def create
    body = JSON.parse(request.raw_post)

    if (!api_validation body)
      return render json: { error: 'Incorrect format.' }
    end

    if (!csv_append body)
      return render json: { error: 'Something went wrong.' }
    end

    render json: { success: 'Route created.' }
  end

  def cheapest
    if (!params[:route])
      return render json: { error: 'Missing parameter.' }
    end

    validate = validate_user_input params[:route]
    if (!validate)
      return render json: { error: 'Incorrect data.' }
    end

    route = api_cheapest params[:route]
    if (!route)
      return render json: { error: 'Impossible to find route. Please, try again.' }
    end

    render json: { route: route }
  end
end
