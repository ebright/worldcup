#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games,teams;")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
do
if [[ $YEAR != 'year' ]]
then
  WIN_ID=$($PSQL "SELECT team_id FROM teams where name = '$WINNER'")
  if [[ -z $WIN_ID ]]
  then
    INSERT_TEAM_RESULTS=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
  fi
  OPP_ID=$($PSQL "SELECT team_id FROM teams where name = '$OPPONENT'")
  if [[ -z $OPP_ID ]]
  then
    INSERT_TEAM_RESULTS=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
  fi
  INSERT_GAME_RESULTS=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WIN_ID, $OPP_ID, $WGOALS, $OGOALS)")
  echo insert game $INSERT_GAME_RESULTS
fi
done