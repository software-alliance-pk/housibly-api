class SchoolPinsController < ApplicationController
  def index
   
  end

  def create
    @school_pin = SchoolPin.new(school_pin_params)
    if @school_pin.save
      redirect_to school_pins_path
    else
      flash.alert = @school_pin.errors.full_messages
     redirect_to school_pins_path 
   end
  end
  private
  def school_pin_params
    params.permit(:pin_name, :longtitude, :latitude)
  end
end