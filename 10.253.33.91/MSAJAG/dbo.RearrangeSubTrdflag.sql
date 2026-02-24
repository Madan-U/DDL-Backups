-- Object: PROCEDURE dbo.RearrangeSubTrdflag
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.RearrangeSubTrdflag    Script Date: 5/4/01 5:14:52 PM ******/

/****** Object:  Stored Procedure dbo.RearrangeSubTrdflag    Script Date: 4/5/01 6:40:56 PM ******/

/****** Object:  Stored Procedure dbo.RearrangeSubTrdflag    Script Date: 3/21/01 12:50:11 PM ******/

/****** Object:  Stored Procedure dbo.RearrangeSubTrdflag    Script Date: 20-Mar-01 11:38:53 PM ******/

/****** Object:  Stored Procedure dbo.RearrangeSubTrdflag    Script Date: 2/5/01 12:06:15 PM ******/

/****** Object:  Stored Procedure dbo.RearrangeSubTrdflag    Script Date: 12/27/00 8:59:18 PM ******/

CREATE PROCEDURE RearrangeSubTrdflag AS 
declare        
 @@PartiPantCode varchar(15),
        @@Scrip varchar(12),  
        @@series varchar(2),
        @@Pqty numeric(9), 
        @@Sqty numeric(9),
        @@Ltrade_no varchar(14),
        @@Lqty numeric(9), 
 @@Pdiff numeric(9),
 @@SAuda_Date varchar(11),
 @@User_Id varchar(10),
 @@MarketType int, 
@@TTRADE_NO VARCHAR(14),
@@TFLAG INT,
@@TRD CURSOR,
 @@Flag cursor,
 @@loop cursor
