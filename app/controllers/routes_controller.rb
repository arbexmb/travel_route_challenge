require './app/helpers.rb'

class RoutesController < ApplicationController
  def create
    body = JSON.parse(request.raw_post)

    if (!api_validation body)
      return render json: { error: 'Incorrect format.' }, status: 400
    end

    if (already_exists body['route'])
      return render json: { error: 'Travel route already exists.' }, status: 400
    end

    if (!csv_append body)
      return render json: { error: 'Something went wrong.' }, status: 400
    end

    render json: { success: 'Route created.' }, status: 201
  end

  def cheapest
    if (!params[:route])
      return render json: { error: 'Missing parameter.' }, status: 400
    end

    validate = validate_user_input params[:route]
    if (!validate)
      return render json: { error: 'Incorrect data.' }, status: 400
    end

    route = api_cheapest params[:route]
    if (!route)
      return render json: { error: 'Impossible to find route. Please, try again.' }, status: 400
    end

    render json: { route: route }, status: 200
  end
end
