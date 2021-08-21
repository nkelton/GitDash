# NOTE: This is just a temproary controller to get things working. Eventually, this request should be made to PATCH `profiles/id` instead and this controller should be deleted
class SubscriptionsController < ApplicationController

  def update
    binding.pry
    profile.update!(web_push_subscription: subscription_params)
  end

  private

  def profile
    @profile ||= current_user.profile
  end

  def subscription_params
    params.require(:subscription)
  end

end
