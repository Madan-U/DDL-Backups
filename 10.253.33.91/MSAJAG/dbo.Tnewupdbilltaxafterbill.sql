-- Object: PROCEDURE dbo.Tnewupdbilltaxafterbill
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE proc Tnewupdbilltaxafterbill (@SETTNO VARCHAR(7),@SETTYPE VARCHAR(2),@Party_code Varchar(10),@Scrip_cd varchar(12)) as
Declare
@@TerminalNo Varchar(20),
@@Table_no Smallint,
@@Sub_tableNo SmallInt,
@@P_To_P SmallInt,
@@Sb_TableNo SmallInt,
@@AlBmCf_Tableno Smallint,
@@Brok_Scheme Smallint,
@@StartDate DateTime,
@@TerminalCursor As Cursor

Select @@StartDate = Start_date from sett_mst where 
Sett_type = @Settype
and
Sett_no = @Settno

Set @@TerminalCursor = Cursor For
--Select Distinct @@TerminalNo = Terminalnumber,@@Brok_Scheme=BrokScheme,@@Table_no=Table_no,@@Sub_TableNo = Sub_TableNo,@@P_To_P = P_To_P,@@Sb_TableNo = Sb_TableNo,@@AlBmCf_TableNo = AlBmCf_TableNo 
Select Distinct Terminalnumber,BrokScheme,Table_no,Sub_TableNo,P_To_P,Sb_TableNo,AlBmCf_TableNo 
from AngelTermBrok where
Party_code = @Party_code
and FromDate <= @@StartDate
and ToDate >= @@StartDate

Open @@TerminalCursor

Fetch Next From @@TerminalCursor Into @@TerminalNo ,@@Brok_Scheme,@@Table_no,@@Sub_TableNo,@@P_To_P,@@Sb_TableNo,@@AlBmCf_TableNo

