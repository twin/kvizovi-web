class GamePresenter < BasePresenter
  presents :game

  def results
    game.players.zip(game.scores, 1..game.players.count, game.scores.map { |score| rank(score) })
  end

  def total_score
    game.questions.map(&:points).inject(:+) / game.players.count
  end

  def rank(score)
    case percentage(score, total_score)
    when 0...30
      "znalac-malac"
    when 30...70
      "ekspert"
    when 70..100
      "super-ekspert"
    end
  end
end
