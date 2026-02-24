-- Object: PROCEDURE dbo.Foupdbilltax
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.Foupdbilltax    Script Date: 5/26/01 4:17:01 PM ******/
CREATE proc Foupdbilltax(@ExpiryDate  varchar(11)) as
update Fosettlement set
       NBrokApp = (  case  
                       when ( Fosettlement.billflag = 4  and broktable.val_perc ="V" )
                       Then broktable.normal 

                        when ( Fosettlement.billFlag = 4  and broktable.val_perc ="P" )
                        Then  round((broktable.Normal /100 ) * fofinalclosing.cl_rate,broktable.round_to)


                       when ( Fosettlement.billflag = 5  and broktable.val_perc ="V" )
                       Then broktable.normal 

                       when ( Fosettlement.billflag = 5  and broktable.val_perc ="P" )
                       Then round((broktable.Normal /100 ) * fofinalclosing.cl_rate,broktable.round_to)
                  Else  
                       BrokApplied 
                  End 
                  ),

       N_NetRate = (  case  
                        when ( Fosettlement.billflag = 4  and broktable.val_perc ="V" )
                        Then ((broktable.normal + fofinalclosing.cl_rate ) )
                        when ( Fosettlement.billflag = 4  and broktable.val_perc ="P" )
                        Then ((fofinalclosing.cl_rate + round((broktable.Normal /100 )* fofinalclosing.cl_rate,broktable.round_to)))
                        
                        when ( Fosettlement.billflag =5  and broktable.val_perc ="V" )
                        Then (( fofinalclosing.cl_rate - broktable.normal ))
                        
                        when ( Fosettlement.billflag =5  and broktable.val_perc ="P" )
                        Then ((fofinalclosing.cl_rate - round((broktable.Normal /100 )* fofinalclosing.cl_rate,broktable.round_to)))
                    Else  
                        NetRate 
                    End 
                 ),
        NSertax = (   case  
                        
                        when ( Fosettlement.billFlag = 4  and broktable.val_perc ="V" )
                             Then round((round(broktable.normal,broktable.round_to) * Fosettlement.Tradeqty* FoGlobals.service_tax) / 100,broktable.round_to)

                        when ( Fosettlement.billFlag = 4  and broktable.val_perc ="P" )
                             Then round(((round((broktable.normal/100) *  fofinalclosing.cl_rate,broktable.round_to)  * Fosettlement.Tradeqty * FoGlobals.service_tax)/100 ),broktable.round_to)

                        when ( Fosettlement.billFlag = 5  and broktable.val_perc ="V" )
                             Then round ( (round(broktable.normal ,broktable.round_to) * Fosettlement.Tradeqty* FoGlobals.service_tax) /100,broktable.round_to)

                        when ( Fosettlement.billFlag = 5  and broktable.val_perc ="P" )
                             Then  round(((round((broktable.normal/100) * fofinalclosing.cl_rate,broktable.round_to) * Fosettlement.Tradeqty * FoGlobals.service_tax)  /100),broktable.round_to) 
		 Else  
                        Fosettlement.Service_tax
                    End 
                ) ,
        Ins_chrg  = round(((FoTaxes.insurance_chrg * fofinalclosing.cl_rate * Fosettlement.Tradeqty)/100),broktable.round_to), 

        turn_tax  = round(((FoTaxes.turnover_tax * fofinalclosing.cl_rate * Fosettlement.Tradeqty)/100 ),broktable.round_to),              

        other_chrg = round(((FoTaxes.other_chrg * fofinalclosing.cl_rate * Fosettlement.Tradeqty)/100 ),broktable.round_to), 

        sebi_tax = round(((FoTaxes.sebiturn_tax * fofinalclosing.cl_rate * Fosettlement.Tradeqty)/100),broktable.round_to),              

        Broker_chrg = round(((FoTaxes.broker_note * fofinalclosing.cl_rate * Fosettlement.Tradeqty)/100),broktable.round_to)

        FROM BrokTable,Client2,FoTaxes,FoGlobals,FoScrip1,FoScrip2,client1,fofinalclosing
        WHERE 
            Fosettlement.Party_Code = Client2.Party_code
        and
            client1.cl_code=client2.cl_code		         
           and foSETTLEMENT.inst_type = foscrip2.inst_type 
           AND FOsettlement.SYMBOL = FOSCRIP2.SYMBOL      
          and fosettlement.strike_price = foscrip2.strike_price
          and fosettlement.option_type = foscrip2.option_type 
          AND FOsettlement.expirydate=foscrip2.expirydate
          and fofinalclosing.ClosingDate=foscrip2.maturitydate
         and fofinalclosing.UnderlyingAsset=foscrip2.symbol
         
       AND 
           Broktable.Table_no = ( case when (client2.Tran_cat = 'TRD')  then 
		                         client2.brok1_tableno      				
			END )
            And 
            Broktable.Line_no = ( case when (client2.Tran_cat = 'TRD')   then 
					(Select min(Broktable.line_no) from broktable where
	  		                           Broktable.table_no = client2.brok1_tableno    
					and Fosettlement.Party_Code =  Client2.Party_code   	
					And Trd_Del = 'D'
		                        and fofinalclosing.cl_rate <= Broktable.upper_lim )         			
              		       end ) 
               
               
           And
             (Client2.Tran_cat = FoTaxes.Trans_cat)
           And
             (FoTaxes.exchange = 'NSE')
