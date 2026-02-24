-- Object: PROCEDURE dbo.GenNDContract
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.GenNDContract    Script Date: 3/17/01 9:55:52 PM ******/

/****** Object:  Stored Procedure dbo.GenNDContract    Script Date: 3/21/01 12:50:09 PM ******/

/****** Object:  Stored Procedure dbo.GenNDContract    Script Date: 20-Mar-01 11:38:51 PM ******/

/****** Object:  Stored Procedure dbo.GenContract    Script Date: 12/27/00 8:59:17 PM ******/
CREATE PROCEDURE GenNDContract AS 
declare @@Party varchar(12),
                @@Sett_Type varchar(2),  
                @@ContNo varchar(7),
                @@ContNoPartiPant varchar(7),
   @@PartiPantCode Varchar(15),
   @@MemberCode Varchar(15),
   @@Sauda_Date Varchar(11),
 @@Order_no Varchar(16),
 @@Scrip_Cd Varchar(12),
 @@Series Varchar(2),
 @@Sell_buy Int,
                @@Cont Cursor  ,  
                @@PartyCont Cursor    
 set @@PartyCont = cursor for
  select Distinct Left(Convert(Varchar,Sauda_date,109),11) from  trade 
 open @@PartyCont
 fetch next  from @@PartyCont into   @@sauda_date
 close @@PartyCont
 
 set @@PartyCont = cursor for 
  select MemberCode from Owner
 open @@PartyCont
 fetch next  from @@PartyCont into   @@MemberCode
 close @@PartyCont
 
 delete from TConfirmview
 insert into TConfirmview select * from NDConfirmview
 
 set @@PartyCont = cursor for 
                select Sett_Type,PartiPantCode,Party_Code from TConfirmview where PartipantCode in ( Select distinct CltCode from MultiBroker)
                 or PartipantCode ='NCIT' or PartipantCode = @@MemberCode
                group by Sett_Type,PartiPantCode,Party_Code 
                open @@PartyCont
 fetch next  from @@PartyCont into   @@Sett_type,@@PartiPantCode,@@Party
 
 while @@fetch_status = 0
 begin
	select @@ContNo = 0 
	 set @@Cont = cursor for
	 select isnull(Convert(int,contractno),0) from settlement  where sauda_Date like @@Sauda_date +'%'
	 and Sett_Type = @@Sett_type and Party_code = @@Party and PartiPantCode = @@PartiPantCode
	 open @@Cont
	 fetch next  from @@Cont into   @@ContNo
	 close @@Cont

	If  @@ContNo = 0 
	Begin
		 set @@Cont = cursor for
		 select isnull(max(Convert(int,contractno)),0) from settlement  where sauda_Date like @@Sauda_date +'%'
		 open @@Cont
		 fetch next  from @@Cont into   @@ContNo
		 close @@Cont

		 set @@Cont = cursor for
		 select isnull(max(Convert(int,contractno)),0) from Isettlement  where sauda_Date like @@Sauda_date +'%'
		 open @@Cont
		 fetch next  from @@Cont into   @@ContNoPartiPant
		 close @@Cont
		 If @@ContNoPartiPant > @@ContNo
			select @@ContNo = @@ContNoPartiPant

		select @@ContNo = Convert(int,@@ContNo) + 1
	end
	  Select @@ContNo = ( case when @@ContNo < 10 
                                           Then   "0000" + Convert(varchar,@@ContNo)
                                                                             else ( Case  when @@ContNo < 100  
            Then "000" + Convert(varchar,@@ContNo)
                                                                                          else ( Case  when @@ContNo < 1000  
          Then "00" + Convert(varchar,@@ContNo)
                                                                                                        else ( Case  when @@ContNo < 10000  
                                        Then  "0" + Convert(varchar,@@ContNo)
                                                                                                                     else ( Case  when @@ContNo < 100000  
                      Then  Convert(varchar,@@ContNo)
                                                                                                                                 end ) 
                                                                                                                    end )
                                                                                                        end ) 
                                                                                            end )
                                                                                 end ) 
  exec InsSett @@Sett_type,@@Party,@@ContNo,@@PartiPantCode,1,1,1,1,1
  fetch next  from @@PartyCont into   @@Sett_type,@@PartiPantCode,@@Party
 end
 close @@PartyCont

