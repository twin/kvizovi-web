# encoding: utf-8

class SessionsController < ApplicationController
  def new_student
    @regions = Region.all
  end

  def new_school
  end

  def create
    if params[:student]
      if params[:school_id].present?
        student = School.find(params[:school_id]).students.authenticate(params[:student])

        if student
          log_in!(student)
          redirect_to new_game_path
        else
          flash.now[:alert] = "Pogrešno korisničko ime ili lozinka."
          @regions = Region.all
          render :new_student
        end
      else
        flash.now[:alert] = "Niste izabrali školu."
        @regions = Region.all
        render :new_student
      end
    elsif params[:school]
      school = School.authenticate(params[:school])

      if school
        log_in!(school)
        redirect_to school
      else
        render :new_school
      end
    end
  end

  def destroy
    log_out!
    redirect_to root_path
  end
end