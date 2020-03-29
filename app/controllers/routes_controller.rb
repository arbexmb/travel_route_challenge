class RoutesController < ApplicationController
  def create
    JSON.parse(request.raw_post)
  end
end
