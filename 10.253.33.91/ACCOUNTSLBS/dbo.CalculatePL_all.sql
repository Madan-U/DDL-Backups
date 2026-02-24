-- Object: PROCEDURE dbo.CalculatePL_all
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

--Exec CalculatePL_all  'Apr  1 2007','Aug  6 2007','', 'Y'


CREATE PROC [dbo].[CalculatePL_all]   
@FROMDATE VARCHAR(11),  
@TODATE VARCHAR(11),  
@BRANCHCD VARCHAR(20),  
@SHOWZERO VARCHAR(1) = 'N'  

AS  

BEGIN  

CREATE TABLE [dbo].[#tmpPnL] (  
	[Group_Code] [varchar] (13) NULL , 
	[Group_NAME] [varchar] (60) NULL ,
	[MAIN_GROUP] [varchar] (13) NULL ,
	[AMOUNT] [Numeric] (18,4) NULL ,  
	[TYPE] [char] (1),
	[RECLEVEl] [bigint] NULL ,
	[Segment] [varchar] (4) NULL,  
  	[Entity] [varchar] (50) NULL,  
  	[orderSeg][bigint] NULL 
) 


INSERT INTO #tmpPnL(Group_Code,Group_Name,Main_group,amount,Type,Reclevel)  
Exec ACCOUNT.DBO.CalculatePL @FROMDATE,  @TODATE,@BRANCHCD ,  @SHOWZERO 
  
UPDATE #tmpPnL set Segment='NSE',Entity='CAPITAL - NSE', orderSeg = 1 where Segment is NULL  

INSERT INTO #tmpPnL(Group_Code,Group_Name,Main_group,amount,Type,Reclevel)  
Exec ACCOUNTBSE.DBO.CalculatePL @FROMDATE,  @TODATE,@BRANCHCD ,  @SHOWZERO 
  
UPDATE #tmpPnL set Segment='BSE',Entity='CAPITAL - BSE', orderSeg = 2 where Segment is NULL  

INSERT INTO #tmpPnL(Group_Code,Group_Name,Main_group,amount,Type,Reclevel)  
Exec ACCOUNTFO.DBO.CalculatePL @FROMDATE,  @TODATE,@BRANCHCD ,  @SHOWZERO 
  
UPDATE #tmpPnL set Segment='NFO',Entity='DERIVATIVES - NSE', orderSeg = 3 where Segment is NULL  


--Select * from #tmpPnl order by reclevel,orderseg,group_code

--Select group_code,group_name,sum(Amount) from #tmpPnl where main_group = ' ' and reclevel = 1 and type = 'G' group by group_code,group_name


CREATE TABLE [dbo].[#tmpPnL1] (  
	[Group_Code] [varchar] (13) NULL , 
	[Group_NAME] [varchar] (60) NULL ,
	[MAIN_GROUP] [varchar] (13) NULL ,
	[AMOUNT] [Numeric] (18,4) NULL ,  
	[TYPE] [char] (1),
	[RECLEVEl] [bigint] NULL ,
	[Segment] [varchar] (4) NULL,  
  	[Entity] [varchar] (50) NULL,  
  	[orderSeg][bigint] NULL 
) 

Insert  into #tmpPnl1 (group_code,group_name,Amount)  Select group_code,group_name,sum(Amount) from #tmpPnl where main_group = ' ' and reclevel = 1 and type = 'G' group by group_code,group_name
Update  #tmpPnl1 set type = 'G',main_group = ' ',orderseg = 0 ,reclevel = 1
Insert into #tmpPnl1  Select * from #tmpPnl where main_group <> ''
Select * from #tmpPnl1 order by reclevel,orderseg,group_code




Drop table #tmppnl

Drop table #tmppnl1

END

GO
