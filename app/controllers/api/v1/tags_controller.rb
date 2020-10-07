class Api::V1::TagsController < Api::V1::ApplicationController
  def index
    render json: Tag.includes(:products).all
  end

  def show
    render json: Tag.find(params[:id])
  end

  def create
    tag = Tags::Create.for(tag_params[:title])
    if tag.persisted?
      render json: tag, status: :created
    else
      render_validation_error(tag)
    end
  end

  def update
    tag = Tag.find(params[:id])
    if tag.update_attributes(tag_params)
      render json: tag
    else
      render_validation_error(tag)
    end
  end

  def destroy
    tag = Tag.find(params[:id])
    tag.destroy

    head :no_content
  end

  private

  def tag_params
    @tag_params ||= params.require(:data).require(:attributes).permit(:title)
  end
end
