#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# clear table before insert
echo $($PSQL "truncate teams, games")
echo $($PSQL "alter sequence games_game_id_seq restart with 1")
echo $($PSQL "alter sequence teams_team_id_seq restart with 1")
# loop through csv file with separator , and read values
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
# avoid first line title
if [[ $YEAR != "year" ]]
then
# get team id of winner
WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER';")
# if not found
if [[ -z $WINNER_ID ]]
then
# then insert
INSERT_WINNER_RESULT=$($PSQL "insert into teams(name) values('$WINNER');")
fi
# get team id of opponent
OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT';")
# if not found
if [[ -z $OPPONENT_ID ]]
then
# then insert
INSERT_OPPONENT_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT');")
fi

# get winner id
WI=$($PSQL "select team_id from teams where name='$WINNER';")
# get opponent id
OI=$($PSQL "select team_id from teams where name='$OPPONENT';")
# insert
INSERT_GAME_RESULT=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values('$YEAR', '$ROUND', $WI, $OI, '$WINNER_GOALS', '$OPPONENT_GOALS')")
fi
done
