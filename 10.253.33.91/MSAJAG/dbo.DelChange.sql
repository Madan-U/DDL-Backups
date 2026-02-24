-- Object: PROCEDURE dbo.DelChange
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.DelChange    Script Date: 3/17/01 9:55:50 PM ******/

/****** Object:  Stored Procedure dbo.DelChange    Script Date: 3/21/01 12:50:06 PM ******/

/****** Object:  Stored Procedure dbo.DelChange    Script Date: 20-Mar-01 11:38:49 PM ******/

/****** Object:  Stored Procedure dbo.DelChange    Script Date: 2/5/01 12:06:11 PM ******/

/****** Object:  Stored Procedure dbo.DelChange    Script Date: 12/27/00 8:58:49 PM ******/

CREATE Procedure DelChange
 @FromParty varchar(10) , @Toparty varchar(10) , @Scrip_cd  varchar(12) , @series char(2) , @sett_no  varchar(7) , @sett_type char(2)  as 
update 
  deliveryclt set qty = tradeqty ,
  inout = case  when tradeqty > 0
                      then     "O"
          when tradeqty < 0
    then   "I"
          else
              "N"
 End
 from insdeltblview i , deliveryclt d 
 where  d.series = i.series
 and  i.party_code = d.party_code 
 and i.scrip_cd = d.scrip_cd
and i.series = d.series
and d.sett_no = i.sett_no
and d.sett_type = i.sett_type
and d.sett_no = @sett_no
and d.sett_type = @sett_type
and d.party_code in ( @FromParty ,@Toparty)
 and d.scrip_cd = @scrip_cd

GO
