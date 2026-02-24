-- Object: PROCEDURE dbo.usp_nse_crosstrd
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc usp_nse_crosstrd(@fdate as varchar(11),@tdate as varchar(11))                    
as                    
set nocount on                    
                    
set @fdate=convert(datetime,@fdate,103)                    
set @tdate=convert(datetime,@tdate,103)                    
             
select sauda_Date,sell_buy,trade_no,symbol=scrip_cd,participantcode=partipantcode,                    
party_code,tradeqty,price=marketrate,sauda_Date as sdate   into #t           
from SETTLEMENT with(nolock) where 'a'='b'           
          
insert into #t      
select sauda_Date,sell_buy,trade_no,symbol=scrip_cd,partipantcode,                    
party_code,tradeqty,price=marketrate,sdate=convert(datetime,convert(varchar(11),sauda_date))                       
from SETTLEMENT with(nolock) where sauda_Date >=@fdate and                     
sauda_Date <=@tdate+' 23:59:59' and  sett_Type in ('N','W')                 
union                      
select sauda_Date,sell_buy,trade_no,symbol=scrip_cd,partipantcode,          
party_code,tradeqty,price=marketrate,sdate=convert(datetime,convert(varchar(11),sauda_date))                       
from history with (nolock) where sauda_Date >=@fdate and                     
sauda_Date <=@tdate+' 23:59:59'  and  sett_Type in ('N','W')           
          
select a_sdate=a.sauda_Date,a_tno=a.trade_no,b_tno=b.trade_no,a.symbol,a.participantcode,                    
buy_pcode=a.party_code,buy_qty=a.tradeqty,buy_price=a.price,                    
b_sdate=b.sauda_Date,sell_pcode=b.party_code,sell_qty=b.tradeqty,sell_price=b.price,a.sdate                     
into #file1                     
from                     
(select * from #t where sell_buy=1) a                    
inner join                    
(select * from #t where sell_buy=2 ) b                    
on a.trade_No=b.trade_no and a.party_Code<> b.party_Code                        
and a.symbol=b.symbol          
          
          
drop table #t                    
                    
select b.branch_Cd,b.sub_BRoker,Buyname=b.short_name,sellname=c.short_name,a.* into #file2 from                     
(select  distinct a.*  from #file1 a,#file1 b where a.buy_pcode=b.sell_pcode and a.sell_pcode=b.buy_pcode                    
and a.symbol=b.symbol and  convert(varchar(11),a.a_sdate,103)=convert(varchar(11),b.a_sdate,103))a,                     
client1 b,client1 c  where a.buy_pcode=b.cl_Code  and a.sell_pcode=c.cl_Code                            
                    
drop table #file1            
      
select distinct x.*,Flag='Y',srno=0,Qty_adj=convert(int,0) into #tt1 from #file2 x, #file2 y where x.a_tno=y.b_tno                 
                         
select row_number() over (order by sdate,ltrim(rtrim(symbol)),(case when buy_qty > sell_qty then -sell_qty else buy_qty end)) as rowid,*    
into #tt from #tt1          
          
---------CURSOR START          
select rowid,          
sdate,scrip=ltrim(rtrim(symbol)),         
qty=(case when buy_qty > sell_qty then -sell_qty else buy_qty end),          
price=buy_price,buy_pcode,sell_pcode,flag,srno,Qty_adj,a_tno      
into #bb from #tt  order by sdate,scrip,qty          
          
declare @m_id as int,@m_sdate as datetime, @m_scrip as varchar(500),@m_qty as int, @m_price as money          
declare @m_buy_pcode as varchar(10),@m_sell_pcode as varchar(10),@m_qtyadj as int          
declare @maxid as int,@ctr as int,@NRowid as int,@nqty as int          
select @maxid=max(rowid) from #bb          
set @ctr=1          
          
while (@ctr <=@maxid)          
begin          
          
 if (select count(1) from #bb where rowid=@ctr and srno=0) >= 1          
 begin          
  set @nRowid = 0          
  set @m_qtyadj =0           
  select @m_id=rowid, @m_Sdate=sdate,@m_Scrip=scrip,@m_qty=qty,@m_price=price,@m_buy_pcode=buy_pcode,          
  @m_sell_pcode=sell_pcode from #bb where rowid=@ctr          
          
  select @nrowid=min(rowid) from #bb where           
  sdate=@m_Sdate and scrip=@m_Scrip and qty<=@m_qty and sell_pcode=@m_buy_pcode           
  and buy_pcode=@m_sell_pcode and srno=0          
          
  select @m_QtyAdj=qty from #bb where rowid=@nrowid          
          
  if @nrowid>0          
  begin          
   update #bb set srno=@ctr,Qty_adj=(case when @m_Qty > @m_QtyAdj then @m_QtyAdj else @m_qty end)          
   where rowid in (@m_id,@nrowid)           
  end          
 end          
 set @ctr=@ctr + 1           
end          
          
------ Step 2          
          
select * into #cc from #bb where qty <> qty_adj  order by sdate,scrip,qty          
          
select @maxid=max(rowid) from #cc          
set @ctr=1          
declare @xsrno as int          
          
          
while (@ctr <=@maxid)          
begin          
          
 if (select count(1) from #cc where rowid=@ctr and srno>0) >= 1          
 begin          
  set @nRowid = 0          
  set @m_qtyadj =0           
  set @xsrno = 0          
  select @m_id=rowid,@xsrno=srno, @m_Sdate=sdate,@m_Scrip=scrip,@m_qty=qty-Qty_adj,@m_price=price,@m_buy_pcode=buy_pcode,          
  @m_sell_pcode=sell_pcode,@m_qtyadj=qty_adj from #cc where rowid=@ctr          
          
  select @nrowid=min(rowid) from #cc where           
  sdate=@m_Sdate and scrip=@m_Scrip and qty<=@m_qty and sell_pcode=@m_buy_pcode           
  and buy_pcode=@m_sell_pcode and srno=0          
          
  select @m_QtyAdj=qty from #cc where rowid=@nrowid          
          
  if @nrowid>0          
  begin          
   update #cc set srno=@xsrno,Qty_adj=Qty_adj+(case when @m_Qty > @m_QtyAdj then @m_QtyAdj else @m_qty end)          
   where rowid in (@m_id,@nrowid)           
  end          
 end          
 set @ctr=@ctr + 1           
end          
          
update #bb set #bb.srno=a.srno,#bb.Qty_adj=a.Qty_adj from #cc a where #bb.rowid=a.rowid          
update #tt set #tt.srno=a.srno,#tt.Qty_adj=a.Qty_adj from #bb a where #tt.rowid=a.rowid          
          
select a.*,SqurUpAmt=abs(b.SqurUpAmt) into #final from #tt a left outer join           
(select Srno,SqurUpAmt=sum((case when srno=rowid then Qty_adj*-1 else Qty_Adj end)*Sell_price) from #tt           
group by srno) b on a.srno=b.srno          
where Qty_Adj <> 0          
order by srno          
        
delete from #final where Qty_adj<0    
  
delete from angel_cross  where sauda_date>=@fdate and sauda_date<=@tdate+' 23:59:59' 

insert into angel_cross        
select branch_Cd,sub_BRoker,Buyname,sellname,a_sdate,a_tno,symbol,        
participantcode,buy_pcode,buy_qty,buy_price,b_sdate,sell_pcode,        
sell_qty,sell_price,sdate,srno,Qty_adj,SqurUpAmt from #final

GO
