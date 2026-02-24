-- Object: PROCEDURE dbo.CBO_SEARCHBROKRAGEBYTABLENO
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

--EXEC CBO_SEARCHBROKRAGEBYTABLENO_TEST '2',''

CREATE PROCEDURE CBO_SEARCHBROKRAGEBYTABLENO
@TABLE_NO VARCHAR(10),    
@TABLE_NAME VARCHAR(25),    
@STATUSID VARCHAR(25) = 'BROKER',    
@STATUSNAME VARCHAR(25) = 'BROKER'
AS      
IF ISNULL(@TABLE_NO, '') <> '' AND ISNULL(@TABLE_NAME, '') = ''

	SELECT * FROM BROKTABLE WHERE TABLE_NO = @TABLE_NO ORDER BY Line_No    

ELSE IF ISNULL(@TABLE_NAME, '') <> '' AND ISNULL(@TABLE_NO, '') = ''
	SELECT Table_No,Line_No,Val_perc,Upper_lim,Day_puc,Day_Sales,Sett_Purch,round_to,Table_name,sett_sales,    
	NORMAL,Trd_Del,Lower_lim,Def_table,RoFig,ErrNum,NoZero,Branch_code      
	FROM BROKTABLE WHERE TABLE_NAME = @TABLE_NAME ORDER BY Line_No

ELSE IF ISNULL(@TABLE_NO, '') <> '' AND ISNULL(@TABLE_NAME, '') <> ''

	SELECT Table_No,Line_No,Val_perc,Upper_lim,Day_puc,Day_Sales,Sett_Purch,round_to,Table_name,sett_sales,    
	NORMAL,Trd_Del,Lower_lim,Def_table,RoFig,ErrNum,NoZero,Branch_code      
	FROM BROKTABLE WHERE TABLE_NO = @TABLE_NO AND TABLE_NAME = @TABLE_NAME ORDER BY Line_No

GO
