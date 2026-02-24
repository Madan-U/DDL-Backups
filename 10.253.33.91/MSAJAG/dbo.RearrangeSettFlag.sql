-- Object: PROCEDURE dbo.RearrangeSettFlag
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.RearrangeSettFlag    Script Date: 12/16/2003 2:31:22 PM ******/



/****** Object:  Stored Procedure dbo.RearrangeSettFlag    Script Date: 05/08/2002 12:35:05 PM ******/

/****** Object:  Stored Procedure dbo.RearrangeSettFlag    Script Date: 01/14/2002 20:32:47 ******/

/****** Object:  Stored Procedure dbo.RearrangeSettFlag    Script Date: 12/26/2001 1:23:12 PM ******/
CREATE   PROCEDURE RearrangeSettFlag (@TDate Varchar(10)) AS 

declare 
 @@Party Varchar(10),
 @@Scrip varchar(12),
 @@Series varchar(2), 	
 @@Tmark varchar(1),
 @@Memcode varchar(15),
 @@Sett_Type varchar(2),
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
 
  Update Settlement set settflag = (case when sell_buy = 1 then 2
      else 3 end )
where convert(varchar,sauda_date,3) = @Tdate and Party_Code in ( Select Distinct Party_code From TradeCon 
	Where TradeCon.Party_code = Settlement.Party_code and Tradecon.Scrip_Cd = Settlement.Scrip_Cd ) 	  
 
 Update Settlement set settflag = 4 from Settlement s,CursorContTSaleTemp b 
 where b.sett_type = s.sett_type 
 and b.party_code = s.party_code 
  and b.scrip_cd = s.scrip_Cd           
 and b.series = s.series          
 and b.sauda_date = convert(varchar,s.sauda_date,3)
                AND  b.sqty = 0 and b.pqty >  0 
                AND s.SELL_BUY = 1
                and s.tmark = b.tmark
 and s.partipantcode = b.partipantcode 
 and convert(varchar,s.sauda_date,3) = @Tdate   
 and s.Sett_Type = @@Sett_Type
 and s.partipantcode = @@Memcode
 and s.tmark = @@Tmark 
 
 Update Settlement set settflag = 5 from Settlement s,CursorContTSaleTemp b 
 where b.sett_type = s.sett_type 
 and b.party_code = s.party_code 
  and b.scrip_cd = s.scrip_Cd           
 and b.series = s.series          
 and b.sauda_date = convert(varchar,s.sauda_date,3)
 AND  b.sqty > 0 and b.pqty =  0 
 AND s.SELL_BUY = 2
 and s.tmark = b.tmark
 and s.partipantcode = b.partipantcode 
  and convert(varchar,s.sauda_date,3) = @Tdate   
 /*  apply sett_flag =4 if sell_ buy = 'B' else 5  to all trades where TMark  = 'D' */
 Update settlement set settflag = 1 
 where convert(varchar,sauda_date,3) = @Tdate and TMark = 'D'
 And  tradeqty > 0 
 /*  apply sett_flag = 1 to all trades where client2. tran_cat   = 'DEL' */
 Update settlement set settflag = 1  FROM settlement t , CLIENT2 
 where  CLIENT2.PARTY_CODE = t.PARTY_CODE 
 and CLIENT2.tran_cat = 'DEL' and convert(varchar,t.sauda_date,3) = @Tdate 
 And  t.tradeqty > 0  
 set @@Flag = cursor for
  select Sett_type,Party_code,Scrip_Cd,Series,TMark,Partipantcode,pqty,sqty from CursorContUnEqualSalePurTemp
  where convert(varchar,sauda_date,3) = @Tdate 
  and pqty <> 0 AND  sqty <> 0 and isnull(pqty,0) <> isnull(sqty,0)
  group by Sett_type,Party_code,Scrip_Cd,Series,TMark,Partipantcode,pqty,sqty 
open @@flag

