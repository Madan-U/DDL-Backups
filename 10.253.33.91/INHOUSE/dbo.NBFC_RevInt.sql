-- Object: PROCEDURE dbo.NBFC_RevInt
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

CREATE Procedure [dbo].[NBFC_RevInt] (@monthflag  as char(1))
as

set nocount on

/* 
@monthflag = "P" for previous Month and "C" for current month.
*/


declare @FPM as varchar(25),@LPM as varchar(25),@FPPM as varchar(25),@Mmnth as int, @Myear as int

if @monthflag='P'
BEGIN
	SELECT	
	@FPM=convert(varchar(11),DATEADD(MONTH, DATEDIFF(MONTH, '19000201', GETDATE()), '19000101'))+' 00:00:00', 
	@LPM=convert(varchar(11),DATEADD(MONTH, DATEDIFF(MONTH, '19000101', GETDATE()), '18991231'))+' 23:59:59'
END
ELSE
BEGIN
	SELECT	
	@FPM=convert(varchar(11),convert(datetime,convert(varchar(2),datepart(m,getdate()))+'/01/'+convert(varchar(4),datepart(yy,getdate()))))+' 00:00:00',
	@LPM=convert(varchar(11),getdate())+' 23:59:59'
END


select @Mmnth=datepart(m,convert(datetime,@fpm))
select @Myear=datepart(yy,convert(datetime,@fpm))
if @Mmnth=1 
begin
	set @Mmnth=12
	set @Myear=@Myear-1
end
else
begin
	set @Mmnth=@Mmnth-1
end

select @FPPM=convert(datetime,convert(varchar(2),@Mmnth)+'/01/'+convert(varchar(4),@Myear))

select * into #file1 from 
(select * from account.dbo.LEDGER with (nolock) where vdt>=@FPPM and vdt <=@LPM and vtyp=2) a join 
(select cl_code from msajag.dbo.client1 with (nolock) where cl_type in ('NBF','TMF') ) b
on a.cltcode=b.cl_code 

select b.*,a.relamt,reldt,ddno  into #file2
from account.dbo.ledger1 a with (nolock) join #file1 b on a.vno=b.vno and a.vtyp=b.vtyp and a.lno=b.lno 


truncate table NBFC_RevData
insert into NBFC_RevData(segment,cltcode,vdt,vamt,reldt,int_days,InstNo,Vno)
select segment='NSECM',cltcode,vdt,vamt,reldt,datediff(d,vdt,reldt) as int_days,ddno,vno
from #file2 
where converT(varchar(10),vdt,103) <> converT(varchar(10),reldt,103) and reldt >= @FPM and vdt <=@LPM

/*
select a.segment,a.cltcode,a.vamt,a.vdt,a.reldt,a.int_days,b.IntRate,IntAmt=convert(money,(((vamt*IntRate)/100)/365)*int_days) from
(
select segment='NSECM',cltcode,vdt,vamt,reldt,datediff(d,vdt,reldt) as int_days
from #file2 
where converT(varchar(10),vdt,103) <> converT(varchar(10),reldt,103) and reldt >= @FPM and vdt <=@LPM
) a join
(select client_code,intrateequity as IntRate,backofficecode from ABVSNBFCARC.LiveAngel_fundingsystem_new.dbo.Angel_client_intRate) b
on a.cltcode=b.backofficecode
*/
set nocount off

GO
