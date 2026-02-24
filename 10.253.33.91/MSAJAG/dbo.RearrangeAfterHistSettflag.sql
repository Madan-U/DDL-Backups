-- Object: PROCEDURE dbo.RearrangeAfterHistSettflag
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.RearrangeAfterHistSettflag    Script Date: 12/16/2003 2:31:22 PM ******/



/****** Object:  Stored Procedure dbo.RearrangeAfterHistSettflag    Script Date: 05/08/2002 12:35:05 PM ******/

/****** Object:  Stored Procedure dbo.RearrangeAfterHistSettflag    Script Date: 01/14/2002 20:32:46 ******/

/****** Object:  Stored Procedure dbo.RearrangeAfterHistSettflag    Script Date: 12/26/2001 1:23:12 PM ******/



/****** Object:  Stored Procedure dbo.RearrangeAfterHistSettflag    Script Date: 5/4/01 5:14:52 PM ******/

/****** Object:  Stored Procedure dbo.RearrangeAfterHistSettflag    Script Date: 4/5/01 6:40:56 PM ******/

/****** Object:  Stored Procedure dbo.RearrangeAfterHistSettflag    Script Date: 3/21/01 12:50:11 PM ******/

/****** Object:  Stored Procedure dbo.RearrangeAfterHistSettflag    Script Date: 20-Mar-01 11:38:52 PM ******/

/****** Object:  Stored Procedure dbo.RearrangeAfterHistSettflag    Script Date: 2/5/01 12:06:15 PM ******/