begin         
 update TrdBackUp set settflag = ( Case when sell_buy = 1 then 2 else 3 end )
 update TrdBackUp set settflag = 2 from TrdBackUp,CursorSubUnEqualSalePur b 
 where b.markettype = TrdBackUp.markettype
 and b.scrip_cd = TrdBackUp.scrip_Cd           
         and b.series = TrdBackUp.series          
       and b.sqty  <> 0 and b.pqty <>  0 
 and TrdBackUp.Sauda_Date like B.Sauda_date +'%'
                 and TrdBackUp.SELL_BUY = 1
         update TrdBackUp set settflag = 3 from TrdBackUp,CursorSubUnEqualSalePur b 
        where b.markettype = TrdBackUp.markettype
      and b.series = TrdBackUp.series          
     and b.scrip_cd = TrdBackUp.scrip_Cd
     and b.sqty  <> 0 and b.pqty <>  0                   
 and TrdBackUp.Sauda_Date like B.Sauda_date +'%'
        and TrdBackUp.sell_buy = 2 
        update TrdBackUp set settflag = 4 from TrdBackUp,CursorSubUnEqualSalePur b 
        where b.scrip_cd = TrdBackUp.scrip_Cd
        and b.series = TrdBackUp.series          
        and b.sqty = 0 and b.pqty > 0
        and TrdBackUp.Sauda_Date like B.Sauda_date +'%'
        and TrdBackUp.sell_buy = 1
        update TrdBackUp set settflag = 5 from TrdBackUp,CursorSubUnEqualSalePur b 
        where b.scrip_cd = TrdBackUp.scrip_Cd
        and b.series = TrdBackUp.series          
        and b.sqty > 0 and b.pqty = 0
        and b.markettype = TrdBackUp.markettype
       and TrdBackUp.Sauda_Date like B.Sauda_date +'%'
        and TrdBackUp.sell_buy = 2
 
 set @@Flag =  cursor for
               select scrip_cd,series,pqty,sqty,markettype,PartipantCode,Sauda_Date from CursorSubUnEqualSalePur  
               group by scrip_cd,series,markettype,PartiPantCode,pqty,sqty,Sauda_date
 open @@Flag 
 fetch next from @@Flag into @@scrip,@@series,@@Pqty,@@sqty,@@markettype,@@PartiPantCode,@@Sauda_date
 while @@fetch_status = 0 
 begin 
               if @@Pqty > @@Sqty 
               begin 
   select @@pdiff = @@Pqty - @@Sqty
  /* set @@Loop  = cursor for 
    select trade_no,tradeqty from TrdBackUp 
    where scrip_cd = @@scrip and series = @@series and sell_buy = 1 
     and markettype = @@markettype and PartiPantCode = @@PartiPantCode  and tradeqty = @@Pdiff 
    and Sauda_Date like @@Sauda_date +'%'
   open @@loop
   fetch next from @@Loop into @@Ltrade_no,@@Lqty     
   if @@fetch_status = 0 
   begin
    update TrdBackUp set settflag = 4   
    where scrip_cd = @@scrip and series = @@series and sell_buy = 1 
    and trade_no = @@ltrade_no and PartiPantCode = @@PartiPantCode  and tradeqty = @@lqty  
    and markettype = @@markettype and Sauda_Date like @@Sauda_date +'%'
    close @@Loop
    deallocate @@Loop 
   end
   else if @@fetch_status <> 0  
   begin 
    close @@Loop
    deallocate @@Loop 
*/
    set @@Loop  = cursor for 
     select trade_no,tradeqty from TrdBackUp 
     where scrip_cd = @@scrip and series = @@series and sell_buy = 1 
      and markettype = @@markettype and PartiPantCode = @@PartiPantCode  and tradeqty > 0 
     and Sauda_Date like @@Sauda_date +'%' 
     /* order by marketrate asc, Tradeqty Desc  */
    order by marketrate Desc
    open @@loop
    fetch next from @@Loop into @@Ltrade_no,@@Lqty     
    while @@pdiff > 0       
    begin
     if @@pdiff >= @@Lqty 
     begin
      update TrdBackUp set settflag = 4   
      where scrip_cd = @@scrip and series = @@series and sell_buy = 1 
      and trade_no = @@ltrade_no and tradeqty = @@lqty and Sauda_Date like @@Sauda_date +'%'  
       and markettype = @@markettype and PartiPantCode = @@PartiPantCode  
      select @@pdiff = @@Pdiff - @@Lqty
     end    
     else if @@pdiff < @@Lqty 
     begin
						SELECT @@TTRADE_NO = @@ltrade_no
						SELECT @@TFLAG = 1 
						WHILE @@TFLAG = 1 
						BEGIN
							SET @@TRD = CURSOR FOR
							SELECT TRADE_NO FROM TRDBACKUP WHERE TRADE_NO = 'A' + @@TTRADE_NO
							AND scrip_cd = @@scrip and series = @@series and sell_buy = 1 
							AND PartiPantCode = @@PartiPantCode and markettype = @@markettype  and Sauda_Date like @@Sauda_date +'%'	
							OPEN @@TRD
							FETCH NEXT FROM @@TRD INTO @@TTRADE_NO
							IF @@FETCH_STATUS = 0 
								SELECT @@TFLAG = 1
							ELSE
								SELECT @@TFLAG = 0
							CLOSE @@TRD
							DEALLOCATE @@TRD			
						END	
      insert into TrdBackUp (ContractNo,BILLNO,Trade_no, Party_Code, Scrip_Cd,user_id ,Tradeqty, AuctionPart, markettype,series, order_no, MarketRate, Sauda_date,sell_buy,  settflag,BillFlag, sett_no,line_no,Table_no,PartiPantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,TMark,Scheme,Dummy1,Dummy2 ) 
                    select 0,0,'A'+Trade_no,Party_Code,Scrip_Cd,user_id ,@@pdiff, AuctionPart, markettype,series, order_no, MarketRate, Sauda_date,sell_buy,4,0, sett_no,line_no,Table_no ,PartiPantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,TMark,Scheme,Dummy1,Dummy2
      from TrdBackUp where scrip_cd = @@scrip and series = @@series and sell_buy = 1 
      and trade_no = @@ltrade_no and tradeqty = @@lqty and PartiPantCode = @@PartiPantCode   
       and markettype = @@markettype and Sauda_Date like @@Sauda_date +'%'
 
      update TrdBackUp set settflag = 2,Tradeqty = @@Lqty - @@pdiff    
      where scrip_cd = @@scrip and series = @@series and sell_buy = 1 
      and trade_no = @@ltrade_no and tradeqty = @@lqty and PartiPantCode = @@PartiPantCode  
       and markettype = @@markettype and Sauda_Date like @@Sauda_date +'%'
      select @@Pdiff = 0   
     end 
     if @@pdiff = 0 
      break
     fetch next from @@Loop into @@Ltrade_no,@@Lqty
    end 
    close @@Loop
    deallocate @@Loop 
 /*             end */
   /*fetch next from @@Flag into @@party,@@scrip,@@series,@@Pqty,@@sqty,@@markettype */
  end
 
  else if @@Pqty < @@Sqty
  begin 
   select @@pdiff = @@sqty - @@pqty
 /*  set @@Loop  = cursor for 
    select trade_no,tradeqty from TrdBackUp 
    where scrip_cd = @@scrip and series = @@series and sell_buy = 2 and Sauda_Date like @@Sauda_date +'%'
     and markettype = @@markettype and tradeqty = @@Pdiff and PartiPantCode = @@PartiPantCode  
   open @@loop
   fetch next from @@Loop into @@Ltrade_no,@@Lqty     
   if @@fetch_status = 0 
   begin
    update TrdBackUp set settflag = 5   
    where scrip_cd = @@scrip and series = @@series and sell_buy = 2 
    and trade_no = @@ltrade_no and PartiPantCode = @@PartiPantCode  and tradeqty = @@lqty  
     and markettype = @@markettype and Sauda_Date like @@Sauda_date +'%'
    close @@Loop
    deallocate @@Loop
   end  
   else if @@fetch_status <> 0 
   begin
    close @@Loop
    deallocate @@Loop 
*/
    set @@Loop  = cursor for 
    select trade_no,tradeqty from TrdBackUp 
    where scrip_cd = @@scrip and series = @@series and sell_buy = 2 
     and markettype = @@markettype And tradeqty > 0 and PartiPantCode = @@PartiPantCode  
    and Sauda_Date like @@Sauda_date +'%' 
  /* order by marketrate asc, Tradeqty Desc  */
    order by marketrate Desc
    open @@loop
    fetch next from @@Loop into @@Ltrade_no,@@Lqty      
    while @@pdiff > 0       
    begin
     if @@pdiff >= @@Lqty 
     begin
      update TrdBackUp set settflag = 5   
      where scrip_cd = @@scrip and series = @@series and sell_buy = 2 
      and trade_no = @@ltrade_no and tradeqty = @@lqty and Sauda_Date like @@Sauda_date +'%'  
       and markettype = @@markettype and PartiPantCode = @@PartiPantCode  
      select @@pdiff = @@Pdiff - @@Lqty
     end    
     else if @@pdiff < @@Lqty 
     begin
						SELECT @@TTRADE_NO = @@ltrade_no
						SELECT @@TFLAG = 1 
						WHILE @@TFLAG = 1 
						BEGIN
							SET @@TRD = CURSOR FOR
							SELECT TRADE_NO FROM TRDBACKUP WHERE TRADE_NO = 'A' + @@TTRADE_NO
							AND scrip_cd = @@scrip and series = @@series and sell_buy = 2 
							AND PartiPantCode = @@PartiPantCode and markettype = @@markettype  and Sauda_Date like @@Sauda_date +'%'	
							OPEN @@TRD
							FETCH NEXT FROM @@TRD INTO @@TTRADE_NO
							IF @@FETCH_STATUS = 0 
								SELECT @@TFLAG = 1
							ELSE
								SELECT @@TFLAG = 0
							CLOSE @@TRD
							DEALLOCATE @@TRD			
						END	
      insert into TrdBackUp (ContractNo,BILLNO,Trade_no, Party_Code, Scrip_Cd,user_id ,Tradeqty, AuctionPart, markettype,series, order_no, MarketRate, Sauda_date,sell_buy,  settflag,BillFlag, sett_no,line_no,Table_no,PartiPantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,TMark,Scheme,Dummy1,Dummy2 ) 
                    select 0,0,'A'+Trade_no,Party_Code,Scrip_Cd,user_id ,@@pdiff, AuctionPart, markettype,series, order_no, MarketRate, Sauda_date,sell_buy,5,0, sett_no,line_no,Table_no ,PartiPantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,TMark,Scheme,Dummy1,Dummy2
      from TrdBackUp where scrip_cd = @@scrip and series = @@series and sell_buy = 2 
      and trade_no = @@ltrade_no and tradeqty = @@lqty and PartiPantCode = @@PartiPantCode  
       and markettype = @@markettype and Sauda_Date like @@Sauda_date +'%'
  
      update TrdBackUp set settflag = 3,Tradeqty = @@Lqty - @@pdiff    
      where scrip_cd = @@scrip and series = @@series and sell_buy = 2 
      and trade_no = @@ltrade_no and tradeqty = @@lqty and PartiPantCode = @@PartiPantCode  
       and markettype = @@markettype and Sauda_Date like @@Sauda_date +'%'
      select @@Pdiff = 0   
     end 
     if @@pdiff = 0 
      break
     fetch next from @@Loop into @@Ltrade_no,@@Lqty
    end 
    close @@Loop
    deallocate @@Loop
  /* end*/
  end
  fetch next from @@Flag into @@scrip,@@series,@@Pqty,@@sqty,@@markettype,@@PartiPantCode,@@Sauda_Date
 end 
 close @@Flag
 deallocate @@Flag

set @@Flag =  cursor for
	select left(Convert(Varchar,Sauda_date,109),11) from trade
open @@Flag
fetch next from @@flag into @@sauda_date

exec subbrokerconfirmview @@sauda_date
close @@flag
end

GO
