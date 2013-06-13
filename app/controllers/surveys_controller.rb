class SurveysController < ApplicationController
  before_filter :authenticate!

  def new
    @survey = Survey.new
  end

  def create
    @survey = Survey.new
    @survey.assign_attributes(survey_params)

    if @survey.valid?
      @survey.save
      current_user.update_column(:completed_survey, true)
      redirect_to root_path_for(current_user), notice: flash_success
    else
      set_flash_error
      render :new
    end
  end

  private

  def survey_params
    params.require(:survey).permit!
  end
end
