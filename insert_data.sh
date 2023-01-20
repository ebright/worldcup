#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games,teams RESTART IDENTITY;")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
do
if [[ $YEAR != 'year' ]]
then
  WIN_ID=$($PSQL "SELECT team_id FROM teams where name = '$WINNER'")
  if [[ -z $WIN_ID ]]
  then
    echo "Winning team not found"
    echo "Inserting $WINNER"
    INSERT_TEAM_RESULTS=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    echo $INSERT_TEAM_RESULTS
  fi
  OPP_ID=$($PSQL "SELECT team_id FROM teams where name = '$OPPONENT'")
  if [[ -z $OPP_ID ]]
  then
    echo "Opponent team not found"
    echo "Inserting $OPPONENT"
    INSERT_TEAM_RESULTS=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    echo $INSERT_TEAM_RESULTS
  fi
fi
done
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
do
  if [[ $YEAR != 'year' ]]
  then
    WIN_ID=$($PSQL "SELECT team_id FROM teams where name = '$WINNER'")
    OPP_ID=$($PSQL "SELECT team_id FROM teams where name = '$OPPONENT'")
    INSERT_GAME_RESULTS=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WIN_ID, $OPP_ID, $WGOALS, $OGOALS)")
    echo "inserting ($YEAR $ROUND $WIN_ID $OPP_ID $WGOALS $OGOALS) in games table"
    echo $INSERT_GAME_RESULTS
  fi
done