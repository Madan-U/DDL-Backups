-- Object: PROCEDURE dbo.rpt_acc_glledger_All
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE     PROCEDURE [dbo].[rpt_acc_glledger_All]      
  
  
@sdate varchar(11),            /* As mmm dd yyyy */  
 @edate varchar(11),            /* As mmm dd yyyy */  
 @fdate varchar(11),            /* As mmm dd yyyy */  
 @tdate varchar(11),            /* As mmm dd yyyy */  
 @fcode varchar(10),  
 @tcode varchar(10),  
 @statusId varchar(30),  
 @statusname varchar(30),  
 @branch varchar(10),  
 @selectionby varchar(3),  
 @GroupBy varchar(10),  
 @Sortby varchar(50),  
 @reportname varchar(30),  
 @reportopt varchar(10)   
      
AS  
BEGIN   
  
     
CREATE TABLE [dbo].[#tmpLedgerNew] (      
  [booktype] [char] (2)  NULL ,      
  [voudt] [varchar] (20) NULL ,      
  [effdt] [varchar] (20) NULL ,      
  [shortdesc] [char] (6) NULL ,      
  [dramt] [money] NULL ,      
  [cramt] [money] NULL ,      
  [vno] [varchar] (12) NULL ,      
  [Narration] [varchar] (234) NULL ,  
  [ddno] [varchar] (15) NULL ,      
  [cltcode] [varchar] (10) NOT NULL ,  
  [Longname] [varchar] (100) NULL ,  
  [vdt] [datetime] NULL ,        
  [vtyp] [smallint] NULL ,      
  [accat] [varchar] (30) NULL ,      
  [opbal] [money] NULL ,      
  [crosac] [varchar] (10) NULL ,      
  [Acname] [varchar] (100) NULL ,   
  [Branchcode] [varchar] (10) NULL ,  
  [LNO][smallint] NULL,  
  [Segment] [varchar] (4) NULL,      
  [Entity] [varchar] (50) NULL,      
  [orderSeg][bigint] NULL    
  
 ) ON [PRIMARY]      
      
   --Exec rpt_Acc_GlBook_New 'Apr 26 2005', 'Apr 26 2005', '01/04/2005', '771630', '771630', 'broker', 'broker', '%'    
      
INSERT INTO #tmpLedgerNew(booktype,voudt,effdt,shortdesc,dramt,cramt,vno,Narration,ddno,cltcode,      
Longname,vdt,vtyp,accat,opbal,crosac,Acname,Branchcode,LNO)      
Exec ACCOUNT.DBO.rpt_Acc_GLREPORT @sdate,@edate,@fdate,@tdate,@fcode,@tcode,@statusId,@statusname,@branch,@selectionby,@GroupBy,@Sortby,@reportname,@reportopt  
  
      
UPDATE #tmpLedgerNew set Segment='1NSE',Entity='CAPITAL - NSE', orderSeg = 1 where Segment is NULL      
      
INSERT INTO #tmpLedgerNew(booktype,voudt,effdt,shortdesc,dramt,cramt,vno,Narration,ddno,cltcode,      
Longname,vdt,vtyp,accat,opbal,crosac,Acname,Branchcode,LNO)      
Exec ACCOUNTBSE.DBO.rpt_Acc_GLREPORT @sdate,@edate,@fdate,@tdate,@fcode,@tcode,@statusId,@statusname,@branch,@selectionby,@GroupBy,@Sortby,@reportname,@reportopt  
      
UPDATE #tmpLedgerNew set Segment='2BSE',Entity='CAPITAL - BSE', orderSeg = 2 where Segment is NULL      
--Nsefo start   
     
INSERT INTO #tmpLedgerNew(booktype,voudt,effdt,shortdesc,dramt,cramt,vno,Narration,ddno,cltcode,      
Longname,vdt,vtyp,accat,opbal,crosac,Acname,Branchcode,LNO)      
Exec ACCOUNTFO.DBO.rpt_Acc_GLREPORT @sdate,@edate,@fdate,@tdate,@fcode,@tcode,@statusId,@statusname,@branch,@selectionby,@GroupBy,@Sortby,@reportname,@reportopt  
      
--Nsefo end      
      
UPDATE #tmpLedgerNew set Segment='3NFO',Entity='DERIVATIVES - NSE', orderSeg = 3 where Segment is NULL      
    
      
--if @strorder = 'ACCODE'      
 --begin      
  --if @selectby = 'vdt'      
  -- begin      
    --if @Single = 'Y'      
     --Begin      
    --  select * from #tmpLedgerNew order by orderSeg,cltcode,voudt      
    -- End      
   -- else      
    -- Begin      
    --  select * from #tmpLedgerNew order by cltcode,orderSeg,voudt      
    --  End      
   --end      
  --else      
  -- begin      
   -- if @Single = 'Y'      
    -- Begin      
    --  select * from #tmpLedgerNew order by orderSeg,cltcode,effdt      
    -- End      
    --Else      
    -- Begin      
    --  select * from #tmpLedgerNew order by cltcode,orderSeg,effdt      
    -- End      
   --end      
 --end      
--else      
-- begin      
 -- if @selectby = 'vdt'      
 --  begin    
 --   if @Single = 'Y'      
  --   Begin      
  --    select * from #tmpLedgerNew order by orderSeg,Acname,voudt      
  --   End      
  --  Else      
  --   Begin      
  --    select * from #tmpLedgerNew order by Acname,orderSeg,voudt      
  --   End      
  -- end      
  --else      
  -- begin      
  --  if @Single = 'Y'      
  --   Begin      
  --    select * from #tmpLedgerNew order by orderSeg,Acname,effdt      
  --  End      
 --   Else      
 --    Begin      
 --     select * from #tmpLedgerNew order by Acname,orderSeg,effdt      
 --    End      
 --  end      
 --end      
      
Select  
 booktype,  
 voudt,  
 effdt,   
 shortdesc,  
 dramt,  
 cramt,  
 vno,  
 narration,  
 ddno,  
 cltcode,  
 longname,  
 vdt,  
 vtyp,  
 accat,  
 opbal,  
 crosac,  
 acname,  
 branchcode,  
 lno,  
 Segment,      
 Entity,      
 orderSeg  
from  
#tmpLedgerNew order by CltCode,orderSeg,  
 vdt  
  
  
END

GO