fetch next from @@Flag into @@Sett_Type,@@Party,@@Scrip,@@Series,@@Tmark,@@Memcode,@@Pqty,@@sqty
if @@fetch_status = 0  
 begin
  While @@fetch_status = 0 
  begin
    if @@Sqty = 0
    update settlement set Settflag = 4 
    where party_code = @@Party and scrip_cd = @@Scrip and series = @@Series and sell_buy = 1 
    and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @@Sett_Type    
    and Partipantcode = @@Memcode and Tmark = @@Tmark
    else if @@Pqty = 0
    update settlement set Settflag = 5 
    where party_code = @@Party and scrip_cd = @@Scrip and series = @@Series and sell_buy = 2
    and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @@Sett_Type    
    and Partipantcode = @@Memcode and Tmark = @@Tmark
    else if @@Pqty = @@Sqty 
    update settlement set Settflag = (Case When Sell_Buy = 1 then 2 else 3 end ) 
    where party_code = @@Party and scrip_cd = @@Scrip and series = @@Series 
    and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @@Sett_Type    
    and Partipantcode = @@Memcode and Tmark = @@Tmark
     else if @@Pqty > @@Sqty 
                    begin 
      select @@pdiff = @@Pqty - @@Sqty 
      /*set @@Loop  = cursor for 
        select trade_no,tradeqty from settlement 
        where party_code = @@Party and scrip_cd = @@Scrip and series = @@Series and sell_buy = 1 
        and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @@Sett_Type and tradeqty = @@Pdiff  
        and Partipantcode = @@Memcode and Tmark = @@Tmark
      open @@loop
      fetch next from @@Loop into @@Ltrade_no,@@Lqty     
      if @@fetch_status = 0 
      begin 
        update settlement set settflag = 4   
        where party_code = @@Party and scrip_cd = @@Scrip and series = @@Series and sell_buy = 1 
        and trade_no = @@ltrade_no and tradeqty = @@lqty  
        and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @@Sett_Type  
        and Partipantcode = @@Memcode and Tmark = @@Tmark
       close @@Loop
       deallocate @@Loop 
         end
         else if @@fetch_status <> 0  
        begin 
        close @@Loop
        deallocate @@Loop  
      */
        set @@Loop  = cursor for 
      select trade_no,tradeqty from settlement 
         where party_code = @@Party and scrip_cd = @@Scrip and series = @@Series and sell_buy = 1 
         and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @@Sett_Type 
                     and Partipantcode = @@Memcode and Tmark = @@Tmark
     /* order by marketrate asc, Tradeqty Desc  */
--      order by marketrate Desc
        Order by Sauda_date
        open @@loop
       fetch next from @@Loop into @@Ltrade_no,@@Lqty     
       while @@pdiff > 0       
       begin
      if @@pdiff >= @@Lqty  
                                                                  begin
            update settlement set settflag = 4   
       where party_code = @@Party and scrip_cd = @@Scrip and series = @@Series and sell_buy = 1 
            and trade_no = @@ltrade_no and tradeqty = @@lqty  
       and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @@Sett_Type  
       and Partipantcode = @@Memcode and Tmark = @@Tmark
            select @@pdiff = @@Pdiff - @@Lqty
       end    
                     else if @@pdiff < @@Lqty 
          begin
SELECT @@TTRADE_NO = @@ltrade_no
SELECT @@TFLAG = 1 
WHILE @@TFLAG = 1 
BEGIN
SET @@TRD = CURSOR FOR
SELECT TRADE_NO FROM SETTLEMENT WHERE TRADE_NO = 'B' + @@TTRADE_NO
AND party_code = @@Party and scrip_cd = @@scrip and series = @@series and sell_buy = 1 
AND PartiPantCode = @@Memcode	 and convert(varchar,sauda_date,3) = @Tdate
OPEN @@TRD
FETCH NEXT FROM @@TRD INTO @@TTRADE_NO
IF @@FETCH_STATUS = 0 
SELECT @@TFLAG = 1
ELSE
SELECT @@TFLAG = 0
CLOSE @@TRD
DEALLOCATE @@TRD			
END	
       insert into settlement select ContractNo,BillNo,'B'+@@TTrade_no,Party_Code,Scrip_Cd,User_id,@@Pdiff,AuctionPart,MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,4,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,@@Pdiff*MarketRate,BillFlag,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type,PartiPantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,Tmark,Scheme,Dummy1,Dummy2
           from Settlement where party_code = @@Party and scrip_cd = @@Scrip and series = @@Series and sell_buy = 1 
            and trade_no = @@ltrade_no and tradeqty = @@lqty  
            and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @@Sett_Type
       and Partipantcode = @@Memcode and Tmark = @@Tmark
 
                          update settlement set settflag = 2,Tradeqty = @@Lqty - @@pdiff,Trade_Amount = (@@Lqty - @@pdiff)*MarketRate    
                         where party_code = @@Party and scrip_cd = @@Scrip and series = @@Series and sell_buy = 1 
                          and trade_no = @@ltrade_no and tradeqty = @@lqty
                        and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @@Sett_Type  
                     and Partipantcode = @@Memcode and Tmark = @@Tmark
                          select @@Pdiff = 0   
      end 
          fetch next from @@Loop into @@Ltrade_no,@@Lqty
        end
        close @@Loop
