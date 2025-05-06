class LeaderboardController < ApplicationController
  def index
    @top_10_by_wins = Game.select("team_id, COUNT(*) as wins")
                          .from("(SELECT home_team_id as team_id FROM games WHERE home_score > away_score AND neutral = false
                                  UNION ALL
                                  SELECT away_team_id as team_id FROM games WHERE away_score > home_score AND neutral = false) as combined_games")
                          .group("team_id")
                          .order("wins DESC")
                          .limit(10)

    @top_10_by_score_function = Game.select("team_id, (3 * COUNT(*) + 1 * SUM(ties)) as score")
                                    .from("(SELECT home_team_id as team_id, 0 as ties FROM games WHERE home_score > away_score AND neutral = false
              UNION ALL
              SELECT away_team_id as team_id, 0 as ties FROM games WHERE away_score > home_score AND neutral = false
              UNION ALL
              SELECT home_team_id as team_id, 1 as ties FROM games WHERE home_score = away_score AND neutral = false
              UNION ALL
              SELECT away_team_id as team_id, 1 as ties FROM games WHERE home_score = away_score AND neutral = false) as combined_games")
                                    .group("team_id")
                                    .order("score DESC")
                                    .limit(10)

    @top_10_by_wins_divided_by_years = Game.select("team_id, (COUNT(*) * 1.0 / (MAX(EXTRACT(YEAR FROM date)) - MIN(EXTRACT(YEAR FROM date)) + 1)) as score")
                                           .from("(SELECT home_team_id as team_id, date FROM games WHERE home_score > away_score AND neutral = false
           UNION ALL
           SELECT away_team_id as team_id, date FROM games WHERE away_score > home_score AND neutral = false) as combined_games")
                                           .group("team_id")
                                           .order("score DESC")
                                           .limit(10)
    @top_10_by_score_divided_by_years = Game.select("team_id, ((3 * COUNT(*) + 1 * SUM(ties)*1.0) / (MAX(EXTRACT(YEAR FROM date)) - MIN(EXTRACT(YEAR FROM date)) + 1)) as score")
                                            .from("(SELECT home_team_id as team_id,date, 0 as ties FROM games WHERE home_score > away_score AND neutral = false
              UNION ALL
              SELECT away_team_id as team_id,date, 0 as ties FROM games WHERE away_score > home_score AND neutral = false
              UNION ALL
              SELECT home_team_id as team_id,date, 1 as ties FROM games WHERE home_score = away_score AND neutral = false
              UNION ALL
              SELECT away_team_id as team_id,date, 1 as ties FROM games WHERE home_score = away_score AND neutral = false) as combined_games")
                                            .group("team_id")
                                            .order("score DESC")
                                            .limit(10)
  end
end
