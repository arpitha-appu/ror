require 'httparty'

class MyModelsController < ApplicationController
    protect_from_forgery except: [:create, :update]
  
    def create
      my_model = MyModel.new(my_model_params)
  
      if my_model.save
        notify_third_party_endpoints(my_model)
        render json: my_model, status: :created
      else
        render json: my_model.errors, status: :unprocessable_entity
      end
    end
  
    def update
      my_model = MyModel.find(params[:id])
  
      if my_model.update(my_model_params)
        notify_third_party_endpoints(my_model)
        render json: my_model, status: :ok
      else
        render json: my_model.errors, status: :unprocessable_entity
      end
    end
  
    private
  
    def my_model_params
      params.require(:my_model).permit(:name, :data)
    end
  
    def notify_third_party_endpoints(my_model)
      third_party_endpoints = Rails.application.config.third_party_endpoints
  
      third_party_endpoints.each do |endpoint|
        puts(endpoint[1][:url])
        # Send a webhook request to the third-party endpoint
        # Include authentication and verification logic here
        response = HTTParty.post(
            endpoint[1][:url],
            body: my_model.to_json,
            headers: {
              'Content-Type' => 'application/json',
              'Authorization' => "Bearer #{endpoint[1][:token]}"
            }
          )
          if response.code == 200
            # Handle successful notification
            puts("Done")
          else
            puts("Not successfull")
            # Handle notification failure
          end
      end
    end
end
  