USE [FIFAWCGoals]
GO
/****** Object:  StoredProcedure [dbo].[matches]    Script Date: 3/1/2023 4:49:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[matches]
@game1 nvarchar(100), @game2 nvarchar(100)
As
Select match_name, count(match_id) as Games_played
From [FIFA World Cup All Goals 1930-2022]
Where match_name = @game1 or match_name = @game2
Group by match_name