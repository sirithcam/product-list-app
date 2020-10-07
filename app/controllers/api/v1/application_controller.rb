class Api::V1::ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  before_action :validate_content_type_header, only: [:create, :update]
  before_action :validate_json_data_type, only: [:create, :update]
  before_action :validate_accept_header

  protected

  def render_validation_error(model)
    render(
      json: model,
      status: :unprocessable_entity,
      serializer: ActiveModel::Serializer::ErrorSerializer,
    )
  end

  private

  def record_not_found
    render json: { message: 'Record Not Found!'}, status: 404
  end

  def validate_content_type_header
    return if request.content_type.include? 'application/vnd.api+json'

    render json: { message: 'Unsupported Media Type'}, status: 415
  end

  def validate_json_data_type
    return if params.dig('data', 'type') == params[:controller].split('/').last

    head :conflict
  end

  def validate_accept_header
    return unless request.accept.present?
    return if request.accept.include? 'application/vnd.api+json'

    render json: { message: 'Not Acceptable' }, status: 406
  end
end
