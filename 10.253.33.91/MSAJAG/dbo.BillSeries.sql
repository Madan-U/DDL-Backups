-- Object: PROCEDURE dbo.BillSeries
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.BillSeries    Script Date: 3/17/01 9:55:44 PM ******/

/****** Object:  Stored Procedure dbo.BillSeries    Script Date: 3/21/01 12:50:00 PM ******/

/****** Object:  Stored Procedure dbo.BillSeries    Script Date: 20-Mar-01 11:38:43 PM ******/

/****** Object:  Stored Procedure dbo.BillSeries    Script Date: 2/5/01 12:06:07 PM ******/

/****** Object:  Stored Procedure dbo.BillSeries    Script Date: 12/27/00 8:58:43 PM ******/

/****** Object:  Stored Procedure dbo.BillSeries    Script Date: 12/18/99 8:24:03 AM ******/
/*Sarika : For bill printing checks if the bills are in nodelivery and within settlement*/
 Create procedure BillSeries as
 SELECT distinct settlement.sett_no,sett_mst.sett_type ,Party_code, scrip_cd,settlement.series
 from settlement,sett_mst where
 settlement.scrip_cd not in (select distinct nodel.scrip_cd from nodel , settlement
 Where settlement.scrip_cd = nodel.scrip_cd and settlement.series = nodel.series
 and settlement.sauda_date between nodel.start_date and nodel.end_date)
 and settlement.sauda_date between sett_mst.start_date and sett_mst.end_date 
 and sett_MST.SETT_TYPE = 
         ( 
    case    
   when settlement.series = 'AE' /* and sett_mst.markettype = '2' */
   then 
   'M'
   
   when settlement.series = 'BE' /* and sett_mst.markettype = '2' */
   then 
    'W'
   when settlement.series = 'TT' 
   then 
    'O'
   when  settlement.series <> 'AE' and settlement.series <> 'BE' and settlement.markettype  = '1'
   then  
   'NRM'
   end)
/*  convert(char,sett_mst.end_Date,103) like convert(char,getdate(),103)*/

GO
