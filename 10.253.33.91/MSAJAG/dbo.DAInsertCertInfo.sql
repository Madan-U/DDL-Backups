-- Object: PROCEDURE dbo.DAInsertCertInfo
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.DAInsertCertInfo    Script Date: 3/21/01 12:50:06 PM ******/
/****** Object:  Stored Procedure dbo.DAInsertCertInfo    Script Date: 20-Mar-01 11:38:48 PM ******/
/****** Object:  Stored Procedure dbo.DAInsertCertInfo    Script Date: 2/5/01 12:06:11 PM ******/
/****** Object:  Stored Procedure dbo.DAInsertCertInfo    Script Date: 12/27/00 8:59:06 PM ******/
/* modified by bhagyashree for dematdelivery allocation*/
/* Date :  09/07/2000
  This Procedure is used for Client Allocation in Certinfo 
  Inserts a new Record into CertInfo Table
  Used in the DeliveryAllocation module    */
CREATE PROCEDURE  DAInsertCertInfo 
 (  
    @Flag int  ,
    @SettNo varchar(7),
    @SettType varchar(1),
    @TargetParty varchar(10),
    @ScripCd  varchar(10) , 
    @Series varchar(3) ,
    @Certno  varchar(15) ,
    @FolioNo varchar(15) ,
    @FromNo varchar(20),
    @Reason varchar(20),
    @RemQty numeric(9,2),
    @oldqty numeric(9,2) ,
    @RecNo numeric(9,2),
    @party_code varchar(10),
    @Sdate Varchar(11),
    @orgQty numeric(9,2),
    @Subrecno numeric(9,2),
    @qty numeric(9,2) 
 )
as
 if @flag = 1 
  Begin
    insert into certinfo 
    Select Sett_no ,Sett_type, scrip_cd , series ,@remqty , party_code, date,fromno,tono, @reason,
                  certno,foliono, holdername, @TargetParty ,inout, Delivered, PSettNo ,Psett_Type ,@recno+1, orgqty , recieptno+1,DpType,PODpId,POCltNo,SlipNo
     from certinfo 
     where sett_no = @SettNo  and sett_type = @SettType  and scrip_cd  = @ScripCd 
     and series = @series  and certno = @certno  and foliono = @folioNo  and fromno = @FromNo and recieptno = @recno
     and party_code = @party_code and left(convert(varchar,Date,109),11) like @sdate + '%' and orgqty = @orgqty and subrecno = @subrecno and qty = @qty and targetparty = 1
    Update certinfo set qty = @oldqty  where sett_no = @SettNo  and sett_type = @SettType  and scrip_cd  = @ScripCd 
     and series = @series  and certno = @certno  and foliono = @folioNo  and fromno = @FromNo and recieptno = @recno
     and party_code = @party_code and left(convert(varchar,Date,109),11) like @sdate + '%' and orgqty = @orgqty and subrecno = @subrecno and qty = @qty and targetparty = 1
  End
 Else if @flag=2 
   update certinfo set TargetParty  = @TargetParty , reason = @reason 
 where sett_no = @SettNo  and sett_type = @SettType  and scrip_cd  = @ScripCd 
     and series = @series  and certno = @certno  and foliono = @folioNo  and fromno = @FromNo and recieptno = @recno
     and party_code = @party_code and  left(convert(varchar,Date,109),11)  like @sdate + '%' and orgqty = @orgqty and subrecno = @subrecno and qty = @qty and targetparty = 1
 else if @flag = 3
   Begin
           update certinfo set DELIVERED = 'D', REASON = 'Carry Forward' 
           Where  Sett_no =@SettNo and sett_type = @SettType and targetparty = @TargetParty and scrip_cd =@ScripCd  and series = @Series
           and left(convert(varchar,Date,109),11) like @sdate 
                  
   End
 else  if @flag = 4
        select c.scrip_cd ,c.series,d.deliver_Qty , d.entitycode , 0
         from certinfo c , delivery d where entitycode not in 
                                              (  select  targetparty from certinfo  where certinfo.scrip_cd = d.scrip_cd and sett_no =@SettNo
                                                  And sett_type =  @SettType
                                               )
                                               and c.sett_no = @SettNo And c.sett_type = @SettType and d.scrip_cd = c.scrip_cd 
                                              and d.series = c.series AND D.SETT_NO = C.SETT_NO  and d.sett_type = c.sett_type 
                                              group by c.scrip_cd ,c.series, entitycode , deliver_qty , rec_centre  order by rec_centre desc 
Else  if @flag = 5 
    insert into certinfo
   select @settno,@setttype, scrip_cd , series ,qty , party_code, date , fromno,tono, reason , certno,foliono,holdername ,
    '1' , inout, '0' , Sett_No, sett_Type, recieptno, 0 ,0 ,DpType,PODpId,POCltNo,SlipNo
    from certinfo where  sett_no = '0' and sett_type = 'NO' and targetparty = '1'

GO
