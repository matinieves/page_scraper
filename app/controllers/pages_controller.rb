class PagesController < ApplicationController
  def index
    render :json => Page.all.to_json(include: [:page_elements])
  end

  def create
    if Page.find_or_create_from_url(page_params[:url])
      render json: { message: 'Page succesfully added' }
    end
  rescue => e
    render json: { message: e.message }
  end

  private

  def page_params
    params.permit(:url)
  end
end
