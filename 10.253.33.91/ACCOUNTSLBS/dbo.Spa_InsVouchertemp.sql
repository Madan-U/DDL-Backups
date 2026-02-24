-- Object: PROCEDURE dbo.Spa_InsVouchertemp
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

/****** Object:  Stored Procedure dbo.Spa_InsVouchertemp    Script Date: 06/24/2004 8:32:35 PM ******/  
  
/****** Object:  Stored Procedure dbo.Spa_InsVouchertemp    Script Date: 05/10/2004 5:29:35 PM ******/  
  
/****** Object:  Stored Procedure dbo.Spa_InsVouchertemp    Script Date: 02/18/2003 10:25:07 AM ******/  
/****** Object:  Stored Procedure dbo.Spa_InsVouchertemp    Script Date: 01/27/2003 9:57:08 PM ******/  
CREATE PROCEDURE Spa_InsVouchertemp  
 @vno varchar(20),  
 @vtype varchar(2),  
 @booktype varchar(2),  
 @billflag char(1),  
 @costflag char(1),  
 @sid varchar(20)  
 AS  
declare @@tmpcat varchar(50),  
@@tmplno varchar(3),  
@@tmpcost varchar(50),  
@@tmpcostname varchar(50),  
@@tmpexists integer,  
@@tmpcltcode varchar(16),  
@@CNo Cursor  
  
if @billflag=1  
begin  
insert into tempbilldetails   
/*  
 select distinct Exchange,m.Party_code,Sett_no,Sett_type,m.drcr,b.amount,balamt,payamout= m.amount,sessionid=@sid,m.llno,m.lno,  
 b.date,m.description,billbooktype=b.booktype,billvtype=b.vtype,m.lbooktype,m.lvtype,b.vno   
 from matchdetails m left outer join billmatch b on m.vno=b.vno and m.vtype=b.vtype and m.booktype= b.booktype and   
 m.lno=b.lno and b.vtype=15 where m.lvno = @vno and m.lvtype = @vtype and m.lBookType = @booktype    
 and m.description not like 'Advances%' */  
  
  
 select distinct Exchange,m.Party_code,Sett_no,Sett_type,m.drcr,b.amount,balamt,payamout= m.amount,sessionid=@sid,m.llno,m.lno,  
 b.date,m.description,billbooktype=b.booktype,billvtype=b.vtype,m.lbooktype,m.lvtype,b.vno   
 from billmatch b left outer join matchdetails m on b.vno=m.vno and b.vtype=m.vtype and b.booktype= m.booktype and   
 b.lno=m.lno and b.party_code = m.party_code and b.vtype=15  
 where m.lvno = @vno and m.lvtype = @vtype and m.lBookType = @booktype  and m.description not like 'Advances%'  
end  
  
  
If @costflag=1  
begin  
 insert into templedger2 (vtype,vno,lno,drcr,paidamt,costcode,BookType,sessionid,party_code)  
 select distinct vtype,vno,lno,drcr,camt,costcode,BookType,sessionid=@sid,cltcode  
 from ledger2  where vno= @vno and vtype=@vtype and booktype= @booktype  
  
  
 Set @@Cno = Cursor For   
 select distinct lno,costcode,cltcode  
 from ledger2  where vno= @vno  and vtype=@vtype and booktype= @booktype  
 Open @@CNo   
 Fetch Next from @@CNo into @@tmplno,@@tmpcost,@@tmpcltcode  
 While @@Fetch_Status = 0   
 Begin  
  select @@tmpexists = (select count(*) as cnt from branchaccounts where BrControlAc =  @@tmpcltcode)  
  if @@tmpexists = 0  
  begin  
   select @@tmpcat = (select distinct top 1 c.category from category c, costmast m   
   where c.catcode = m.catcode and m.costcode=@@tmpcost)  
   update templedger2   set category= @@tmpcat where costcode = @@tmpcost and sessionid = @sid and vtype=@vtype and booktype =@booktype and lno = @@tmplno and  party_code =@@tmpcltcode  
  end   
  else   
  begin  
   select @@tmpcat = 'BRANCH'  
   update templedger2   set category= 'BRANCH' where costcode = @@tmpcost and sessionid = @sid and vtype=@vtype and booktype =@booktype and lno = @@tmplno and party_code =@@tmpcltcode  
  end  
 print @@tmpcost   
 select @@tmpcostname = (select distinct top 1 m.COSTNAME from category c, costmast m where c.catcode = m.catcode and m.costcode= @@tmpcost)  
 update templedger2 set branch = @@tmpcostname  where sessionid = @sid and vtype=@vtype and booktype =@booktype and lno = @@tmplno and party_code = @@tmpcltcode and costcode=@@tmpcost  
 select @@tmpcat= ''  
 select @@tmpcostname =''  
 select @@tmpcltcode = ''  
 select @@tmpcost=''  
 Fetch Next from @@CNo into @@tmplno,@@tmpcost,@@tmpcltcode  
 end  
 Close @@CNo  
 DeAllocate @@CNo  
  
 delete from templedger2 where party_code in ( select BrControlAc from branchaccounts)  
 update templedger2 set costflag = 'A', rowid = lno  
        where upper(category) = 'BRANCH' and sessionid = @sid and vtype=@vtype and booktype =@booktype and vno= @vno  
 update templedger2 set costflag = 'A', rowid = lno  
        where upper(category) <> 'BRANCH' and sessionid = @sid and vtype=@vtype and booktype =@booktype and vno= @vno  
  
end

GO
