Select TOP 5 *
From [FIFA World Cup All Goals 1930-2022]

--Editions of the FIFA World Cup since 1930-2022

Select count(distinct(tournament_id)) as All_Editions
From [FIFA World Cup All Goals 1930-2022]

--Editions Played by Country Since 1930-2022

Select distinct(team_name), count(distinct(tournament_id)) as Editions_played
From [FIFA World Cup All Goals 1930-2022]
Group by team_name
Order by Editions_played desc

--Total Goals Since 1930-2022

Select count(own_goal) as Total_goals
From [FIFA World Cup All Goals 1930-2022]

--Total Own Goals Since 1930-2022

Select count(own_goal) as Total_own_goals
From [FIFA World Cup All Goals 1930-2022]
Where own_goal = 1

--Total Penalty Goals Since 1930-2022

Select count(penalty) as Total_penalty_goals
From [FIFA World Cup All Goals 1930-2022]
Where penalty = 1

--Percentage of Goals 

Drop table if exists #goals_carac

Create table #goals_carac (
Total_goals float,
Penalty_goals float,
Own_goals float
)

Insert into #goals_carac
Select sum(home_team+away_team) as Total_goals,
(select sum(penalty) from [FIFA World Cup All Goals 1930-2022] where penalty = 1) as Penalty_goals,
(select sum(own_goal) from [FIFA World Cup All Goals 1930-2022] where own_goal = 1) as Own_goals
From [FIFA World Cup All Goals 1930-2022]

Select ((Total_goals-(Penalty_goals+Own_goals))/Total_goals)*100 as Normal_goals_percentage,
(Penalty_goals/Total_goals)*100 as Penalty_percentage,
(Own_goals/Total_goals)*100 as Own_goals_percentage
From #goals_carac

--Total Goals Scored per Torunament from 1930 to 2022

Select tournament_id, (SUM(home_team)+SUM(away_team)) as TotalGoalsScored
From [FIFA World Cup All Goals 1930-2022]
Group by tournament_id
Order by tournament_id

--Total Goals Scored per Country from 1930 to 2022

Select team_name, (SUM(home_team)+SUM(away_team)) as TotalGoalsScored
From [FIFA World Cup All Goals 1930-2022]
Group by team_name
Order by TotalGoalsScored desc

--Goals Scored by Country In Each World Cup

Select distinct(tournament_id), team_name,
SUM(home_team+away_team) Over (Partition By team_id, tournament_id) as Goals_scored_by_country
From [FIFA World Cup All Goals 1930-2022]
Order by tournament_id

--Every Goalscorer From Each Country Over All Editions of the FIFA World Cup

Select distinct(team_name),
CONCAT(replace(given_name,'not applicable',''),' ',family_name) as Player_name,
SUM(home_team+away_team) Over (Partition By family_name, team_name) as Goals_scored
From [FIFA World Cup All Goals 1930-2022]
--Order by team_name, Goals_scored desc
Order by 3 desc

--Goals Scored by Match Period

Select distinct(match_period), sum(home_team+away_team) as Total_goals
From [FIFA World Cup All Goals 1930-2022]
Group by match_period 
Order by Total_goals desc

-- Goals Scored by Match Minute 

Select distinct(minute_regulation), sum(home_team+away_team) as Total_goals
From [FIFA World Cup All Goals 1930-2022]
--Where minute_regulation > 45 and  minute_regulation <= 90
Group by minute_regulation 
Order by minute_regulation

--Games Played by Country

Select match_name, count(match_id) as Games_played
From [FIFA World Cup All Goals 1930-2022]
--Where match_name = 'France v Argentina' or match_name = 'Argentina v France'
Where match_name like 'Ec%'
Group by match_name


CREATE PROCEDURE matches
As
Select match_name, count(match_id) as Games_played
From [FIFA World Cup All Goals 1930-2022]
Where match_name = 'France v Argentina' or match_name = 'Argentina v France'
Group by match_name

exec matches @game1 = 'Ecuador v England', @game2 = 'England v Ecuador'