/****** Object:  Stored Procedure dbo.RearrangeAfterHistSettflag    Script Date: 12/27/00 8:59:17 PM ******/
CREATE  PROCEDURE RearrangeAfterHistSettflag (@Sett_Type varchar(2),@Party Varchar(10),@Scrip varchar(12),@Series varchar(2),@TDate Varchar(10),@Memcode varchar(15),@Tmark varchar(1)) AS 
declare 
  @@trade_no varchar(14),
 @@Pqty numeric(9), 
          @@Sqty numeric(9),
          @@Ltrade_no varchar(14),
          @@Lqty numeric(9), 
  @@Pdiff numeric(9),
	@@TTRADE_NO VARCHAR(14),
	@@TFLAG INT,
	@@TRD CURSOR,
  @@Flag cursor,
  @@loop cursor

 Update History set settflag = (case when s.sell_buy = 1 then 2
      else 3 end )
  from History s,CursorContSaleHist b 
 where b.sett_type = s.sett_type 
 and b.party_code = s.party_code 
  and b.scrip_cd = s.scrip_Cd           
 and b.series = s.series          
 and b.sauda_date = convert(varchar,s.sauda_date,3)
                AND  b.sqty<> 0 and b.pqty <>  0 
                and s.tmark = b.tmark
 and s.partipantcode = b.partipantcode 
 and  s.party_code = @Party and s.scrip_cd = @scrip
                and s.series = @series  and convert(varchar,s.sauda_date,3) = @Tdate   
 and s.Sett_Type = @Sett_type
 and s.partipantcode = @Memcode
 and s.tmark = @Tmark  
 
 
 Update History set settflag = 4 from HISTORY s,CursorContSaleHist b 
 where b.sett_type = s.sett_type 
 and b.party_code = s.party_code 
  and b.scrip_cd = s.scrip_Cd           
 and b.series = s.series          
 and b.sauda_date = convert(varchar,s.sauda_date,3)
                AND  b.sqty = 0 and b.pqty >  0 
                AND s.SELL_BUY = 1
                and s.tmark = b.tmark
 and s.partipantcode = b.partipantcode 
 and  s.party_code = @Party and s.scrip_cd = @scrip
                and s.series = @series  and convert(varchar,s.sauda_date,3) = @Tdate   
 and s.Sett_Type = @Sett_type
 and s.partipantcode = @Memcode
 and s.tmark = @Tmark 
 
 Update History set settflag = 5 from History s,CursorContSaleHist b 
 where b.sett_type = s.sett_type 
 and b.party_code = s.party_code 
  and b.scrip_cd = s.scrip_Cd           
 and b.series = s.series          
 and b.sauda_date = convert(varchar,s.sauda_date,3)
                AND  b.sqty > 0 and b.pqty =  0 
                AND s.SELL_BUY = 2
                and s.tmark = b.tmark
 and s.partipantcode = b.partipantcode 
 and  s.party_code = @Party and s.scrip_cd = @scrip
                and s.series = @series  and convert(varchar,s.sauda_date,3) = @Tdate   
 and s.Sett_Type = @Sett_type
 and s.partipantcode = @Memcode
 and s.tmark = @Tmark 
 /*  apply sett_flag =4 if sell_ buy = 'B' else 5  to all trades where TMark  = 'D' */
 Update History set settflag = 1 
 where  party_code = @Party and scrip_cd = @scrip and series = @series    
 and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type  
 and Partipantcode = @Memcode and TMark = 'D'
 And  tradeqty > 0 
 /*  apply sett_flag = 1 to all trades where client2. tran_cat   = 'DEL' */
 Update History set settflag = 1  FROM History t , CLIENT2 
 where  CLIENT2.PARTY_CODE = t.PARTY_CODE 
 and CLIENT2.tran_cat = 'DEL'  and
 t. party_code = @Party and t.scrip_cd = @scrip and t.series = @series    
 and convert(varchar,t.sauda_date,3) = @Tdate and t.Sett_Type = @Sett_type  
 and t.Partipantcode = @Memcode and t.Tmark = @Tmark
 And  t.tradeqty > 0  
 set @@Flag = cursor for
  select pqty,sqty from CursorContUnEqualSalePurHist
  where convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type
  and Party_code = @Party and Scrip_Cd = @Scrip
  and Series = @Series and Partipantcode = @Memcode and Tmark = @Tmark
  and pqty <> 0 AND  sqty <> 0 and isnull(pqty,0) <> isnull(sqty,0)
  group by pqty,sqty
 
 open @@flag
 fetch next from @@Flag into @@Pqty,@@sqty
 
 While @@fetch_status = 0 
 begin
           if @@Pqty > @@Sqty 
          begin 
     select @@pdiff = @@Pqty - @@Sqty 
     /*set @@Loop  = cursor for 
      select trade_no,tradeqty from history 
      where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 1 
      and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type and tradeqty = @@Pdiff  
     and partipantcode = @Memcode and tmark = @Tmark  
   open @@loop
     fetch next from @@Loop into @@Ltrade_no,@@Lqty     
     if @@fetch_status = 0 
     begin 
       update history set settflag = 4   
       where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 1 
       and trade_no = @@ltrade_no and tradeqty = @@lqty  
       and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type  
       and partipantcode = @Memcode and tmark = @Tmark  
    close @@Loop
    deallocate @@Loop 
     end
     else if @@fetch_status <> 0  
     begin 
       close @@Loop
       deallocate @@Loop  
      */ 
    set @@Loop  = cursor for 
        select trade_no,tradeqty from history 
        where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 1 
        and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type 
    and partipantcode = @Memcode and tmark = @Tmark  
   /* order by marketrate asc, Tradeqty Desc  */
--   order by marketrate Desc
     Order by Sauda_date
       open @@loop
       fetch next from @@Loop into @@Ltrade_no,@@Lqty     
       while @@pdiff > 0       
       begin
         if @@pdiff >= @@Lqty 
         begin
           update history set settflag = 4   
           where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 1 
           and trade_no = @@ltrade_no and tradeqty = @@lqty  
           and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type  
      and partipantcode = @Memcode and tmark = @Tmark  
           select @@pdiff = @@Pdiff - @@Lqty
         end    
         else if @@pdiff < @@Lqty 
         begin
