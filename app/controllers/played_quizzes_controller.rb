class PlayedQuizzesController < ApplicationController
  before_action :authenticate_user!
  before_action :assing_scope

  decorates_assigned :played_quiz

  def index
    @played_quizzes = @scope.played_quizzes
      .descending
      .includes(:quiz_snapshot, :players)
      .paginate(page: params[:page], per_page: 15)
      .decorate
  end

  def show
    @played_quiz = PlayedQuiz.find(params[:id])
    @position = @scope.played_quizzes.ascending.position(@played_quiz)
  end

  private

  def assing_scope
    @scope = case
             when params[:student_id] then Student.find(params[:student_id])
             when params[:quiz_id]    then Quiz.find(params[:quiz_id])
             else                          current_user
             end
  end
end
