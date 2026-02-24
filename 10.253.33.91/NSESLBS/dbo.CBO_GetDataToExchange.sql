-- Object: PROCEDURE dbo.CBO_GetDataToExchange
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE  PROCEDURE  CBO_GetDataToExchange  
     (  
	       @SaudaDate  VARCHAR(10)
	  )  
  
     AS  
  
   BEGIN  
       
   	Select @SaudaDate = Ltrim(Rtrim(@SaudaDate))        

      If Len(@SaudaDate) = 10         
			Set @SaudaDate = Convert(CHAR(11), Convert(DateTime, @SaudaDate, 103), 109)    
      
       
     SELECT   
       ToExchange.Rec_Type,   
       ToExchange.Sell_BuyFlag,   
       ToExchange.Sett_Type,   
       ToExchange.Sett_No,  
       ToExchange.Sec_Symbol,   
       ToExchange.Security_Series,    
       ToExchange.CP_Code,  
       ToExchange.Allocated_Qty,  
       ToExchange.Allocated_Value,  
       ToExchange.CP_Code1,  
       ToExchange.Cont_NoteNo,  
       ToExchange.Otr_no,   
       netrate = (allocated_value/Allocated_qty),  
       Diffqty,  
       Diffamt   
     FROM   
       ToExchange ,   
       (SELECT F.Rec_Type,   
       F.Sell_BuyFlag,   
       F.Sett_Type,   
       F.Sett_No,  
       F.Sec_Symbol,    
       F.Security_Series,   
       F.CP_Code,   
       DiffQty = F.Oblig_Qty  - SUM(Allocated_Qty),Diffamt = F.Oblig_Value - SUM(Allocated_Value)   
     FROM   
       FromExchange F,ToExchange T WHERE    
       T.Rec_type = 10   
       and F.Rec_Type = T.Rec_Type   
       and F.Sell_BuyFlag = T.Sell_BuyFlag   
       And F.Sett_Type = T.Sett_Type  
       And F.Sett_No = T.Sett_No    
       And F.Sec_Symbol = T.Sec_Symbol   
       And F.Security_Series = T.Security_Series   
       And F.CP_Code = T.CP_Code And sauda_date like  + @SaudaDate + '%'  
     GROUP BY   
       F.Rec_Type,   
       F.Sell_BuyFlag,   
       F.Sett_Type,   
       F.Sett_No,  
       F.Sec_Symbol,   
       F.Security_Series,   
       F.CP_Code,F.Oblig_Qty ,  
       F.Oblig_Value   
       ) S   
     WHERE sauda_date LIKE + @SaudaDate + '%' AND ToExchange.cp_code = 'INST'   
       AND   
       S.Rec_type = 10   
       AND S.Sett_type = ToExchange.Sett_Type   
       AND S.Sett_no = ToExchange.Sett_no   
       AND S.Sec_symbol = ToExchange.Sec_Symbol   
       AND S.Security_Series = ToExchange.Security_series   
       AND S.Sell_buyFlag = Toexchange.sell_buyFlag   
     ORDER BY   
       ToExchange.Sett_Type,   
       ToExchange.Sett_No,ToExchange.Sec_Symbol  
       
     END

GO
