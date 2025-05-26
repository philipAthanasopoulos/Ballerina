import pandas as pd
from sqlalchemy import create_engine, MetaData, Table

# Create a connection to your SQL database
engine = create_engine('postgresql+psycopg2://postgres:root@localhost:5432/football_db')
countries_table = Table('countries', MetaData(), autoload_with=engine)
games_table = Table('games', MetaData(), autoload_with=engine)
players_table = Table('players', MetaData(), autoload_with=engine)
goals_table = Table('goals', MetaData(), autoload_with=engine)
shootouts_table = Table('shootouts', MetaData(), autoload_with=engine)

encoding = 'ISO-8859-1'
countries = pd.read_csv('datasets/countries.csv', encoding=encoding)
former_names = pd.read_csv('datasets/former_names.csv', encoding=encoding)
goalscorers = pd.read_csv('datasets/goalscorers.csv', encoding=encoding)
games = pd.read_csv('datasets/results.csv', encoding=encoding)
shootouts = pd.read_csv('datasets/shootouts.csv', encoding=encoding)

# fix naming conventions on columns
# replace " " with "_"
countries.columns = countries.columns.str.replace(' ', '_')
former_names.columns = former_names.columns.str.replace(' ', '_')
goalscorers.columns = goalscorers.columns.str.replace(' ', '_')
games.columns = games.columns.str.replace(' ', '_')
shootouts.columns = shootouts.columns.str.replace(' ', '_')

# replace "-" with "_"
countries.columns = countries.columns.str.replace('-', '_')
former_names.columns = former_names.columns.str.replace('-', '_')
goalscorers.columns = goalscorers.columns.str.replace('-', '_')
games.columns = games.columns.str.replace('-', '_')
shootouts.columns = shootouts.columns.str.replace('-', '_')

# remove ( and )
countries.columns = countries.columns.str.replace('(', '')
countries.columns = countries.columns.str.replace(')', '')

# Transform
# Replace old names with current names
for index, row in former_names.iterrows():
    old_name = row['former']
    new_name = row['current']
    goalscorers['home_team'].replace(old_name, new_name, inplace=True)
    goalscorers['away_team'].replace(old_name, new_name, inplace=True)
    games['home_team'].replace(old_name, new_name, inplace=True)
    games['away_team'].replace(old_name, new_name, inplace=True)
    games['country'].replace(old_name, new_name, inplace=True)
    shootouts['home_team'].replace(old_name, new_name, inplace=True)
    shootouts['away_team'].replace(old_name, new_name, inplace=True)

# Add countries to that exist in results,goalscorers or shootouts but not in countries
countries_from_results = pd.concat([games['home_team'], games['away_team'], games['country']])
countries_from_goalscorers = pd.concat([goalscorers['home_team'], goalscorers['away_team']])
countries_from_shootouts = pd.concat([shootouts['home_team'], shootouts['away_team']])
countries_combined = pd.Series(
    pd.concat([countries_from_results, countries_from_goalscorers, countries_from_shootouts]).unique())
countries_not_in_countries = countries_combined[~countries_combined.isin(countries['Display_Name'])]

# add them to countries
countries_not_in_countries_df = pd.DataFrame(countries_not_in_countries, columns=['Display_Name'])
countries_not_in_countries_df['Official_Name'] = countries_not_in_countries_df['Display_Name']
countries.merge(countries_not_in_countries_df, how='outer', left_on='Display_Name', right_on='Display_Name',
                suffixes=('', '_new'), indicator=True)

# Define the table schema using SQLAlchemy
metadata = MetaData()

countries['id'] = countries.index + 1

# replace home_team and away_team with home_team_id and away_team_id using countries.id
games['home_team_id'] = games['home_team'].map(countries.set_index('Display_Name')['id'])
games['away_team_id'] = games['away_team'].map(countries.set_index('Display_Name')['id'])
games['country_id'] = games['country'].map(countries.set_index('Display_Name')['id'])
games.drop(['home_team', 'away_team', 'country'], axis=1, inplace=True)
# Clean up the data
games = games[games['home_team_id'].notnull() & games['away_team_id'].notnull()]
games = games[games['home_team_id'] != games['away_team_id']]
games.reset_index(drop=True, inplace=True)
games['id'] = games.index + 1

# player belongs to country if own_goal is false
players = goalscorers[goalscorers['own_goal'] == False][['scorer', 'team']].drop_duplicates()
players['country_id'] = players['team'].map(countries.set_index('Display_Name')['id'])
players.reset_index(drop=True, inplace=True)
players['id'] = players.index + 1
players.rename(columns={'scorer': 'name'}, inplace=True)
players.drop(['team'], axis=1, inplace=True)

goals = goalscorers.copy()
goals.reset_index(drop=True, inplace=True)
# ensure players DataFrame has unique names
players = players.drop_duplicates(subset=['name'])
# replace scorer with player_id
goals['player_id'] = goals['scorer'].map(players.set_index('name')['id'])
goals['home_team_id'] = goals['home_team'].map(countries.set_index('Display_Name')['id'])
goals['away_team_id'] = goals['away_team'].map(countries.set_index('Display_Name')['id'])
goals['game_id'] = goals.merge(games, how='left', on=['date', 'home_team_id', 'away_team_id'])['id']
goals.drop(['scorer', 'date', 'home_team', 'away_team', 'team', 'penalty', 'home_team_id', 'away_team_id'], axis=1,
           inplace=True)
goals['id'] = goals.index + 1
# find game id based on home team, away team and date


shootouts['first_shooter_id'] = shootouts['home_team'].map(countries.set_index('Display_Name')['id'])
shootouts['home_team_id'] = shootouts['home_team'].map(countries.set_index('Display_Name')['id'])
shootouts['away_team_id'] = shootouts['away_team'].map(countries.set_index('Display_Name')['id'])
shootouts['winner_id'] = shootouts['winner'].map(countries.set_index('Display_Name')['id'])
shootouts['game_id'] = shootouts.merge(games, how='left', on=['date', 'home_team_id', 'away_team_id'])['id']
shootouts['id'] = shootouts.index + 1
shootouts.drop(['home_team', 'away_team', 'winner', 'date', 'first_shooter','home_team_id', 'away_team_id'], axis=1, inplace=True)

# Create the tables in the database
metadata.create_all(engine)

# Load
countries.to_sql('countries', engine, index=False, if_exists='append')
games.to_sql('games', engine, index=False, if_exists='append')
players.to_sql('players', engine, index=False, if_exists='append')
goals.to_sql('goals', engine, index=False, if_exists='append')
shootouts.to_sql('shootouts', engine, index=False, if_exists='append')