SELECT @@TTRADE_NO = @@ltrade_no
SELECT @@TFLAG = 1 
WHILE @@TFLAG = 1 
BEGIN
SET @@TRD = CURSOR FOR
SELECT TRADE_NO FROM HISTORY  WHERE TRADE_NO = 'B' + @@TTRADE_NO
AND party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 1 
and convert(varchar,sauda_date,3) = @Tdate
OPEN @@TRD
FETCH NEXT FROM @@TRD INTO @@TTRADE_NO
IF @@FETCH_STATUS = 0 
SELECT @@TFLAG = 1
ELSE
SELECT @@TFLAG = 0
CLOSE @@TRD
DEALLOCATE @@TRD	
END
           insert into history select ContractNo,BillNo,'B'+@@TTrade_no,Party_Code,Scrip_Cd,User_id,@@Pdiff,AuctionPart,MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,4,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,Trade_amount,BillFlag,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type,Partipantcode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,TMark,Scheme,Dummy1,Dummy2
           from history where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 1 
           and trade_no = @@ltrade_no and tradeqty = @@lqty  
           and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type  
 
           update history set settflag = 2,Tradeqty = @@Lqty - @@pdiff   
           where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 1 
           and trade_no = @@ltrade_no and tradeqty = @@lqty
           and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type  
      and partipantcode = @Memcode and tmark = @Tmark             
      select @@Pdiff = 0   
         end 
         fetch next from @@Loop into @@Ltrade_no,@@Lqty
       end
       close @@Loop
     end    
 /*  end*/
   else if @@Pqty < @@Sqty
   begin 
     select @@pdiff = @@sqty - @@pqty
     
   /*set @@Loop  = cursor for 
      select trade_no,tradeqty from history 
      where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 2 
      and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type and tradeqty = @@Pdiff  
   and partipantcode = @Memcode and tmark = @Tmark  
     open @@loop
     fetch next from @@Loop into @@Ltrade_no,@@Lqty     
     if @@fetch_status = 0 
     begin
       update history set settflag = 5  
       where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 2 
       and trade_no = @@ltrade_no and tradeqty = @@lqty  
       and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type  
    and partipantcode = @Memcode and tmark = @Tmark  
      
    close @@Loop
       deallocate @@Loop 
     end
     else if @@fetch_status <> 0  
     begin 
       close @@Loop
       deallocate @@Loop  
       */
    set @@Loop  = cursor for 
        select trade_no,tradeqty from history 
        where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 2 
        and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type 
    and partipantcode = @Memcode and tmark = @Tmark  
   /* order by marketrate asc, Tradeqty Desc  */
--   order by marketrate Desc
     Order by Sauda_date
       
    open @@loop
       fetch next from @@Loop into @@Ltrade_no,@@Lqty     
       
    while @@pdiff > 0       
       begin
         if @@pdiff >= @@Lqty 
         begin
           update history set settflag = 5   
           where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 2 
           and trade_no = @@ltrade_no and tradeqty = @@lqty  
           and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type  
      and partipantcode = @Memcode and tmark = @Tmark  
           select @@pdiff = @@Pdiff - @@Lqty
         end    
         else if @@pdiff < @@Lqty 
         begin
SELECT @@TTRADE_NO = @@ltrade_no
SELECT @@TFLAG = 1 
WHILE @@TFLAG = 1 
BEGIN
SET @@TRD = CURSOR FOR
SELECT TRADE_NO FROM HISTORY  WHERE TRADE_NO = 'B' + @@TTRADE_NO
AND party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 2 
and convert(varchar,sauda_date,3) = @Tdate
OPEN @@TRD
FETCH NEXT FROM @@TRD INTO @@TTRADE_NO
IF @@FETCH_STATUS = 0 
SELECT @@TFLAG = 1
ELSE
SELECT @@TFLAG = 0
CLOSE @@TRD
DEALLOCATE @@TRD	
END
           insert into history select ContractNo,BillNo,'B'+@@TTrade_no,Party_Code,Scrip_Cd,User_id,@@Pdiff,AuctionPart,MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,5,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,Trade_amount,BillFlag,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type,Partipantcode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,TMark,Scheme,Dummy1,Dummy2
           from history where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 2 
           and trade_no = @@ltrade_no and tradeqty = @@lqty  
           and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type  
     
           update history set settflag = 3,Tradeqty = @@Lqty - @@pdiff     
           where party_code = @Party and scrip_cd = @scrip and series = @series and sell_buy = 2 
           and trade_no = @@ltrade_no and tradeqty = @@lqty
           and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type   
      and partipantcode = @Memcode and tmark = @Tmark  
           
      select @@Pdiff = 0   
         end 
         fetch next from @@Loop into @@Ltrade_no,@@Lqty
       end
       close @@Loop
     end
   /*end */
   fetch next from @@Flag into @@Pqty,@@sqty
 end 
 close @@Flag
 deallocate @@Flag
/*else
begin
 update history set settflag = 1
 where party_code = @Party and scrip_cd = @scrip and series = @series 
 and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @Sett_type  
 and tradeqty  >  0    
end*/
exec SettBrokUpdateHist @Party,@TDate ,@scrip,@Series

GO
