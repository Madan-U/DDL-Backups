-- Object: PROCEDURE dbo.partydrdispsp
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.partydrdispsp    Script Date: 01/04/1980 1:40:38 AM ******/



/****** Object:  Stored Procedure dbo.partydrdispsp    Script Date: 11/28/2001 12:23:45 PM ******/

/****** Object:  Stored Procedure dbo.partydrdispsp    Script Date: 29-Sep-01 8:12:05 PM ******/

/****** Object:  Stored Procedure dbo.partydrdispsp    Script Date: 09/21/2001 2:39:21 AM ******/


/****** Object:  Stored Procedure dbo.partydrdispsp    Script Date: 8/8/01 1:37:31 PM ******/

/****** Object:  Stored Procedure dbo.partydrdispsp    Script Date: 8/7/01 6:03:50 PM ******/

/****** Object:  Stored Procedure dbo.partydrdispsp    Script Date: 07/24/2001 11:35:22 AM ******/
CREATE proc partydrdispsp (@stdate datetime, @endate datetime,@amtlimit money,@flag int)
as 
if @flag = 1
begin
select l1.cltcode, l1.acname,
bal=(select isnull(sum(vamt),0) from ledger l  where drcr='d' and l.cltcode=l1.cltcode and vdt >= @stdate and vdt <= @endate )
    -(select isnull(sum(vamt),0) from ledger l  where drcr='c' and l.cltcode=l1.cltcode and vdt >= @stdate and vdt <= @endate ) 
from ledger l1 where vdt >= @stdate and vdt <= @endate  
and abs((select isnull(sum(vamt),0) from ledger l  where drcr='d' and l.cltcode=l1.cltcode and vdt >= @stdate and vdt <= @endate )
    -(select isnull(sum(vamt),0) from ledger l  where drcr='c' and l.cltcode=l1.cltcode and vdt >= @stdate and vdt <= @endate ) ) > @amtlimit
and l1.cltcode in ( select cltcode from acmast where accat = 4 )
group by  l1.cltcode ,l1.acname 
order by  l1.acname,l1.cltcode 
end
if @flag=2
begin
select l1.cltcode, l1.acname,
bal=(select isnull(sum(vamt),0) from ledger l  where drcr='d' and l.cltcode=l1.cltcode and Edt >= @stdate and Edt <= @endate )
    -(select isnull(sum(vamt),0) from ledger l  where drcr='c' and l.cltcode=l1.cltcode and Edt >= @stdate and edt <= @endate ) 
from ledger l1 where Edt >= @stdate and Edt <= @endate  and abs((select isnull(sum(vamt),0) from ledger l  where drcr='d' and l.cltcode=l1.cltcode and edt >= @stdate and Edt <= @endate )
    -(select isnull(sum(vamt),0) from ledger l  where drcr='c' and l.cltcode=l1.cltcode and Edt >= @stdate and Edt <= @endate ) ) > @amtlimit
and l1.cltcode in ( select cltcode from acmast where accat = 4 )
group by  l1.cltcode ,l1.acname 
order by  l1.acname,l1.cltcode 
end
return

GO
