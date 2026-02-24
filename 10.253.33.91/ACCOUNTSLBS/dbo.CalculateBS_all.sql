-- Object: PROCEDURE dbo.CalculateBS_all
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

--Exec CalculateBS_all  'Apr  1 2007','Aug  6 2007','', 'Y'  
  
CREATE PROC [dbo].[CalculateBS_all]     
@FROMDATE VARCHAR(11),    
@TODATE VARCHAR(11),    
@BRANCHCD VARCHAR(20),    
@SHOWZERO VARCHAR(1) = 'N'    
  
AS    
  
BEGIN    
  
CREATE TABLE [dbo].[#tmpBS] (    
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
  
  
INSERT INTO #tmpBS(Group_Code,Group_Name,Main_group,amount,Type,Reclevel)    
Exec ACCOUNT.DBO.CalculateBS @FROMDATE,  @TODATE,@BRANCHCD ,  @SHOWZERO   
    
UPDATE #tmpBS set Segment='NSE',Entity='CAPITAL - NSE', orderSeg = 1 where Segment is NULL    
  
INSERT INTO #tmpBS(Group_Code,Group_Name,Main_group,amount,Type,Reclevel)    
Exec ACCOUNTBSE.DBO.CalculateBS @FROMDATE,  @TODATE,@BRANCHCD ,  @SHOWZERO   
    
UPDATE #tmpBS set Segment='BSE',Entity='CAPITAL - BSE', orderSeg = 2 where Segment is NULL    
  
INSERT INTO #tmpBS(Group_Code,Group_Name,Main_group,amount,Type,Reclevel)    
Exec ACCOUNTFO.DBO.CalculateBS @FROMDATE,  @TODATE,@BRANCHCD ,  @SHOWZERO   
    
UPDATE #tmpBS set Segment='NFO',Entity='DERIVATIVES - NSE', orderSeg = 3 where Segment is NULL    
  
  
--Select * from #tmpBS order by reclevel,orderseg,group_code  
  
--Select group_code,group_name,sum(Amount) from #tmpBS where main_group = ' ' and reclevel = 1 and type = 'G' group by group_code,group_name  
  
  
CREATE TABLE [dbo].[#tmpBS1] (    
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
  
Insert  into #tmpBS1 (group_code,group_name,Amount)  Select group_code,group_name,sum(Amount) from #tmpBS where main_group = ' ' and reclevel = 1 and type = 'G' group by group_code,group_name  
Update  #tmpBS1 set type = 'G',main_group = ' ',orderseg = 0 ,reclevel = 1  
Insert into #tmpBS1  Select * from #tmpBS where main_group <> ''  
--Select * from #tmpBS1 order by reclevel,group_code  
--update  #tmpBS1 set segment='',entity='' where segment is null  
Select * from #tmpBS1 order by reclevel,group_code  
  
  
  
Drop table #tmpBS  
  
Drop table #tmpBS1  
  
END

GO
