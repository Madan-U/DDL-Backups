-- Object: PROCEDURE dbo.midware_ledger_inhouse
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE procedure MIDWARE_ledger_inhouse      
as              
              
set nocount on              
----- Account Master              
      
truncate table INHOUSE.dbo.ledger      

/* Fetch Party Ledger */
insert into INHOUSE.dbo.ledger            
select * from account.dbo.ledger with (nolock) 
where vdt >= convert(datetime,convert(varchar(11),getdate()-15)+' 00:00:00')
and cltcode >='A0001' and cltcode <='ZZ9999'   

declare @finDt as datetime,@sDt as datetime
set @finDt = 'Oct 31 '+case when datepart(mm,getdate()) > 3 then convert(varchar(4),datepart(yy,getdate()))
else convert(varchar(4),datepart(yy,getdate())-1) end

if getdate() > @finDt
Begin
	select @sdt=sdtcur from parameter with (nolock)  where sdtcur <= getdate() and ldtcur >= getdate()
end
else
Begin
	select @sdt=sdtcur from parameter with (nolock) where ldtprv = (select  ldtprv from parameter with (nolock)  where sdtcur <= getdate() and ldtcur >= getdate())
end

/* Fetch General Ledger */
insert into INHOUSE.dbo.ledger            
select * from account.dbo.ledger with (nolock) 
where vdt >= @sdt and cltcode >='0' and cltcode <='99999999'   

              
truncate table INHOUSE.dbo.ledger1      
insert into INHOUSE.dbo.ledger1            
select * from account.dbo.ledger1 with (nolock)    
      
set nocount off

GO