While @@Fetch_status = 0 
Begin
if @settype = 'N' 
begin
Update settlement set         NBrokApp = (  case  
    when (  broktable.val_perc ="V" )
                             Then 
		((floor(( broktable.Normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))

                        when (  broktable.val_perc ="P" )
                             Then      ((floor ( (((broktable.Normal /100 ) * settlement.marketrate)  * power(10,Broktable.round_to) + broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
   Else  
          BrokApplied 
                        End 
                         ),
       N_NetRate = (  case  
                      when (  broktable.val_perc ="V" AND settlement.SELL_BUY = 1)
                             Then
                                  settlement.marketrate + ((floor((  (( broktable.Normal)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                      when (  broktable.val_perc ="P" AND settlement.SELL_BUY = 1 )
                             Then settlement.marketrate + ((floor(( (((broktable.Normal /100 )* settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))

                      when (broktable.val_perc ="V" AND settlement.SELL_BUY =2 )
                             Then settlement.marketrate - ((floor(( (( broktable.Normal )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 	power(10,broktable.round_to))
                      when ( broktable.val_perc ="P" AND settlement.SELL_BUY = 2 )
                             Then   
                      settlement.marketrate - ((floor(( (((broktable.Normal /100 )* settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
   Else  
             NetRate 
                        End 
                         ),/*modified by bhayashree on 27-12-2000*/
        NSertax = (case  
   when ( broktable.val_perc ="V" ) Then
    		( ( ((floor(( broktable.Normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to)) ) * ( settlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

                      when (broktable.val_perc ="P" )
                           Then                                       ((    ((floor ( (((broktable.Normal /100 ) * settlement.marketrate)  * power(10,Broktable.round_to) + broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)) ) * ( settlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

   Else  
       settlement.Service_tax
                        End 
                         ) /*  /  ( CASE WHEN CLIENT2.Service_chrg =  0 THEN 100 ELSE (100 + settlement.service_tax)  END )*/,
Ins_chrg  =(Case
		when settlement.status = 'N' then 0
			else ((taxes.insurance_chrg * settlement.marketrate * settlement.Tradeqty)/100) End), 
turn_tax  = (Case
		when settlement.status = 'N' then 0
			else ((taxes.turnover_tax * settlement.marketrate * settlement.Tradeqty)/100 ) end),              
other_chrg =(Case
		when settlement.status = 'N' then 0
			else ((taxes.other_chrg * settlement.marketrate * settlement.Tradeqty)/100 ) end), 
sebi_tax = (Case
		when settlement.status = 'N' then 0
			else ((taxes.sebiturn_tax * settlement.marketrate * settlement.Tradeqty)/100) end),              
Broker_chrg =(Case
		when settlement.status = 'N' then 0
else ((taxes.broker_note * settlement.marketrate * settlement.Tradeqty)/100) end)                                                  

                                                  
      FROM BrokTable BrokTable,Client2 client2,taxes taxes,globals,Settlement,Client1
      WHERE 
            settlement.Party_Code = Client2.Party_code
            And Client2.Cl_code = Client1.Cl_code 
   	
 And Broktable.Table_no = ( Case When (Client2.Tran_cat = 'TRD') 
					     Then @@sub_tableno  	
					     Else ( case when Settlement.TMARK ='V' 
					        	 Then @@P_To_P
							 Else ( Case When Settlement.tmark = 'S' 
					    			     Then @@Sb_TableNo	
					    			     Else ( Case When Settlement.tmark = 'C'  	
						           			 Then @@AlbmCF_tableno
										 Else @@SUB_TABLENO 
									    End )
					    		        End )
				       		   End )		
					End )
            And 
               Broktable.Line_no = 
                ( case 
                       when (client2.Tran_cat = 'TRD')	 then 
					   (Select min(Broktable.line_no) from broktable where
		                                 	  Broktable.table_no = @@Sub_TableNo
					 and Trd_Del = 'D'
                                                  		 and settlement.Party_Code =  Client2.Party_code   	
		                                 	  and settlement.marketrate <= Broktable.upper_lim )				    
		end)               
  And
     Taxes.trans_Cat =(Case When Client1.cl_type = 'PRO' Then 'PRO' Else  'DEL' End) 
           And
             (taxes.exchange = 'NSE')             
           And
             (Globals.exchange = 'NSE')             
 AND SETTLEMENT.SETT_NO = @SETTNO
 AND SETTLEMENT.SETT_TYPE = @SETTYPE
and settlement.billflag in(4,5) 
and settlement.status <> 'E'
and settlement.party_code = @party_code
and settlement.scrip_cd = @Scrip_cd
And Sauda_date > Globals.year_start_dt
And Sauda_date < Globals.year_end_dt
And User_id = @@Terminalno
end
else if @settype <> 'N' 
begin
update settlement set
      NBrokApp = (  case  
    when (  broktable.val_perc ="V" )
                             Then 
		((floor(( broktable.Normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))

                        when (  broktable.val_perc ="P" )
                             Then      ((floor ( (((broktable.Normal /100 ) * settlement.marketrate)  * power(10,Broktable.round_to) + broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
   Else  
          BrokApplied 
                        End 
                         ),
       N_NetRate = (  case  
                      when (  broktable.val_perc ="V" AND settlement.SELL_BUY = 1)
                             Then
                                  settlement.marketrate + ((floor((  (( broktable.Normal)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                      when (  broktable.val_perc ="P" AND settlement.SELL_BUY = 1 )
                             Then settlement.marketrate + ((floor(( (((broktable.Normal /100 )* settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))

                      when (broktable.val_perc ="V" AND settlement.SELL_BUY =2 )
                             Then settlement.marketrate - ((floor(( (( broktable.Normal )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 	power(10,broktable.round_to))
                      when ( broktable.val_perc ="P" AND settlement.SELL_BUY = 2 )
                             Then   
                      settlement.marketrate - ((floor(( (((broktable.Normal /100 )* settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
   Else  
             NetRate 
                        End 
                         ),/*modified by bhayashree on 27-12-2000*/
        NSertax = (case  
   when ( broktable.val_perc ="V" ) Then
    		( ( ((floor(( broktable.Normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to)) ) * ( settlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

                      when (broktable.val_perc ="P" )
                           Then                                       ((    ((floor ( (((broktable.Normal /100 ) * settlement.marketrate)  * power(10,Broktable.round_to) + broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)) ) * ( settlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

   Else  
       settlement.Service_tax
                        End 
                         ) /*  /  ( CASE WHEN CLIENT2.Service_chrg =  0 THEN 100 ELSE (100 + settlement.service_tax)  END )*/,
Ins_chrg  =(Case
		when settlement.status = 'N' then 0
			else ((taxes.insurance_chrg * settlement.marketrate * settlement.Tradeqty)/100) End), 
turn_tax  = (Case
		when settlement.status = 'N' then 0
			else ((taxes.turnover_tax * settlement.marketrate * settlement.Tradeqty)/100 ) end),              
other_chrg =(Case
		when settlement.status = 'N' then 0
			else ((taxes.other_chrg * settlement.marketrate * settlement.Tradeqty)/100 ) end), 
sebi_tax = (Case
		when settlement.status = 'N' then 0
			else ((taxes.sebiturn_tax * settlement.marketrate * settlement.Tradeqty)/100) end),              
Broker_chrg =(Case
		when settlement.status = 'N' then 0
else ((taxes.broker_note * settlement.marketrate * settlement.Tradeqty)/100) end)                                                  
                                                  
      FROM BrokTable BrokTable,Client2 client2,taxes taxes,globals, Client1
      WHERE 
            settlement.Party_Code = Client2.Party_code
            And
            Client2.Cl_code = Client1.Cl_code
  And Broktable.Table_no = ( Case When (Settlement.tmark = 'D' and client2.Tran_cat = 'TRD') 
					     Then @@sub_tableno  	
					     Else ( case when Settlement.TMARK ='V' 
					        	 Then @@P_To_P
							 Else ( Case When Settlement.tmark = 'S' 
					    			     Then @@Sb_TableNo	
					    			     Else ( Case When Settlement.tmark = 'C'  	
						           			 Then @@AlbmCF_tableno
										 Else @@SUB_TABLENO 
									    End )
					    		        End )
				       		   End )		
					End )
		/*	   End ) */
            And 
               Broktable.Line_no = 
                ( case 
                                      		when (client2.Tran_cat = 'TRD')	 then 
					   (Select min(Broktable.line_no) from broktable where
		                                 	  Broktable.table_no = @@Sub_TableNo
					 and Trd_Del = 'D'
                                                  		 and settlement.Party_Code =  Client2.Party_code   	
		                                 	  and settlement.marketrate <= Broktable.upper_lim )				    
		end)               
  And
Taxes.trans_Cat =(Case When Client1.cl_type = 'PRO' Then 'PRO' Else  'DEL' End) 
           And
             (taxes.exchange = 'NSE')             
           And
             (Globals.exchange = 'NSE')             
 AND SETTLEMENT.SETT_NO = @SETTNO 
 AND SETTLEMENT.SETT_TYPE = @SETTYPE
and settlement.billflag in(4,5) 
and settlement.status <> 'E'
and settlement.party_code = @party_code
and settlement.scrip_cd = @Scrip_cd
And Sauda_date > Globals.year_start_dt
And Sauda_date < Globals.year_end_dt
And User_id = @@TerminalNo
end
Fetch Next From @@TerminalCursor Into @@TerminalNo ,@@Brok_Scheme,@@Table_no,@@Sub_TableNo,@@P_To_P,@@Sb_TableNo,@@AlBmCf_TableNo
End

Select Distinct @@Brok_Scheme=Brok_Scheme,@@Table_no=Table_no,@@Sub_TableNo = Sub_TableNo,@@P_To_P = P_To_P,@@Sb_TableNo = Sb_TableNo,@@AlBmCf_TableNo = AlBmCf_TableNo 
from Client2 where
Party_code = @Party_code

if @settype = 'N' 
begin
Update settlement set         NBrokApp = (  case  
    when (  broktable.val_perc ="V" )
                             Then 
		((floor(( broktable.Normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))

                        when (  broktable.val_perc ="P" )
                             Then      ((floor ( (((broktable.Normal /100 ) * settlement.marketrate)  * power(10,Broktable.round_to) + broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
   Else  
          BrokApplied 
                        End 
                         ),
       N_NetRate = (  case  
                      when (  broktable.val_perc ="V" AND settlement.SELL_BUY = 1)
                             Then
                                  settlement.marketrate + ((floor((  (( broktable.Normal)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                      when (  broktable.val_perc ="P" AND settlement.SELL_BUY = 1 )
                             Then settlement.marketrate + ((floor(( (((broktable.Normal /100 )* settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))

                      when (broktable.val_perc ="V" AND settlement.SELL_BUY =2 )
                             Then settlement.marketrate - ((floor(( (( broktable.Normal )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 	power(10,broktable.round_to))
                      when ( broktable.val_perc ="P" AND settlement.SELL_BUY = 2 )
                             Then   
                      settlement.marketrate - ((floor(( (((broktable.Normal /100 )* settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
   Else  
             NetRate 
                        End 
                         ),/*modified by bhayashree on 27-12-2000*/
        NSertax = (case  
   when ( broktable.val_perc ="V" ) Then
    		( ( ((floor(( broktable.Normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to)) ) * ( settlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

                      when (broktable.val_perc ="P" )
                           Then                                       ((    ((floor ( (((broktable.Normal /100 ) * settlement.marketrate)  * power(10,Broktable.round_to) + broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)) ) * ( settlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

   Else  
       settlement.Service_tax
                        End 
                         ) /*  /  ( CASE WHEN CLIENT2.Service_chrg =  0 THEN 100 ELSE (100 + settlement.service_tax)  END )*/,
Ins_chrg  =(Case
		when settlement.status = 'N' then 0
			else ((taxes.insurance_chrg * settlement.marketrate * settlement.Tradeqty)/100) End), 
turn_tax  = (Case
		when settlement.status = 'N' then 0
			else ((taxes.turnover_tax * settlement.marketrate * settlement.Tradeqty)/100 ) end),              
other_chrg =(Case
		when settlement.status = 'N' then 0
			else ((taxes.other_chrg * settlement.marketrate * settlement.Tradeqty)/100 ) end), 
sebi_tax = (Case
		when settlement.status = 'N' then 0
			else ((taxes.sebiturn_tax * settlement.marketrate * settlement.Tradeqty)/100) end),              
Broker_chrg =(Case
		when settlement.status = 'N' then 0
else ((taxes.broker_note * settlement.marketrate * settlement.Tradeqty)/100) end)                                                  

                                                  
      FROM BrokTable BrokTable,Client2 client2,taxes taxes,globals,Settlement,Client1
      WHERE 
            settlement.Party_Code = Client2.Party_code
            And Client2.Cl_code = Client1.Cl_code 
   	
 And Broktable.Table_no = ( Case When (Client2.Tran_cat = 'TRD') 
					     Then @@sub_tableno  	
					     Else ( case when Settlement.TMARK ='V' 
					        	 Then @@P_To_P
							 Else ( Case When Settlement.tmark = 'S' 
					    			     Then @@Sb_TableNo	
					    			     Else ( Case When Settlement.tmark = 'C'  	
						           			 Then @@AlbmCF_tableno
										 Else @@SUB_TABLENO 
									    End )
					    		        End )
				       		   End )		
					End )
            And 
               Broktable.Line_no = 
                ( case 
                       when (client2.Tran_cat = 'TRD')	 then 
					   (Select min(Broktable.line_no) from broktable where
		                                 	  Broktable.table_no = @@Sub_TableNo
					 and Trd_Del = 'D'
                                                  		 and settlement.Party_Code =  Client2.Party_code   	
		                                 	  and settlement.marketrate <= Broktable.upper_lim )				    
		end)               
  And
     Taxes.trans_Cat =(Case When Client1.cl_type = 'PRO' Then 'PRO' Else  'DEL' End) 
           And
             (taxes.exchange = 'NSE')             
           And
             (Globals.exchange = 'NSE')             
 AND SETTLEMENT.SETT_NO = @SETTNO
 AND SETTLEMENT.SETT_TYPE = @SETTYPE
and settlement.billflag in(4,5) 
and settlement.status <> 'E'
and settlement.party_code = @party_code
and settlement.scrip_cd = @Scrip_cd
And Sauda_date > Globals.year_start_dt
And Sauda_date < Globals.year_end_dt
And User_id <> @@Terminalno
end
else if @settype <> 'N' 
begin
update settlement set
      NBrokApp = (  case  
    when (  broktable.val_perc ="V" )
                             Then 
		((floor(( broktable.Normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to))

                        when (  broktable.val_perc ="P" )
                             Then      ((floor ( (((broktable.Normal /100 ) * settlement.marketrate)  * power(10,Broktable.round_to) + broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
   Else  
          BrokApplied 
                        End 
                         ),
       N_NetRate = (  case  
                      when (  broktable.val_perc ="V" AND settlement.SELL_BUY = 1)
                             Then
                                  settlement.marketrate + ((floor((  (( broktable.Normal)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
                      when (  broktable.val_perc ="P" AND settlement.SELL_BUY = 1 )
                             Then settlement.marketrate + ((floor(( (((broktable.Normal /100 )* settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))

                      when (broktable.val_perc ="V" AND settlement.SELL_BUY =2 )
                             Then settlement.marketrate - ((floor(( (( broktable.Normal )) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 	power(10,broktable.round_to))
                      when ( broktable.val_perc ="P" AND settlement.SELL_BUY = 2 )
                             Then   
                      settlement.marketrate - ((floor(( (((broktable.Normal /100 )* settlement.marketrate)) * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to))
   Else  
             NetRate 
                        End 
                         ),/*modified by bhayashree on 27-12-2000*/
        NSertax = (case  
   when ( broktable.val_perc ="V" ) Then
    		( ( ((floor(( broktable.Normal * power(10,Broktable.round_to)+broktable.roFig + broktable.errnum ) /  
		(broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / 
		power(10,broktable.round_to)) ) * ( settlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

                      when (broktable.val_perc ="P" )
                           Then                                       ((    ((floor ( (((broktable.Normal /100 ) * settlement.marketrate)  * power(10,Broktable.round_to) + broktable.roFig + broktable.errnum ) /  (broktable.RoFig + broktable.Nozero )) * (broktable.rofig +broktable.NoZero ) )  / power(10,broktable.round_to)) ) * ( settlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )

   Else  
       settlement.Service_tax
                        End 
                         ) /*  /  ( CASE WHEN CLIENT2.Service_chrg =  0 THEN 100 ELSE (100 + settlement.service_tax)  END )*/,
Ins_chrg  =(Case
		when settlement.status = 'N' then 0
			else ((taxes.insurance_chrg * settlement.marketrate * settlement.Tradeqty)/100) End), 
turn_tax  = (Case
		when settlement.status = 'N' then 0
			else ((taxes.turnover_tax * settlement.marketrate * settlement.Tradeqty)/100 ) end),              
other_chrg =(Case
		when settlement.status = 'N' then 0
			else ((taxes.other_chrg * settlement.marketrate * settlement.Tradeqty)/100 ) end), 
sebi_tax = (Case
		when settlement.status = 'N' then 0
			else ((taxes.sebiturn_tax * settlement.marketrate * settlement.Tradeqty)/100) end),              
Broker_chrg =(Case
		when settlement.status = 'N' then 0
else ((taxes.broker_note * settlement.marketrate * settlement.Tradeqty)/100) end)                                                  
                                                  
      FROM BrokTable BrokTable,Client2 client2,taxes taxes,globals, Client1
      WHERE 
            settlement.Party_Code = Client2.Party_code
            And
            Client2.Cl_code = Client1.Cl_code
  And Broktable.Table_no = ( Case When (Settlement.tmark = 'D' and client2.Tran_cat = 'TRD') 
					     Then @@sub_tableno  	
					     Else ( case when Settlement.TMARK ='V' 
					        	 Then @@P_To_P
							 Else ( Case When Settlement.tmark = 'S' 
					    			     Then @@Sb_TableNo	
					    			     Else ( Case When Settlement.tmark = 'C'  	
						           			 Then @@AlbmCF_tableno
										 Else @@SUB_TABLENO 
									    End )
					    		        End )
				       		   End )		
					End )
		/*	   End ) */
            And 
               Broktable.Line_no = 
                ( case 
                                      		when (client2.Tran_cat = 'TRD')	 then 
					   (Select min(Broktable.line_no) from broktable where
		                                 	  Broktable.table_no = @@Sub_TableNo
					 and Trd_Del = 'D'
                                                  		 and settlement.Party_Code =  Client2.Party_code   	
		                                 	  and settlement.marketrate <= Broktable.upper_lim )				    
		end)               
  And
Taxes.trans_Cat =(Case When Client1.cl_type = 'PRO' Then 'PRO' Else  'DEL' End) 
           And
             (taxes.exchange = 'NSE')             
           And
             (Globals.exchange = 'NSE')             
 AND SETTLEMENT.SETT_NO = @SETTNO 
 AND SETTLEMENT.SETT_TYPE = @SETTYPE
and settlement.billflag in(4,5) 
and settlement.status <> 'E'
and settlement.party_code = @party_code
and settlement.scrip_cd = @Scrip_cd
And Sauda_date > Globals.year_start_dt
And Sauda_date < Globals.year_end_dt
And User_id <> @@TerminalNo
end

GO
