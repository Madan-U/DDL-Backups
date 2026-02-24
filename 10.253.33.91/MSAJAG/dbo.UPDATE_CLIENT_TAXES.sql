-- Object: PROCEDURE dbo.UPDATE_CLIENT_TAXES
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc [dbo].[UPDATE_CLIENT_TAXES]  
AS  
BEGIN  
/*  
update Clienttaxes_New set Turnover_Tax='0.003150'  
where Todate > getdate() and Turnover_Tax <>'0.003150'  
  
update F set Fut_Turnover_Tax ='0.001850', Opt_Turnover_Tax ='0.050000'  
 from angelfo.nsefo.dbo.foClienttaxes F with (nolock)  
where date_to > getdate() and ( Fut_Turnover_Tax <> '0.001850' or  Opt_Turnover_Tax <>'0.050000')  
  
update B set Fut_Turnover_Tax ='0.0009000000' ,Opt_Turnover_Tax = '0.0350000000'  
 from angelfo.nsecurfo.dbo.foClienttaxes B with (nolock)  
where date_to > getdate() and( Fut_Turnover_Tax <> '0.0009000000' or Opt_Turnover_Tax <> '0.0350000000')  
  
  
*/  
--update Clienttaxes_New set  Sebiturn_Tax ='0.000050'  
  
--select *  from Clienttaxes_New  
update Clienttaxes_New set  Sebiturn_Tax ='0.00010'  
WHERE Sebiturn_Tax <>'0.00010'AND Todate > getdate()  
--9634990  
----9634942  
--select count(*) from Clienttaxes_New  
--WHERE TODATE LIKE 'DEC 31 2049%'  
-- AND Sebiturn_Tax > 0   
  
  
update [AngelBSECM].BSEDB_AB.DBO.Clienttaxes_New set  Sebiturn_Tax ='0.00010'  
WHERE Sebiturn_Tax <>'0.00010'AND Todate > getdate()  
  
update angelfo.nsefo.dbo.foClienttaxes set Fut_Sebiturn_Tax ='0.00010',Opt_Sebiturn_Tax='0.00010' where date_to>getdate()  
and Fut_Sebiturn_Tax <>'0.00010'  
  
  
update angelfo.nsecurfo.dbo.foClienttaxes set Fut_Sebiturn_Tax ='0.00010',Opt_Sebiturn_Tax='0.00010' where date_to>getdate()  
and Fut_Sebiturn_Tax <>'0.00010'  
 
 
 ------------------------ 20220816 -----  -----
    UPDATE A 
    SET A.Del_Tran_Chrgs = B.Turnover_tax ,
        A.Imp_Status =0  ,
        A.Modifiedon = GETDATE()
    FROm 
    Client_brok_Details A WITH(NOLOCK)  
    INNER JOIN client_master_taxes B ON A.Exchange =B.Exchange AND A.Segment=B.Segment
    where Del_Tran_Chrgs =0.00 AND InActive_From >GETDATE() --Cl_Code ='A19570'
    AND B.Segment <>'SLBS' --AND A.Exchange <>'NSX'
    AND A.Exchange IN ('NSE','BSE') AND 	A.Segment ='CAPITAL'
  
END

GO
