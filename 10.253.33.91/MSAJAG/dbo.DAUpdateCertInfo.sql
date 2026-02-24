-- Object: PROCEDURE dbo.DAUpdateCertInfo
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.DAUpdateCertInfo    Script Date: 3/17/01 9:55:50 PM ******/

/****** Object:  Stored Procedure dbo.DAUpdateCertInfo    Script Date: 3/21/01 12:50:06 PM ******/

/****** Object:  Stored Procedure dbo.DAUpdateCertInfo    Script Date: 20-Mar-01 11:38:48 PM ******/

/****** Object:  Stored Procedure dbo.DAUpdateCertInfo    Script Date: 2/5/01 12:06:11 PM ******/

/****** Object:  Stored Procedure dbo.DAUpdateCertInfo    Script Date: 12/27/00 8:58:49 PM ******/

/* Date :  09/07/2000
  This Procedure is used for Client Allocation in Certinfo 
  Used in the DeliveryAllocation module    */
CREATE PROCEDURE  DAUpdateCertInfo 
 (  @SettNo varchar(7),
    @SettType varchar(1),
    @TargetParty varchar(10),
    @ScripCd  varchar(10) , 
    @Series varchar(3) ,
    @Certno  varchar(15) ,
    @FolioNo varchar(15) ,
    @FromNo varchar(20),
    @Reason varchar(20)
 )
as
 update certinfo set TargetParty  = @TargetParty , reason = @reason
  where sett_no = @SettNo and Sett_type = @SettType
  and scrip_cd  = @ScripCd and series = @Series and certno =@Certno  and foliono = @FolioNo  and fromno = @FromNo

GO