/*        end    */
    end
   else if @@Pqty < @@Sqty
   begin 
      select @@pdiff = @@sqty - @@pqty
     /* set @@Loop  = cursor for 
      select trade_no,tradeqty from settlement 
      where party_code = @@Party and scrip_cd = @@Scrip and series = @@Series and sell_buy = 2 
       and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @@Sett_Type and tradeqty = @@Pdiff  
     and Partipantcode = @@Memcode and Tmark = @@Tmark
      open @@loop
       fetch next from @@Loop into @@Ltrade_no,@@Lqty     
      if @@fetch_status = 0 
     begin
       update settlement set settflag = 5  
         where party_code = @@Party and scrip_cd = @@Scrip and series = @@Series and sell_buy = 2 
        and trade_no = @@ltrade_no and tradeqty = @@lqty  
       and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @@Sett_Type  
     and Partipantcode = @@Memcode and Tmark = @@Tmark
      close @@Loop
      deallocate @@Loop 
      end
    else if @@fetch_status <> 0  
     begin 
     close @@Loop
        deallocate @@Loop  */
        set @@Loop  = cursor for 
         select trade_no,tradeqty from settlement 
         where party_code = @@Party and scrip_cd = @@Scrip and series = @@Series and sell_buy = 2 
         and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @@Sett_Type 
     and Partipantcode = @@Memcode and Tmark = @@Tmark
    /* order by marketrate asc, Tradeqty Desc  */
--    order by marketrate Desc
        Order by Sauda_date
        open @@loop
        fetch next from @@Loop into @@Ltrade_no,@@Lqty     
        while @@pdiff > 0       
        begin
      if @@pdiff >= @@Lqty 
      begin
       update Settlement set settflag = 5   
           where party_code = @@Party and scrip_cd = @@Scrip and series = @@Series and sell_buy = 2 
           and trade_no = @@ltrade_no and tradeqty = @@lqty  
          and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @@Sett_Type  
       and Partipantcode = @@Memcode and Tmark = @@Tmark
            select @@pdiff = @@Pdiff - @@Lqty
          end    
          else if @@pdiff < @@Lqty 
          begin 
SELECT @@TTRADE_NO = @@ltrade_no
SELECT @@TFLAG = 1 
WHILE @@TFLAG = 1 
BEGIN
SET @@TRD = CURSOR FOR
SELECT TRADE_NO FROM SETTLEMENT WHERE TRADE_NO = 'B' + @@TTRADE_NO
AND party_code = @@Party and scrip_cd = @@scrip and series = @@series and sell_buy = 2 
AND PartiPantCode = @@Memcode	 and convert(varchar,sauda_date,3) = @Tdate
OPEN @@TRD
FETCH NEXT FROM @@TRD INTO @@TTRADE_NO
IF @@FETCH_STATUS = 0 
SELECT @@TFLAG = 1
ELSE
SELECT @@TFLAG = 0
CLOSE @@TRD
DEALLOCATE @@TRD			
END	
       insert into settlement select ContractNo,BillNo,'B'+@@TTrade_no,Party_Code,Scrip_Cd,User_id,@@Pdiff,AuctionPart,MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,5,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,@@Pdiff*MarketRate,BillFlag,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type,PartiPantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,Tmark,Scheme,Dummy1,Dummy2
            from Settlement where party_code = @@Party and scrip_cd = @@Scrip and series = @@Series and sell_buy = 2 
            and trade_no = @@ltrade_no and tradeqty = @@lqty  
            and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @@Sett_Type  
       and Partipantcode = @@Memcode and Tmark = @@Tmark
       
            update settlement set settflag = 3,Tradeqty = @@Lqty - @@pdiff,Trade_Amount = (@@Lqty - @@pdiff) * MarketRate     
           where party_code = @@Party and scrip_cd = @@Scrip and series = @@Series and sell_buy = 2 
            and trade_no = @@ltrade_no and tradeqty = @@lqty
            and convert(varchar,sauda_date,3) = @Tdate and Sett_Type = @@Sett_Type   
       and Partipantcode = @@Memcode and Tmark = @@Tmark
                select @@Pdiff = 0   
          end 
          fetch next from @@Loop into @@Ltrade_no,@@Lqty
        end
        close @@Loop
     /* end */
    end 
    fetch next from @@Flag into @@Sett_Type,@@Party,@@Scrip,@@Series,@@Tmark,@@Memcode,@@Pqty,@@sqty
  end 
  close @@Flag
  deallocate @@Flag
 end
exec SettUpdate @TDate

GO