SELECT @@ContNoPartiPant = @@ContNo
 set @@PartyCont = cursor for 
	select Sett_Type,PartiPantCode,T.Party_Code,order_no from TConfirmview T, Client2 C2 where PartipantCode not in ( Select distinct CltCode from MultiBroker)
                and  PartipantCode <> 'NCIT'  and  PartipantCode <> @@MemberCode and C2.Party_Code = T.Party_Code and C2.InsCont  = 'O'
                group by Sett_Type,PartiPantCode,T.Party_Code,order_no
                open @@PartyCont
 fetch next  from @@PartyCont into   @@Sett_type,@@PartiPantCode,@@Party,@@order_no

 while @@fetch_status = 0
 begin 
	Select @@ContNoPartiPant = 0
	 set @@Cont = cursor for 
	 select isnull(Convert(int,contractno),0) from ISettlement  where sauda_Date like @@Sauda_date +'%'
	 and Sett_Type = @@Sett_type and Party_code = @@Party and PartiPantCode = @@PartiPantCode and Order_No = @@Order_No
	 open @@Cont
	 fetch next  from @@Cont into @@ContNoPartiPant
	 close @@Cont

	If  @@ContNoPartiPant = 0 
	Begin
		 set @@Cont = cursor for
		 select isnull(max(Convert(int,contractno)),0) from settlement  where sauda_Date like @@Sauda_date +'%'
		 open @@Cont
		 fetch next  from @@Cont into   @@ContNo
		 close @@Cont

		 set @@Cont = cursor for
		 select isnull(max(Convert(int,contractno)),0) from Isettlement  where sauda_Date like @@Sauda_date +'%'
		 open @@Cont
		 fetch next  from @@Cont into   @@ContNoPartiPant
		 close @@Cont

		 If  @@ContNo > @@ContNoPartiPant
		           select @@ContNoPartiPant = @@ContNo 

  	                select @@ContNoPartiPant = Convert(int,@@ContNoPartiPant) + 1		
	end
                Select @@ContNoPartiPant = ( case when @@ContNoPartiPant < 10 
                               Then   "0000" + Convert(varchar,@@ContNoPartiPant)
                                                   else ( Case  when @@ContNoPartiPant < 100  
               Then  "000" + Convert(varchar,@@ContNoPartiPant)
                                    else ( Case  when @@ContNoPartiPant < 1000  
                                                                      Then  "00" + Convert(varchar,@@ContNoPartiPant)
                                                                                         else ( Case  when @@ContNoPartiPant < 10000  
                         Then  "0" + Convert(varchar,@@ContNoPartiPant)
                                                                                        else ( Case  when @@ContNoPartiPant < 100000  
                       Then   Convert(varchar,@@ContNoPartiPant)
                                                                                               end ) 
                                                                                                end ) 
                                                                         end ) 
                                                                end )
                                                 end ) 

           exec InsSett @@Sett_type,@@Party,@@ContNoPartiPant,@@PartiPantCode,@@order_no,1,1,1,2         
  fetch next  from @@PartyCont into   @@Sett_type,@@PartiPantCode,@@Party,@@order_no
end
 close @@PartyCont

SELECT @@ContNoPartiPant = @@ContNo
 set @@PartyCont = cursor for 
	select Sett_Type,PartiPantCode,T.Party_Code,Scrip_Cd,Series,Sell_Buy from TConfirmview T, Client2 C2 where PartipantCode not in ( Select distinct CltCode from MultiBroker)
                and  PartipantCode <> 'NCIT'  and  PartipantCode <> @@MemberCode and C2.Party_Code = T.Party_Code and C2.InsCont  = 'S'
                group by Sett_Type,PartiPantCode,T.Party_Code,Scrip_Cd,Series,Sell_Buy
                open @@PartyCont
 fetch next  from @@PartyCont into   @@Sett_type,@@PartiPantCode,@@Party,@@Scrip_Cd,@@Series,@@Sell_buy

 while @@fetch_status = 0
 begin 
	Select @@ContNoPartiPant = 0
	 set @@Cont = cursor for 
	 select isnull(Convert(int,contractno),0) from ISettlement  where sauda_Date like @@Sauda_date +'%'
	 and Sett_Type = @@Sett_type and Party_code = @@Party and PartiPantCode = @@PartiPantCode and Order_No = @@Order_No
	 open @@Cont
	 fetch next  from @@Cont into @@ContNoPartiPant
	 close @@Cont

	If  @@ContNoPartiPant = 0 
	Begin
		 set @@Cont = cursor for
		 select isnull(max(Convert(int,contractno)),0) from settlement  where sauda_Date like @@Sauda_date +'%'
		 open @@Cont
		 fetch next  from @@Cont into   @@ContNo
		 close @@Cont

		 set @@Cont = cursor for
		 select isnull(max(Convert(int,contractno)),0) from Isettlement  where sauda_Date like @@Sauda_date +'%'
		 open @@Cont
		 fetch next  from @@Cont into   @@ContNoPartiPant
		 close @@Cont

		 If  @@ContNo > @@ContNoPartiPant
		           select @@ContNoPartiPant = @@ContNo 

  	                select @@ContNoPartiPant = Convert(int,@@ContNoPartiPant) + 1		
	end
                Select @@ContNoPartiPant = ( case when @@ContNoPartiPant < 10 
                               Then   "0000" + Convert(varchar,@@ContNoPartiPant)
                                                   else ( Case  when @@ContNoPartiPant < 100  
               Then  "000" + Convert(varchar,@@ContNoPartiPant)
                                    else ( Case  when @@ContNoPartiPant < 1000  
                                                                      Then  "00" + Convert(varchar,@@ContNoPartiPant)
                                                                                         else ( Case  when @@ContNoPartiPant < 10000  
                         Then  "0" + Convert(varchar,@@ContNoPartiPant)
                                                                                        else ( Case  when @@ContNoPartiPant < 100000  
                       Then   Convert(varchar,@@ContNoPartiPant)
                                                                                               end ) 
                                                                                                end ) 
                                                                         end ) 
                                                                end )
                                                 end ) 

           exec InsSett @@Sett_type,@@Party,@@ContNoPartiPant,@@PartiPantCode,1,@@Scrip_Cd,@@Series,@@Sell_buy,3
 fetch next  from @@PartyCont into   @@Sett_type,@@PartiPantCode,@@Party,@@Scrip_Cd,@@Series,@@Sell_buy
end
 close @@PartyCont

 deallocate @@PartyCont
 update Settlement set sett_no =  settled_in
 from settlement s, nodel n where s.scrip_cd = n.scrip_cd
 and s.series = n.series  and
 s.sauda_date >= n.start_date AND s.sauda_date <= n.end_date
 update ISettlement set sett_no =  settled_in
 from Isettlement s, nodel n where s.scrip_cd = n.scrip_cd
 and s.series = n.series  and
 s.sauda_date >= n.start_date AND s.sauda_date <= n.end_date
 Delete From Trade

GO
