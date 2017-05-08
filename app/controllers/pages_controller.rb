class PagesController < ApplicationController
  def index
    render :json => Page.all.to_json(include: [:page_elements])
  end

  def create
    url = page_params[:url]
    if Scraper.process_page(url)
      render json: { message: 'Page succesfuly added' }
    else
      render json: { message: "An error ocurred while scraping the page with url #{url}" }
    end
  end

  private

  def page_params
    params.permit(:url)
  end
end
