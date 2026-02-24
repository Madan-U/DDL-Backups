-- Object: PROCEDURE dbo.spAdjBalCursor2001
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.spAdjBalCursor2001    Script Date: 01/04/1980 1:40:43 AM ******/



/****** Object:  Stored Procedure dbo.spAdjBalCursor2001    Script Date: 11/28/2001 12:23:52 PM ******/

/****** Object:  Stored Procedure dbo.spAdjBalCursor2001    Script Date: 29-Sep-01 8:12:07 PM ******/

/****** Object:  Stored Procedure dbo.spAdjBalCursor2001    Script Date: 8/8/01 1:37:33 PM ******/

/****** Object:  Stored Procedure dbo.spAdjBalCursor2001    Script Date: 8/7/01 6:03:53 PM ******/
/****** Object:  Stored Procedure dbo.spAdjBalCursor    Script Date: 7/8/01 3:22:51 PM ******/

/****** Object:  Stored Procedure dbo.spAdjBalCursor    Script Date: 2/17/01 3:34:19 PM ******/


/****** Object:  Stored Procedure dbo.spAdjBalCursor    Script Date: 20-Mar-01 11:43:36 PM ******/

/* 22/03/2000   this procedure is used to adjust the balance amount of  all the parties according to the dates*/
CREATE PROCEDURE     spAdjBalCursor2001    @code varchar(12)
 AS
declare    @@tbalamt numeric(17,2)   ,
@@tdrcr varchar(1),
/*@@trefno varchar(12) ,*/
@@vtyp smallint,
@@vno int,
@@tvdt datetime  ,
@@tvamt numeric(17,2),
@@tcur cursor    
                 select @@tbalamt=0

                 set @@tcur = cursor for 
                 select drcr,vamt , /*refno,*/ vtyp,vno,vdt  from ledger 
                 where cltcode= @code   and vdt >= '04/01/2000 00:00:00' and vdt <= '03/31/2001 23:59:59'
                 order by vdt,vtyp,  vno/*refno*/
                 open @@tcur
fetch next  from @@tcur into   @@tdrcr ,@@tvamt  , /*@@trefno   ,*/ @@vtyp,@@vno, @@tvdt
               
while   @@fetch_status =0
begin
                 
                  if  @@tdrcr='c' 
                  begin
                             select  @@tvamt  = 0  -   @@tvamt
                  end
                  Select   @@tbalamt =   @@tbalamt   +   @@tvamt 
           
                 update ledger set balamt =   @@tbalamt                 
                 where  vtyp = @@vtyp and vno = @@vno and drcr = @@tdrcr and vdt = @@tvdt  and cltcode = @code  /*current of  @@tcur*/

                 fetch next  from @@tcur into   @@tdrcr ,@@tvamt   , /*@@trefno   ,*/ @@vtyp,@@vno, @@tvdt

end
close @@tcur
deallocate @@tcur

GO
