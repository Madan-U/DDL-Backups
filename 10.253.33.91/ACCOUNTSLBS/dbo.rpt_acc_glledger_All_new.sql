-- Object: PROCEDURE dbo.rpt_acc_glledger_All_new
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------



--Exec rpt_acc_glledger_All '01/04/2006', '31/03/2007', 'Jan  1 2007', 'Feb  1 2007', '0', '9', 'broker', 'gog', 'HO','vdt', 'Account', 'VDT', 'GL',''  
  
CREATE     PROCEDURE [dbo].[rpt_acc_glledger_All_new]    


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
	@reportopt varchar(10), 
	@orderflg varchar(1) = 'N',
	@nseflg varchar(1)  ,    
	@bseflg varchar(1)  ,    
	@foflg varchar(1)       
    
 
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
  [Acname] [varchar] (150) NULL , 
  [Branchcode] [varchar] (20) NULL ,
  [LNO][smallint] NULL,
  [Segment] [varchar] (4) NULL,    
  [Entity] [varchar] (50) NULL,    
  [orderSeg][bigint] NULL  

 ) ON [PRIMARY]    
  

If @nseflg = 'Y'
begin    
print 'nse 1' 
   --Exec rpt_Acc_GlBook_New 'Apr 26 2005', 'Apr 26 2005', '01/04/2005', '771630', '771630', 'broker', 'broker', '%'  
		INSERT INTO #tmpLedgerNew(booktype,voudt,effdt,shortdesc,dramt,cramt,vno,Narration,ddno,cltcode,    
		Longname,vdt,vtyp,accat,opbal,crosac,Acname,Branchcode,LNO)    
		Exec ACCOUNT.DBO.rpt_Acc_GLREPORT @sdate,@edate,@fdate,@tdate,@fcode,@tcode,@statusId,@statusname,@branch,@selectionby,@GroupBy,@Sortby,@reportname,@reportopt

print 'Exec ACCOUNT.DBO.rpt_Acc_GLREPORT' + @sdate +',' +@edate + ',' + @fdate +',' + @tdate + ',' + @fcode + ',' + @tcode + ',' + @statusId + ',' + @statusname + ',' + @branch + ',' + @selectionby + ',' + @GroupBy +',' + @Sortby + ',' + @reportname + ',' + @reportopt     

		If @orderflg = 'N'
			begin
				UPDATE #tmpLedgerNew set Segment='1NSE',Entity='SETTELMENT  LEDGER', orderSeg = 1 where Segment is NULL
			end
		else
			begin
				UPDATE #tmpLedgerNew set Segment='1NSE',Entity='CAPITAL - NSE', orderSeg = 1 where Segment is NULL
			end 
print 'nse 2' 
   
end

If @bseflg = 'Y'
begin
  print 'bse 1' 

	INSERT INTO #tmpLedgerNew(booktype,voudt,effdt,shortdesc,dramt,cramt,vno,Narration,ddno,cltcode,    
	Longname,vdt,vtyp,accat,opbal,crosac,Acname,Branchcode,LNO)    
	Exec ACCOUNTBSE.DBO.rpt_Acc_GLREPORT @sdate,@edate,@fdate,@tdate,@fcode,@tcode,@statusId,@statusname,@branch,@selectionby,@GroupBy,@Sortby,@reportname,@reportopt
	If @orderflg = 'N'
		begin  

			UPDATE #tmpLedgerNew set Segment='2BSE',Entity='SETTELMENT  LEDGER', orderSeg = 1 where Segment is NULL 
		end   
	else
		begin
			UPDATE #tmpLedgerNew set Segment='2BSE',Entity='CAPITAL - BSE', orderSeg = 2 where Segment is NULL    
		end
  print 'bse 2'
end

--Nsefo start 

if @foflg = 'Y'
begin
    print 'fo 1' 
	INSERT INTO #tmpLedgerNew(booktype,voudt,effdt,shortdesc,dramt,cramt,vno,Narration,ddno,cltcode,    
	Longname,vdt,vtyp,accat,opbal,crosac,Acname,Branchcode,LNO)    
	Exec ACCOUNTFO.DBO.rpt_Acc_GLREPORT @sdate,@edate,@fdate,@tdate,@fcode,@tcode,@statusId,@statusname,@branch,@selectionby,@GroupBy,@Sortby,@reportname,@reportopt
    
	--Nsefo end    
	If @orderflg = 'N'
		begin  
			UPDATE #tmpLedgerNew set Segment='3NFO',Entity='SETTELMENT  LEDGER', orderSeg = 1 where Segment is NULL    
		end 
	else
		begin 
			UPDATE #tmpLedgerNew set Segment='3NFO',Entity='DERIVATIVES - NSE', orderSeg = 3 where Segment is NULL    
	end
 print 'fo 2'  
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
    

If @orderflg = 'N'
begin  
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
#tmpLedgerNew order by CltCode,	vdt,orderSeg

end
else
begin
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
end

END

GO
