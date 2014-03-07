class ApiKeysController < ApplicationController
  authorize_resource

  def index
    @api_keys = ApiKey.all
  end

  def create
    @api_key = ApiKey.create(api_key_params)
    flash[:notice] = "New Key Added"
    redirect_to api_keys_path
  end

  def destroy
    ApiKey.find(params[:id]).destroy
    flash[:notice] = "Key Deleted!"
    redirect_to api_keys_path
  end

  private
  def api_key_params
    params.require(:api_key).permit(:name)
  end
end
