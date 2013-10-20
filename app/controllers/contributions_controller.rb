class ContributionsController < ApplicationController
  def new
    @contribution = Contribution.new
  end

  def create
    params.require(:contribution).permit!
    @contribution = Contribution.create( params[:contribution])
    if @contribution.save
      current_user.update_attributes(email: params[:email])
      update_percent_fulfilled(@contribution)
      redirect_to root_path
    else
      render 'new'
    end
  end

  def update_percent_fulfilled(contribution)
    wish = Wish.find_by(contribution.wish_id)
    percent_fullfilled = (wish.quantity * (wish.percent_fullfilled||0 )+ contribution.contributed_qty )/wish.quantity
    sign, significant_digits, base, exponent = percent_fullfilled.split
    updated_percent_fullfilled = sign * "0.#{significant_digits}".to_f * (base ** exponent)
    wish.update_attributes(percent_fullfilled: updated_percent_fullfilled)
  end
end
