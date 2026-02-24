-- Object: PROCEDURE dbo.InsDelivery
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------








/****** Object:  Stored Procedure dbo.InsDelivery    Script Date: 05/08/2002 12:35:04 PM ******/




/****** Object:  Stored Procedure dbo.InsDelivery    Script Date: 4/12/01 1:05:15 PM ******/
CREATE procedure InsDelivery

       @Sett_No                  varchar(7)          ,         
       @Sett_type                varchar(2)          ,         
       @RefNo                    int                 ,         
       @TCode                    numeric(18,0)       ,         
       @TrType                   numeric(18,0)       ,         
       @Party_Code               varchar(10)         ,         
       @scrip_cd                 varchar(12)         ,         
       @series                   varchar(3)          ,         
       @Qty                      numeric(18,0)       ,         
       @FromNo                   varchar(16)         = null,   
       @ToNo                     varchar(16)         = null,   
       @CertNo                   varchar(16)         = null,   
       @FolioNo                  varchar(16)         = null,   
       @HolderName               varchar(35)         = null,   
       @Reason                   varchar(20)         ,         
       @DrCr                     char(1)             ,         
       @Delivered                char(1)             ,         
       @OrgQty                   numeric(18,0)       = null,   
       @DpType                   varchar(10)         = null,   
       @DpId                     varchar(16)         = null,   
       @CltDpId                  varchar(16)         = null,   
       @BranchCd                 varchar(10)         ,         
       @PartipantCode            varchar(10)         ,         
       @SlipNo                   numeric(18,0)       = null,   
       @BatchNo                  varchar(10)         = null,   
       @ISett_No                 varchar(7)          = null,   
       @ISett_Type               varchar(2)          = null,   
       @ShareType                varchar(8)          = null,   
       @TransDate                datetime            ,         
       @Filler1                  varchar(2)          = null,   
       @Filler2                  varchar(2)          = null,   
       @Filler3                  varchar(2)          = null    

as

       declare @procname varchar(50)
       select @procname = object_name(@@procid)

       begin transaction trnInss

              begin
                     insert into deltrans(
                                          Sett_No,
                                          Sett_type,
                                          RefNo,
                                          TCode,
                                          TrType,
                                          Party_Code,
                                          scrip_cd,
                                          series,
                                          Qty,
                                          FromNo,
                                          ToNo,
                                          CertNo,
                                          FolioNo,
                                          HolderName,
                                          Reason,
                                          DrCr,
                                          Delivered,
                                          OrgQty,
                                          DpType,
                                          DpId,
                                          CltDpId,
                                          BranchCd,
                                          PartipantCode,
                                          SlipNo,
                                          BatchNo,
                                          ISett_No,
                                          ISett_Type,
                                          ShareType,
                                          TransDate,
                                          Filler1,
                                          Filler2,
                                          Filler3,
 		          	  BDpType,
	   	               BDpId,
                                          BCltDpId,
                                          Filler4,
                                          Filler5
                                          )
                     select
                                          @Sett_No,
                                          @Sett_type,
                                          @RefNo,
                                          @TCode,
                                          @TrType,
                                          @Party_Code,
                                          @scrip_cd,
                                          @series,
                                          @Qty,
                                          @FromNo,
                                          @ToNo,
                                          @CertNo,
                                          @FolioNo,
                                          @HolderName,
                                          @Reason,
                                          @DrCr,
                                          @Delivered,
                                          @OrgQty,
                                          @DpType,
                                          @DpId,
                                          @CltDpId,
                                          @BranchCd,
                                          @PartipantCode,
                                          @SlipNo,
                                          @BatchNo,
                                          @ISett_No,
                                          @ISett_Type,
                                          @ShareType,
                                          @TransDate,
                                          @Filler1,
                                          1,
                                          @Filler3,
                                           '','','',0,0                          

                     if @@error != 0
                            begin
                                   rollback transaction trnInss
                                   raiserror('Error inserting into table deltrans.  Error occurred in procedure %s.  Rolling back transaction...', 16, 1, @procname)
                                   return
                            end
                     else
                            begin
                                   commit transaction trnInss
                            end
              end

GO
