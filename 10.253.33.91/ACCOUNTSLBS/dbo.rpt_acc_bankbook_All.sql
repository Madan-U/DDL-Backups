-- Object: PROCEDURE dbo.rpt_acc_bankbook_All
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------




  
Create     PROCEDURE [dbo].[rpt_acc_bankbook_All]    


	@FDATE VARCHAR(11),            /* AS MMM DD YYYY */                      
      @TDATE VARCHAR(11),            /* AS MMM DD YYYY */                      
      @SDATE VARCHAR(11),            /* AS MMM DD YYYY */                      
      @FCODE VARCHAR(10),                      
      @STATUSID VARCHAR(30),                      
      @STATUSNAME VARCHAR(30),                      
      @BRANCH VARCHAR(10),  
      @SELECTIONBY VARCHAR(3) = 'VDT',
	  @orderflg varchar(1) = 'N'     

    
AS

BEGIN 


   
CREATE TABLE [dbo].[#tmpLedgerNew] (    
  [SRNO] [INT] IDENTITY (1, 1) NOT NULL ,                    
 [BOOKTYPE] [CHAR] (2) NULL ,                    
 [VOUDT] [VARCHAR] (10) NULL ,        
 [EFFDT] [VARCHAR] (10) NULL ,                    
 [SHORTDESC] [CHAR] (6) NOT NULL DEFAULT(' ') ,                    
 [DRAMT] [MONEY] NULL ,                    
 [CRAMT] [MONEY] NULL ,                    
 [VNO] [VARCHAR] (12) NULL ,                    
 [NARRATION] [VARCHAR] (500) NULL ,                    
 [DDNO] [VARCHAR] (15) NULL ,                    
 [CLTCODE] [VARCHAR] (10) NOT NULL ,                    
 [LONGNAME] [VARCHAR] (100) NULL ,                    
 [VTYP] [SMALLINT] NOT NULL ,                    
 [ACCAT] [CHAR] (2) NULL ,                    
 [OPBAL] [MONEY] NOT NULL ,                    
 [CROSAC] [VARCHAR] (10) NOT NULL ,                    
 [ACNAME] [VARCHAR] (100) NULL ,                    
 [BRANCHCODE] [VARCHAR] (35) NULL ,                    
 [VCHDT] [DATETIME] NULL,                    
 [Segment] [varchar] (4) NULL,    
 [Entity] [varchar] (50) NULL,    
 [orderSeg][bigint] NULL  

 ) ON [PRIMARY]    
    
   --Exec rpt_Acc_GlBook_New 'Apr 26 2005', 'Apr 26 2005', '01/04/2005', '771630', '771630', 'broker', 'broker', '%'  
    
INSERT INTO #tmpLedgerNew(booktype,voudt,effdt,shortdesc,dramt,cramt,vno,Narration,ddno,cltcode,    
Longname,vtyp,accat,opbal,crosac,Acname,Branchcode,vchdt)    
Exec ACCOUNT.DBO.RPT_ACC_BANKBOOK_NEW @FDATE, @TDATE ,@SDATE, @FCODE, @STATUSID,@STATUSNAME, @BRANCH,@SELECTIONBY

    
If @orderflg = 'N'
begin
UPDATE #tmpLedgerNew set Segment='1NSE',Entity='-', orderSeg = 1 where Segment is NULL
end
else
begin
UPDATE #tmpLedgerNew set Segment='1NSE',Entity='CAPITAL - NSE', orderSeg = 1 where Segment is NULL
end    

PRINT 'CAPITAL - NSE'  
INSERT INTO #tmpLedgerNew(booktype,voudt,effdt,shortdesc,dramt,cramt,vno,Narration,ddno,cltcode,    
Longname,vtyp,accat,opbal,crosac,Acname,Branchcode,vchdt)  
Exec ACCOUNTBSE.DBO.RPT_ACC_BANKBOOK_NEW @FDATE, @TDATE ,@SDATE, @FCODE, @STATUSID,@STATUSNAME, @BRANCH,@SELECTIONBY
    
If @orderflg = 'N'
begin  

UPDATE #tmpLedgerNew set Segment='2BSE',Entity='-', orderSeg = 1 where Segment is NULL 
end   
else
begin
UPDATE #tmpLedgerNew set Segment='2BSE',Entity='CAPITAL - BSE', orderSeg = 2 where Segment is NULL    
end



-----------Nsefo start 
   
INSERT INTO #tmpLedgerNew(booktype,voudt,effdt,shortdesc,dramt,cramt,vno,Narration,ddno,cltcode,    
Longname,vtyp,accat,opbal,crosac,Acname,Branchcode,vchdt)    
Exec ACCOUNTFO.DBO.RPT_ACC_BANKBOOK_NEW @FDATE, @TDATE ,@SDATE, @FCODE, @STATUSID,@STATUSNAME, @BRANCH,@SELECTIONBY
    
----Nsefo end    
   
If @orderflg = 'N'
begin  
UPDATE #tmpLedgerNew set Segment='3NFO',Entity='-', orderSeg = 1 where Segment is NULL    
end 
else
begin 
UPDATE #tmpLedgerNew set Segment='3NFO',Entity='DERIVATIVES - NSE', orderSeg = 3 where Segment is NULL    
end
  


If @orderflg = 'N'
 begin 
select cltcode, segment, orderSeg, opbal = max(opbal) into #opbal from #tmpLedgerNew   
group by cltcode, segment, orderSeg  
  
select cltcode, orderseg, opbal = sum(opbal) into #finopbal from #opbal   
group by cltcode, orderseg  
  
  
UPDATE           
            #tmpLedgerNew         
            SET Opbal = 0           
          
      UPDATE           
            #tmpLedgerNew          
            SET Opbal = T.Opbal           
      FROM #tmpledgerNew L WITH(NoLock),           
            #finopbal T WITH(NoLock)           
      WHERE L.Cltcode = T.Cltcode  and L.orderSeg = T.orderseg       
end


  
    
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
 If @orderflg = 'N'
begin
Select
	booktype,
	voudt VDT,
	effdt EDT,
	shortdesc,
	dramt debit,
	cramt credit,
	vno,
	Narration,
	ddno,
	cltcode,    
	Longname,
	vtyp,
	accat,
	opbal,
	crosac,
	Acname,
	Branchcode,
	Segment,    
	Entity,    
	orderSeg,
	VCHDT
	
from
#tmpLedgerNew order by CltCode, VCHDT,orderSeg
end
else 
begin    
Select
	booktype,
	voudt VDT,
	effdt EDT,
	shortdesc,
	dramt debit,
	cramt credit,
	vno,
	Narration,
	ddno,
	cltcode,    
	Longname,
	vtyp,
	accat,
	opbal,
	crosac,
	Acname,
	Branchcode,
	Segment,    
	Entity,    
	orderSeg,
	VCHDT

from
#tmpLedgerNew order by CltCode,orderSeg,VCHDT
end

END

GO
