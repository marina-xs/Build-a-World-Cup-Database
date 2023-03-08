#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
TRUNCATE_RESULT=$($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
 do
 if [[ $YEAR != 'year' ]]
 then 
  #echo $YEAR $ROUND $WINNER $OPPONENT $W_GOALS $OP_GOALS
  #get winner team_id
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  #if winner not found in teams
  if [[ -z $WINNER_ID ]]
    #insert the winner into teams
    then
    INSERT_WINNER_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
    #get new team_id of the winner
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  fi
  #get opponent team id
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  #if opponent not found in teams
  if [[ -z $OPPONENT_ID ]] 
    then #insert the opponent into teams
    INSERT_OPPONENT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
    #get new team_id of the opponent
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  fi
  #insert the game
  INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
 fi
 done