/*           And
             (FoTaxes.Sett_type = 'N')    
         And
              (FoTaxes.Sett_type =  */           
	and client2.Tran_cat = 'TRD'
  And (billflag = 4 or billflag = 5)
  and Fosettlement.tradeqty > 0 and
Fosettlement.expirydate like  @expirydate  + '%'  

  /*and left(convert(varchar,Fosettlement.expirydate,106),11) = @expirydate    */



/*888888888888888888888888888888888888888888888888888888888888888888888888888888888888888*/
/*animesh procedure for fo*/
/*CREATE proc Foupdbilltax(@ExpiryDate SmallDatetime) as
update Fosettlement set
       NBrokApp = (  case  
                       when ( Fosettlement.billflag = 4  and broktable.val_perc ="V" )
                       Then broktable.normal 

                        when ( Fosettlement.billFlag = 4  and broktable.val_perc ="P" )
                        Then  round((broktable.Normal /100 ) * Fosettlement.price,broktable.round_to)


                       when ( Fosettlement.billflag = 5  and broktable.val_perc ="V" )
                       Then broktable.normal 

                       when ( Fosettlement.billflag = 5  and broktable.val_perc ="P" )
                       Then round((broktable.Normal /100 ) * Fosettlement.price,broktable.round_to)
                  Else  
                       BrokApplied 
                  End 
                  ),

       N_NetRate = (  case  
                        when ( Fosettlement.billflag = 4  and broktable.val_perc ="V" )
                        Then ((broktable.normal + Fosettlement.price ) )
                        when ( Fosettlement.billflag = 4  and broktable.val_perc ="P" )
                        Then ((Fosettlement.price + round((broktable.Normal /100 )* Fosettlement.price,broktable.round_to)))
                        
                        when ( Fosettlement.billflag =5  and broktable.val_perc ="V" )
                        Then (( Fosettlement.price - broktable.normal ))
                        
                        when ( Fosettlement.billflag =5  and broktable.val_perc ="P" )
                        Then ((Fosettlement.price - round((broktable.Normal /100 )* Fosettlement.price,broktable.round_to)))
                    Else  
                        NetRate 
                    End 
                 ),
        NSertax = (   case  
                        
                        when ( Fosettlement.billFlag = 4  and broktable.val_perc ="V" )
                             Then round((round(broktable.normal,broktable.round_to) * Fosettlement.Tradeqty* FoGlobals.service_tax) / 100,broktable.round_to)

                        when ( Fosettlement.billFlag = 4  and broktable.val_perc ="P" )
                             Then round(((round((broktable.normal/100) *  Fosettlement.price,broktable.round_to)  * Fosettlement.Tradeqty * FoGlobals.service_tax)/100 ),broktable.round_to)

                        when ( Fosettlement.billFlag = 5  and broktable.val_perc ="V" )
                             Then round ( (round(broktable.normal ,broktable.round_to) * Fosettlement.Tradeqty* FoGlobals.service_tax) /100,broktable.round_to)

                        when ( Fosettlement.billFlag = 5  and broktable.val_perc ="P" )
                             Then  round(((round((broktable.normal/100) * Fosettlement.price,broktable.round_to) * Fosettlement.Tradeqty * FoGlobals.service_tax)  /100),broktable.round_to) 
		 Else  
                        Fosettlement.Service_tax
                    End 
                ) ,
        Ins_chrg  = round(((FoTaxes.insurance_chrg * Fosettlement.price * Fosettlement.Tradeqty)/100),broktable.round_to), 

        turn_tax  = round(((FoTaxes.turnover_tax * Fosettlement.price * Fosettlement.Tradeqty)/100 ),broktable.round_to),              

        other_chrg = round(((FoTaxes.other_chrg * Fosettlement.price * Fosettlement.Tradeqty)/100 ),broktable.round_to), 

        sebi_tax = round(((FoTaxes.sebiturn_tax * Fosettlement.price * Fosettlement.Tradeqty)/100),broktable.round_to),              

        Broker_chrg = round(((FoTaxes.broker_note * Fosettlement.price * Fosettlement.Tradeqty)/100),broktable.round_to)

        FROM BrokTable,Client2,FoTaxes,FoGlobals,FoScrip1,FoScrip2,Sett_mst,client1
        WHERE 
            Fosettlement.Party_Code = Client2.Party_code
        and
            client1.cl_code=client2.cl_code		         
           and foSETTLEMENT.inst_type = foscrip2.inst_type 
           AND FOsettlement.SYMBOL = FOSCRIP2.SYMBOL      
           AND FOsettlement.expirydate=foscrip2.expirydate
       AND 
           Broktable.Table_no = ( case when (client2.Tran_cat = 'TRD')  then 
		                         client2.brok1_tableno      				
			END )
            And 
            Broktable.Line_no = ( case when (client2.Tran_cat = 'TRD')   then 
					(Select min(Broktable.line_no) from broktable where
	  		                           Broktable.table_no = client2.Sub_TableNo
					and Fosettlement.Party_Code =  Client2.Party_code   	
					And Trd_Del = 'D'
		                        and Fosettlement.price <= Broktable.upper_lim )         			
              		       end ) 
               
               
           And
             (Client2.Tran_cat = FoTaxes.Trans_cat)
           And
             (FoTaxes.exchange = 'NSE')
    
	and client2.Tran_cat = 'TRD'
  And (billflag = 4 or billflag = 5)
  and Fosettlement.tradeqty > 0
  and Fosettlement.expirydate = @expirydate    */

GO
