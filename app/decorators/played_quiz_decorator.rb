class PlayedQuizDecorator < Draper::Decorator
  delegate_all

  def results
    players.zip(scores)
  end

  def scores
    scores = Array.new(players.count, 0)
    question_answers.each.with_index do |answer, idx|
      if has_answers?
        scores[idx % players.count] += 1 if QuestionAnswer.new(questions[idx]).correct_answer?(answer)
      else
        scores[idx % players.count] += 1 if answer
      end
    end
    scores
  end

  def total_score
    questions_count / players.count
  end

  def played_questions
    Array(questions).map.with_index do |question, idx|
      answer = question_answers[idx]
      status = get_status(question, answer)
      player = players[idx % players.count]

      [question, answer, player, status]
    end
  end

  private

  def get_status(question, answer)
    case
    when QuestionAnswer.new(question).correct_answer?(answer)
      "correct"
    when answer.nil?
      "unanswered"
    else
      "wrong"
    end
  end

  def questions_count
    has_answers? ? questions.count : question_answers.count
  end
end
